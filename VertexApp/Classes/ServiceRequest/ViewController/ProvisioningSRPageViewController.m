//
//  ProvisioningSRPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 5/22/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ProvisioningSRPageViewController.h"
#import "ServiceRequestViewController.h"
#import "HomePageViewController.h"


@interface ProvisioningSRPageViewController ()

@end

@implementation ProvisioningSRPageViewController

@synthesize provisioningSRPageScroller;
@synthesize scrollViewHeight;

@synthesize assetLabel;
@synthesize assetField;

@synthesize lifecycleLabel;
@synthesize lifecycleField;

@synthesize serviceLabel;
@synthesize serviceField;

@synthesize estimatedCostLabel;
@synthesize estimatedCostField;

@synthesize dateRequestedLabel;
@synthesize dateRequestedField;

@synthesize priorityLabel;
@synthesize priorityField;

@synthesize requestorLabel;
@synthesize requestorField;

@synthesize adminLabel;
@synthesize adminField;

@synthesize notesLabel;
@synthesize notesTextArea;

@synthesize schedulesLabel;

@synthesize tasksLabel;
@synthesize personnelField;

@synthesize actionSheet;
@synthesize personnelPicker;

@synthesize personnels;

@synthesize personnelNameArray;
@synthesize personnelIdArray;

@synthesize selectedPersonnelId;
@synthesize selectedPersonnelName;

@synthesize addNotesButtonFrame;
@synthesize schedulesLabelFrame;
@synthesize statusLabelFrame;
@synthesize statusFieldFrame;
@synthesize authorLabelFrame;
@synthesize authorFieldFrame;

@synthesize fromDateLabelFrame;
@synthesize fromDateFieldFrame;
@synthesize fromTimeLabelFrame;
@synthesize fromTimeFieldFrame;
@synthesize toDateLabelFrame;
@synthesize toDateFieldFrame;
@synthesize toTimeLabelFrame;
@synthesize toTimeFieldFrame;

@synthesize separatorFrame;
@synthesize taskSeparatorFrame;

@synthesize tasksLabelFrame;
@synthesize taskNameLabelFrame;
@synthesize taskNameFieldFrame;
@synthesize taskDescriptionLabelFrame;
@synthesize taskDescriptionAreaFrame;
@synthesize personnelLabelFrame;
@synthesize personnelFieldFrame;
@synthesize taskStatusLabelFrame;
@synthesize addTasksButtonFrame;

@synthesize taskNameArray;
@synthesize taskDescriptionArray;
@synthesize personnelArray;
@synthesize taskStatusArray;

@synthesize userId;

@synthesize serviceRequestId;
@synthesize serviceRequestInfo;

@synthesize statusId;

@synthesize notesTextAreaArray;
@synthesize provisioningNotesArray;
@synthesize schedulesStatusArray;
@synthesize schedulesAuthorArray;

@synthesize serviceRequestJson;
@synthesize tasksJson;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize cancelSRProvisioningConfirmation;

@synthesize addNotesButton;
@synthesize addTasksButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  NSLog(@"Service Request Provisioning");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Back] navigation button
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Back"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(cancelProvisioningSR)];
  
  //[Save] navigation button
  UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Save"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(saveProvisioningSR)];
  
  self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:
                                              backButton
                                            , saveButton
                                            , nil];
  
  //[Complete] navigation button
  UIBarButtonItem *completeButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Complete"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(completeSR)];
  
  //[Close] navigation button
  UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Close"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(closeSR)];
  
  //Initialize bar button items
  self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:
                                               completeButton
                                             , closeButton
                                             , nil];
  
  //Disable these buttons
  completeButton.enabled = NO;
  closeButton.enabled    = NO;
  
  //Scroller size
  //provisioningSRPageScroller.contentSize = CGSizeMake(320.0, 5000);
  [self setScrollerSize];
  
  //Disable fields - for viewing only
  assetField.enabled         = NO;
  lifecycleField.enabled     = NO;
  serviceField.enabled       = NO;
  dateRequestedField.enabled = NO;
  priorityField.enabled      = NO;
  estimatedCostField.enabled = NO;
  requestorField.enabled     = NO;
  adminField.enabled         = NO;
  
  //Populate fields based on previously selected Service Request for Provisioning Stage
  [self getServiceRequest];
  
  //Get logged user userAccountInformation
  userAccountInfoSQLManager = [UserAccountInfoManager alloc];
  userAccountsObject = [UserAccountsObject alloc];
  userAccountsObject = [userAccountInfoSQLManager getUserAccountInfo];
  
  userId = userAccountsObject.userId;
  NSLog(@"Provisioning SR - userId: %@", userId);
  
  //Initialize array for provisioning notes
  provisioningNotesArray = [[NSMutableArray alloc] init];
  
  //Initialize array for tasks
  taskNameArray        = [[NSMutableArray alloc] init];
  taskDescriptionArray = [[NSMutableArray alloc] init];
  personnelArray       = [[NSMutableArray alloc] init];
  taskStatusArray      = [[NSMutableArray alloc] init];
  
  //Initializations for the Personnel picker
  personnelArray     = [[NSMutableArray alloc] init];
  personnelNameArray = [[NSMutableArray alloc] init];
  personnelIdArray   = [[NSMutableArray alloc] init];
  
  //Get Personnels endpoint connection to populate Personnel Picker
  [self getPersonnels];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Adjust page scroller height depending on number of elements in view
-(void) setScrollerSize
{
  scrollViewHeight = 0.0;
  for (UIView *view in provisioningSRPageScroller.subviews)
  {
    scrollViewHeight += view.frame.size.height;
  }
  NSLog(@"scroller height: %f", scrollViewHeight);
  [provisioningSRPageScroller setContentSize:(CGSizeMake(320, scrollViewHeight))];
}


#pragma mark - Set Service Request ID to the selected serviceRequestId from previous page
- (void) setServiceRequestId:(NSNumber *) srIdFromPrev
{
  serviceRequestId = srIdFromPrev;
  NSLog(@"ProposalSRPage - serviceRequestId: %@", serviceRequestId);
}


#pragma mark - [Cancel] button implementation
-(void) cancelProvisioningSR
{
  NSLog(@"Cancel Service Request Provisioning");
  
  cancelSRProvisioningConfirmation = [[UIAlertView alloc]
                                          initWithTitle:@"Cancel Service Request Provisioning"
                                                message:@"Are you sure you want to cancel this service request provisioning?"
                                               delegate:self
                                      cancelButtonTitle:@"Yes"
                                      otherButtonTitles:@"No", nil];
  
  [cancelSRProvisioningConfirmation show];
}


#pragma mark - Transition to a page depending on what alert box is shown and what button is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if([alertView isEqual:cancelSRProvisioningConfirmation])
  {
    NSLog(@"Cancel SR Provisioning");
    if(buttonIndex == 0) //Yes - Cancel
    {
      //Go back to SR Page
      ServiceRequestViewController *controller = (ServiceRequestViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SRPage"];
      
      [self.navigationController pushViewController:controller animated:YES];
    }
  }
  else
  {
    if (buttonIndex == 0) //OK
    {
      //Go back to Home
      HomePageViewController *controller = (HomePageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
      
      [self.navigationController pushViewController:controller animated:YES];
    }
  }
}


#pragma mark - Get Service Request by serviceRequestId
-(void) getServiceRequest
{
  //endpoint for getServiceRequest/{serviceRequestId}
  NSMutableString *urlParams = [NSMutableString stringWithFormat:@"http://192.168.2.107/vertex-api/service-request/getServiceRequest/%@", serviceRequestId];
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:urlParams]];
  
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [getRequest setHTTPMethod:@"GET"];
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:getRequest
                                        delegate:self];
  [connection start];
  
  NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
  NSError *error = [[NSError alloc] init];
  
  NSData *responseData = [NSURLConnection
                          sendSynchronousRequest:getRequest
                               returningResponse:&urlResponse
                                           error:&error];
  
  if(responseData == nil)
  {
    //Show an alert if connection is not available
    UIAlertView *connectionAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Warning"
                                              message:@"No network connection detected. Displaying data from phone cache."
                                             delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [connectionAlert show];
    
    //Connect to CoreData for local data
    //!- FOR TESTING ONLY -!
    assetField.text         = @"Demo - myAircon";
    lifecycleField.text     = @"Demo - repair";
    serviceField.text       = @"Repair filter";
    estimatedCostField.text = @"Demo = Php 500.00";
    dateRequestedField.text = @"2013-05-05";
    priorityField.text      = @"High";
    requestorField.text     = @"Steve Jobs";
    adminField.text         = @"Admin - Tim Cook";
    notesTextArea.text      = @"Filter is dirty";
    
  }
  else
  {
    serviceRequestInfo = [NSJSONSerialization
                          JSONObjectWithData:responseData
                                     options:kNilOptions
                                       error:&error];
    
    NSLog(@"getServiceRequest JSON Result: %@", serviceRequestInfo);
    
    assetField.text         = [[serviceRequestInfo valueForKey:@"asset"] valueForKey:@"name"];
    lifecycleField.text     = [[serviceRequestInfo valueForKey:@"lifecycle"] valueForKey:@"name"];
    serviceField.text       = [[serviceRequestInfo valueForKey:@"service"] valueForKey:@"name"];
    estimatedCostField.text = [serviceRequestInfo valueForKey:@"cost"];
    dateRequestedField.text = [serviceRequestInfo valueForKey:@"createdDate"];
    priorityField.text      = [[serviceRequestInfo valueForKey:@"priority"] valueForKey:@"name"];
    
    //Set requestor name
    NSMutableString *requestorName = [NSMutableString stringWithFormat:@"%@ %@ %@ %@"
                                      , [[[serviceRequestInfo valueForKey:@"requestor"] valueForKey:@"info"] valueForKey:@"firstName"]
                                      , [[[serviceRequestInfo valueForKey:@"requestor"] valueForKey:@"info"] valueForKey:@"middleName"]
                                      , [[[serviceRequestInfo valueForKey:@"requestor"] valueForKey:@"info"] valueForKey:@"lastName"]
                                      , [[[serviceRequestInfo valueForKey:@"requestor"] valueForKey:@"info"] valueForKey:@"suffix"]];
    requestorField.text = requestorName;
    
    //Set admin name
    NSMutableString *adminName = [NSMutableString stringWithFormat:@"%@ %@ %@ %@"
                                  , [[[serviceRequestInfo valueForKey:@"admin"] valueForKey:@"info"] valueForKey:@"firstName"]
                                  , [[[serviceRequestInfo valueForKey:@"admin"] valueForKey:@"info"] valueForKey:@"middleName"]
                                  , [[[serviceRequestInfo valueForKey:@"admin"] valueForKey:@"info"] valueForKey:@"lastName"]
                                  , [[[serviceRequestInfo valueForKey:@"admin"] valueForKey:@"info"] valueForKey:@"suffix"]];
    adminField.text = adminName;
    
    //Retrieving notes for display - Notes can be more than one
    NSMutableArray *retrievedNotesArray = [[NSMutableArray alloc] init];
    retrievedNotesArray = [serviceRequestInfo valueForKey:@"notes"];
    NSMutableString *notesDisplay = [[NSMutableString alloc] init];
    
    for (int i = 0; i < retrievedNotesArray.count; i++)
    {
      NSMutableDictionary *retrievedNotesDictionary = [[NSMutableDictionary alloc] init];
      [retrievedNotesDictionary setObject:[retrievedNotesArray objectAtIndex:i] forKey:@"notes"];
      
      NSMutableString *notesAuthor = [NSMutableString stringWithFormat:@"%@ %@ %@ %@"
                                      , [[[[retrievedNotesDictionary valueForKey:@"notes"] valueForKey:@"sender"] valueForKey:@"info"] valueForKey:@"firstName"]
                                      , [[[[retrievedNotesDictionary valueForKey:@"notes"] valueForKey:@"sender"] valueForKey:@"info"] valueForKey:@"middleName"]
                                      , [[[[retrievedNotesDictionary valueForKey:@"notes"] valueForKey:@"sender"] valueForKey:@"info"] valueForKey:@"lastName"]
                                      , [[[[retrievedNotesDictionary valueForKey:@"notes"] valueForKey:@"sender"] valueForKey:@"info"] valueForKey:@"suffix"]];
      
      NSMutableString *noteMessage = [[retrievedNotesDictionary valueForKey:@"notes"] valueForKey:@"message"];
      NSMutableString *noteDate    = [[retrievedNotesDictionary valueForKey:@"notes"] valueForKey:@"creationDate"];
      
      //Combined information for display in the Notes area
      notesDisplay = [NSMutableString stringWithFormat:@"Sender: %@\nDate: %@\n\n%@"
                      , notesAuthor
                      , noteDate
                      , noteMessage];
      
      if (i == 0)
      {
        //Store first Note entry in the defined notesTextArea
        notesTextArea.text = notesDisplay;
        notesTextAreaArray = [[NSMutableArray alloc] init];
        [notesTextAreaArray addObject:notesTextArea];
      }
      else
      {
        [self displayNotesEntries:notesDisplay];
      }
    }
    
    //!!! TODO - Retrieve values for Schedules
    NSMutableArray *retrievedSchedulesArray = [[NSMutableArray alloc] init];
    retrievedSchedulesArray = [serviceRequestInfo valueForKey:@"schedules"];
    
    for(int i = 0; i < retrievedSchedulesArray.count; i++)
    {
      NSMutableDictionary *retrievedSchedulesDictionary = [[NSMutableDictionary alloc] init];
      [retrievedSchedulesDictionary setObject:[retrievedSchedulesArray objectAtIndex:i] forKey:@"schedules"];
      NSLog(@"retrievedSchedulesDictionary: %@", retrievedSchedulesDictionary);
      
      //Status
      NSMutableString *scheduleStatus = [[NSMutableString alloc] init];
      scheduleStatus = [[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"status"] valueForKey:@"name"];
      
      //Author
      NSMutableString *scheduleAuthor = [NSMutableString stringWithFormat:@"%@ %@ %@ %@"
                                         , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"firstName"]
                                         , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"middleName"]
                                         , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"lastName"]
                                         , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"suffix"]];
      
      //First display
      CGRect startingCoordinates;
      startingCoordinates.origin.x = 16;
      if(i == 0)
      {
        startingCoordinates.origin.y = (schedulesLabel.frame.origin.y + 30);
      }
      else
      {
        startingCoordinates.origin.y = (separatorFrame.origin.y);
      }
      
      //Display retrieved values
      [self displayScheduleEntries:scheduleStatus
                                  :scheduleAuthor
                                  :[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"periods"]
                                  :startingCoordinates];
    }
    
    //Display fields for 'Tasks' area
    [self displayTasks];
  }
}


#pragma mark - Endpoint connection /getUserById
-(NSString *) getUserById
{
  NSMutableString *urlParams = [NSMutableString stringWithFormat:@"http://192.168.2.113/vertex-api/user/getUserById/%@", userId];
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:urlParams]];
  
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [getRequest setHTTPMethod:@"GET"];
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:getRequest
                                        delegate:self];
  [connection start];
  
  NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
  NSError *error = [[NSError alloc] init];
  
  NSData *responseData = [NSURLConnection
                          sendSynchronousRequest:getRequest
                               returningResponse:&urlResponse
                                           error:&error];
  
  NSString *authorName;
  if(responseData == nil)
  {
    authorName = @"Tim Cook";
  }
  else
  {
    NSMutableDictionary *authorInfo = [[NSMutableDictionary alloc] init];
    authorInfo = [NSJSONSerialization
                  JSONObjectWithData:responseData
                             options:kNilOptions
                               error:&error];
    
    authorName = [NSString stringWithFormat:@"%@ %@ %@ %@"
                  , [[authorInfo valueForKey:@"info"] valueForKey:@"firstName"]
                  , [[authorInfo valueForKey:@"info"] valueForKey:@"middleName"]
                  , [[authorInfo valueForKey:@"info"] valueForKey:@"lastName"]
                  , [[authorInfo valueForKey:@"info"] valueForKey:@"suffix"]];
    
  }
  
  return authorName;
}


#pragma mark - Display multiple 'Notes' entries from response JSON
- (void) displayNotesEntries: (NSString *) noteText
{
  NSLog(@"Display multiple note entries");
  
  //Initialize Notes text area frame size
  int height = 120;
  int width  = 284;
  
  UITextView *newNoteTextArea     = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
  newNoteTextArea.backgroundColor = notesTextArea.backgroundColor;
  [newNoteTextArea setFont:[UIFont systemFontOfSize:14]];
  
  //Set the text of Notes area
  newNoteTextArea.text = noteText;
  
  //Get the location of prev Notes text area and adjust new Notes area location based on that
  UITextView *prevNoteTextView = [[UITextView alloc] init];
  prevNoteTextView      = [notesTextAreaArray lastObject];
  CGRect noteFrame      = newNoteTextArea.frame;
  noteFrame.origin.x    = 17;
  noteFrame.origin.y    = (prevNoteTextView.frame.origin.y + 130);
  newNoteTextArea.frame = noteFrame;
  
  //Add Notes text area in view
  [provisioningSRPageScroller addSubview:newNoteTextArea];
  
  //Store added Notes text area in array
  [notesTextAreaArray addObject:newNoteTextArea];
  
  //Adjust position of [Add Notes] button when new text area is added
  addNotesButtonFrame          = addNotesButton.frame;
  addNotesButtonFrame.origin.x = 20;
  addNotesButtonFrame.origin.y = (newNoteTextArea.frame.origin.y + 130);
  addNotesButton.frame         = addNotesButtonFrame;
  
  //Move all element below the added notesTextArea
  [self adjustFieldAfterNotes];
}


#pragma mark - [Add Notes] button functionality
- (IBAction)addNotes:(id)sender
{
  NSLog(@"addNotes");
  
  //Initialize Notes text area frame size
  int height = 120;
  int width  = 284;
  
  UITextView *newNoteTextArea     = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
  newNoteTextArea.backgroundColor = notesTextArea.backgroundColor;
  [newNoteTextArea setFont:[UIFont systemFontOfSize:14]];
  
  //Get the location of prev Notes text area and adjust new Notes area location based on that
  UITextView *prevNoteTextView = [[UITextView alloc] init];
  NSLog(@"notesTextAreaArray: %@", notesTextAreaArray);
  prevNoteTextView      = [notesTextAreaArray lastObject];
  CGRect noteFrame      = newNoteTextArea.frame;
  noteFrame.origin.x    = 17;
  noteFrame.origin.y    = (prevNoteTextView.frame.origin.y + 130);
  newNoteTextArea.frame = noteFrame;
  
  //Add Notes text area in view
  [provisioningSRPageScroller addSubview:newNoteTextArea];
  
  //Store added Notes text view in ALL Notes array - to track placement of text views when adding new notes
  [notesTextAreaArray addObject:newNoteTextArea];
  
  //Store added Notes text view in array for service request proposal notes
  [provisioningNotesArray addObject:newNoteTextArea];
  
  //Adjust position of [Add Notes] button when new text area is added
  addNotesButtonFrame          = addNotesButton.frame;
  addNotesButtonFrame.origin.x = 20;
  addNotesButtonFrame.origin.y = (newNoteTextArea.frame.origin.y + 130);
  addNotesButton.frame         = addNotesButtonFrame;
  
  //Adjust scroller height
  [self setScrollerSize];
  
  //Move all element below the added notesTextArea
  [self adjustFieldAfterNotes];
}


#pragma mark - Adjust aligment and placement of elements after the added Note / multiple Note entries
- (void) adjustFieldAfterNotes
{
  NSLog(@"adjustFieldAfterNotes");
  
  //Move the Y coordinate of the elements, X remains constant
  //[Add Notes] button location is the starting coordinate
  
  //Schedules Label
  schedulesLabelFrame          = schedulesLabel.frame;
  schedulesLabelFrame.origin.x = 16;
  schedulesLabelFrame.origin.y = (addNotesButtonFrame.origin.y + 70);
  schedulesLabel.frame         = schedulesLabelFrame;
  
  //Move the fields and labels after the 'Schedules' label
  for (int i = 0; i < [provisioningSRPageScroller.subviews count]; i++)
  {
    if([[[provisioningSRPageScroller subviews] objectAtIndex:i] isEqual:schedulesLabel])
    {
      int y = 1; //Multiplier to move the y coordinates
      CGRect labelFrame;
      CGRect fieldFrame;
      //CGRect viewFrame;
      
      for(int j = i++; j < [provisioningSRPageScroller.subviews count]; j++) //Begin at element after schedulesLabel
      {
        if([[[provisioningSRPageScroller subviews] objectAtIndex:j] isKindOfClass:[UILabel class]])
        {
          UILabel *tempLabel = [[UILabel alloc] init];
          tempLabel = [[provisioningSRPageScroller subviews] objectAtIndex:j];
          NSLog(@"tempLabel: %@", tempLabel);
          
          labelFrame = tempLabel.frame;
          if ([tempLabel.text isEqual:@"From Time: "]
              || [tempLabel.text isEqual:@"To Time: "])
          {
            labelFrame.origin.x = 166;
          }
          else
          {
            labelFrame.origin.x = 16;
          }
          labelFrame.origin.x = 16;
          labelFrame.origin.y = (schedulesLabelFrame.origin.y + (30 * y));
          tempLabel.frame = labelFrame;
        }
        else if([[[provisioningSRPageScroller subviews] objectAtIndex:j] isKindOfClass:[UITextField class]])
        {
          UITextField *tempField = [[UITextField alloc] init];
          tempField = [[provisioningSRPageScroller subviews] objectAtIndex:j];
          NSLog(@"tempField: %@", tempField);
          
          fieldFrame = tempField.frame;
          if((tempField.tag == 3) || (tempField.tag == 5)) //Tags for 'From Time' and 'To Time' fields
          {
            fieldFrame.origin.x = 166;
            
          }
          else
          {
            fieldFrame.origin.x = 16;
          }
          
          fieldFrame.origin.x = 16;
          fieldFrame.origin.y = (schedulesLabelFrame.origin.y + (30 * y));
          tempField.frame = fieldFrame;
        }
        
        /*
         else if ([[[provisioningSRPageScroller subviews] objectAtIndex:j] isKindOfClass:[UIView class]])
         {
         UIView *tempView = [[UIView alloc] init]; //for the separator
         tempView = [[provisioningSRPageScroller subviews] objectAtIndex:j];
         NSLog(@"tempView/separator: %@", tempView);
         
         viewFrame = tempView.frame;
         viewFrame.origin.x = 0;
         viewFrame.origin.y = (schedulesLabelFrame.origin.y + (30 * y));
         tempView.frame = viewFrame;
         }
         */
        y++;
      }
    }
  }
  /*
   //Remove the fields and labels after the 'Schedules' label
   for (int i = 0; i < [proposalSRPageScroller.subviews count]; i++)
   {
   if([[[proposalSRPageScroller subviews] objectAtIndex:i] isEqual:schedulesLabel])
   {
   for(int j = i++; j < [proposalSRPageScroller.subviews count]; j++)
   {
   [[[proposalSRPageScroller subviews] objectAtIndex:j] removeFromSuperview];
   }
   }
   }
  // */
  /*
   //Then redraw the fields
   //!!! TODO - Retrieve values for Schedules
   NSMutableArray *retrievedSchedulesArray = [[NSMutableArray alloc] init];
   retrievedSchedulesArray = [serviceRequestInfo valueForKey:@"schedules"];
   
   for(int i = 0; i < retrievedSchedulesArray.count; i++)
   {
   NSMutableDictionary *retrievedSchedulesDictionary = [[NSMutableDictionary alloc] init];
   [retrievedSchedulesDictionary setObject:[retrievedSchedulesArray objectAtIndex:i] forKey:@"schedules"];
   NSLog(@"retrievedSchedulesDictionary: %@", retrievedSchedulesDictionary);
   
   //Status
   NSMutableString *scheduleStatus = [[NSMutableString alloc] init];
   scheduleStatus = [[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"status"] valueForKey:@"name"];
   
   //Author
   NSMutableString *scheduleAuthor = [NSMutableString stringWithFormat:@"%@ %@ %@ %@"
   , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"firstName"]
   , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"middleName"]
   , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"lastName"]
   , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"suffix"]];
   
   //First display
   CGRect startingCoordinates;
   startingCoordinates.origin.x = 16;
   if(i == 0)
   {
   startingCoordinates.origin.y = (schedulesLabel.frame.origin.y + 30);
   }
   else
   {
   startingCoordinates.origin.y = (separatorFrame.origin.y);
   }
   
   //Display retrieved values
   [self displayScheduleEntries:scheduleStatus
   :scheduleAuthor
   :[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"periods"]
   :startingCoordinates];
   }
  //*/
  
  /*
   //Move the fields and labels after the 'Schedules' label
   for (int i = 0; i < [proposalSRPageScroller.subviews count]; i++)
   {
   if([[[proposalSRPageScroller subviews] objectAtIndex:i] isEqual:schedulesLabel])
   {
   for(int j = i++; j < [proposalSRPageScroller.subviews count]; j++)
   {
   int y = 1; //Multiplier to move the y coordinates
   if([[[proposalSRPageScroller subviews] objectAtIndex:j] isKindOfClass:[UILabel class]])
   {
   CGRect frame;
   UILabel *tempLabel = [[UILabel alloc] init];
   tempLabel = [[proposalSRPageScroller subviews] objectAtIndex:j];
   frame = tempLabel.frame;
   frame.origin.y = (schedulesLabelFrame.origin.y + (30 * y));
   tempLabel.frame = frame;
   [[[proposalSRPageScroller subviews] objectAtIndex:j] removeFromSuperview];
   [proposalSRPageScroller addSubview:tempLabel];
   }
   else if([[[proposalSRPageScroller subviews] objectAtIndex:j] isKindOfClass:[UITextField class]])
   {
   CGRect frame;
   UITextField *tempField = [[UITextField alloc] init];
   tempField = [[proposalSRPageScroller subviews] objectAtIndex:j];
   frame = tempField.frame;
   frame.origin.y = (schedulesLabelFrame.origin.y + (30 * y));
   tempField.frame = frame;
   [[[proposalSRPageScroller subviews] objectAtIndex:j] removeFromSuperview];
   [proposalSRPageScroller addSubview:tempField];
   }
   else if ([[[proposalSRPageScroller subviews] objectAtIndex:j] isKindOfClass:[UIView class]])
   {
   UIView *tempView = [[UIView alloc] init];
   tempView = [[proposalSRPageScroller subviews] objectAtIndex:j];
   separatorFrame = tempView.frame;
   separatorFrame.origin.y = (schedulesLabelFrame.origin.y + (30 * y));
   tempView.frame = separatorFrame;
   [[[proposalSRPageScroller subviews] objectAtIndex:j] removeFromSuperview];
   [proposalSRPageScroller addSubview:tempView];
   }
   y++;
   }
   }
   }
   //*/
  
  /*
  //Add Schedules Button
  addScheduleButtonFrame = addSchedulesButton.frame;
  addScheduleButtonFrame.origin.y = (separatorFrame.origin.y + 45);
  addSchedulesButton.frame = addScheduleButtonFrame;
  //*/
   
  /*
   //Clear / redraw the fields and labels after the 'Schedules' label
   for (int i = 0; i < [proposalSRPageScroller.subviews count]; i++)
   {
   if([[[proposalSRPageScroller subviews] objectAtIndex:i] isEqual:schedulesLabel])
   {
   for(int j = i++ ; j < [proposalSRPageScroller.subviews count]; j++)
   {
   [[[proposalSRPageScroller subviews] objectAtIndex:j] removeFromSuperview];
   }
   }
   }
  // */
  
  /*
   //Move the fields and labels after the 'Schedules' label
   for (int i = 0; i < [proposalSRPageScroller.subviews count]; i++)
   {
   if([[[proposalSRPageScroller subviews] objectAtIndex:i] isEqual:schedulesLabel])
   {
   for(int j = 0; j < [proposalSRPageScroller.subviews count]; j++)
   {
   int y = 1; //Multiplier to move the y coordinates
   if([[[proposalSRPageScroller subviews] objectAtIndex:j] isKindOfClass:[UILabel class]])
   {
   CGRect frame;
   UILabel *tempLabel = [[UILabel alloc] init];
   tempLabel = [[proposalSRPageScroller subviews] objectAtIndex:j];
   frame = tempLabel.frame;
   frame.origin.y = (schedulesLabelFrame.origin.y + (30 * y));
   tempLabel.frame = frame;
   }
   else if([[[proposalSRPageScroller subviews] objectAtIndex:j] isKindOfClass:[UITextField class]])
   {
   CGRect frame;
   UITextField *tempField = [[UITextField alloc] init];
   tempField = [[proposalSRPageScroller subviews] objectAtIndex:j];
   frame = tempField.frame;
   frame.origin.y = (schedulesLabelFrame.origin.y + (30 * y));
   tempField.frame = frame;
   }
   else if ([[[proposalSRPageScroller subviews] objectAtIndex:j] isKindOfClass:[UIView class]])
   {
   UIView *tempView = [[UIView alloc] init];
   tempView = [[proposalSRPageScroller subviews] objectAtIndex:j];
   separatorFrame = tempView.frame;
   separatorFrame.origin.y = (schedulesLabelFrame.origin.y + (30 * y));
   tempView.frame = separatorFrame;
   }
   y++;
   }
   }
   }
   //*/
  /*
   //Add Schedules Button
   addScheduleButtonFrame = addSchedulesButton.frame;
   addScheduleButtonFrame.origin.y = (separatorFrame.origin.y + 45);
   addSchedulesButton.frame = addScheduleButtonFrame;
   //*/
  
  //Adjust scroller height
  [self setScrollerSize];
}


#pragma mark - Display multiple 'Schedule' entries based on response JSON one at a time
-(void) displayScheduleEntries :(NSString *) scheduleStatus
                               :(NSString *) scheduleAuthor
                               :(NSMutableArray *) schedulePeriodArray
                               :(CGRect) startingCoordinates
{
  NSLog(@"Display schedule entries from response JSON");
  
  //Initialization and definition of dynamic fields for 'Schedule' entries display
  //Initialize labels
  UILabel *statusLabel   = [[UILabel alloc] init];
  UILabel *authorLabel   = [[UILabel alloc] init];
  UILabel *fromDateLabel = [[UILabel alloc] init];
  UILabel *fromTimeLabel = [[UILabel alloc] init];
  UILabel *toDateLabel   = [[UILabel alloc] init];
  UILabel *toTimeLabel   = [[UILabel alloc] init];
  
  //Initialize fields
  UITextField *statusField   = [[UITextField alloc] init];
  UITextField *authorField   = [[UITextField alloc] init];
  UITextField *fromDateField = [[UITextField alloc] init];
  UITextField *fromTimeField = [[UITextField alloc] init];
  UITextField *toDateField   = [[UITextField alloc] init];
  UITextField *toTimeField   = [[UITextField alloc] init];
  
  //Initalize separator
  UIView *separator = [[UIView alloc] init];
  
  //Set label texts
  statusLabel.text   = @"Status: ";
  authorLabel.text   = @"Author: ";
  fromDateLabel.text = @"From Date: ";
  fromTimeLabel.text = @"From Time: ";
  toDateLabel.text   = @"To Date: ";
  toTimeLabel.text   = @"To Time: ";
  
  //Set label style
  statusLabel.font   = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  authorLabel.font   = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  fromDateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  fromTimeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  toDateLabel.font   = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  toTimeLabel.font   = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  
  //Set field style
  statusField.borderStyle   = UITextBorderStyleRoundedRect;
  authorField.borderStyle   = UITextBorderStyleRoundedRect;
  fromDateField.borderStyle = UITextBorderStyleRoundedRect;
  fromTimeField.borderStyle = UITextBorderStyleRoundedRect;
  toDateField.borderStyle   = UITextBorderStyleRoundedRect;
  toTimeField.borderStyle   = UITextBorderStyleRoundedRect;
  
  //Set fields to not editable / enabled - for viewing / displaying only
  statusField.enabled   = NO;
  authorField.enabled   = NO;
  fromDateField.enabled = NO;
  fromTimeField.enabled = NO;
  toDateField.enabled   = NO;
  toTimeField.enabled   = NO;
  
  //Put tags to identify fields
  statusField.tag   = 0;
  authorField.tag   = 1;
  fromDateField.tag = 2;
  fromTimeField.tag = 3;
  toDateField.tag   = 4;
  toTimeField.tag   = 5;
  
  //Set label size dimensions
  CGRect labelSize;
  labelSize.size.width  = 116;
  labelSize.size.height = 21;
  
  CGRect statusLabelSize = statusLabel.frame;
  statusLabelSize        = labelSize;
  statusLabel.frame      = statusLabelSize;
  
  CGRect authorLabelSize = authorLabel.frame;
  authorLabelSize        = labelSize;
  authorLabel.frame      = authorLabelSize;
  
  CGRect fromDateLabelSize = fromDateLabel.frame;
  fromDateLabelSize        = labelSize;
  fromDateLabel.frame      = fromDateLabelSize;
  
  CGRect fromTimeLabelSize = fromTimeLabel.frame;
  fromTimeLabelSize        = labelSize;
  fromTimeLabel.frame      = fromTimeLabelSize;
  
  CGRect toDateLabelSize = toDateLabel.frame;
  toDateLabelSize        = labelSize;
  toDateLabel.frame      = toDateLabelSize;
  
  CGRect toTimeLabelSize = toTimeLabel.frame;
  toTimeLabelSize        = labelSize;
  toTimeLabel.frame      = toTimeLabelSize;
  
  //Set field size dimensions
  CGRect fieldSize;
  fieldSize.size.width  = 141;
  fieldSize.size.height = 30;
  
  CGRect statusFieldSize      = statusField.frame;
  statusFieldSize.size.width  = 287;
  statusFieldSize.size.height = 30;
  statusField.frame           = statusFieldSize;
  
  CGRect authorFieldSize      = authorField.frame;
  authorFieldSize.size.width  = 287;
  authorFieldSize.size.height = 30;
  authorField.frame           = authorFieldSize;
  
  CGRect fromDateFieldSize = fromDateField.frame;
  fromDateFieldSize        = fieldSize;
  fromDateField.frame      = fromDateFieldSize;
  
  CGRect fromTimeFieldSize = fromTimeField.frame;
  fromTimeFieldSize        = fieldSize;
  fromTimeField.frame      = fromTimeFieldSize;
  
  CGRect toDateFieldSize = toDateField.frame;
  toDateFieldSize        = fieldSize;
  toDateField.frame      = toDateFieldSize;
  
  CGRect toTimeFieldSize = toTimeField.frame;
  toTimeFieldSize        = fieldSize;
  toTimeField.frame      = toTimeFieldSize;
  
  //Set frame locations and contents - Status label and field
  statusLabelFrame          = statusLabel.frame;
  statusLabelFrame.origin.x = 16;
  statusLabelFrame.origin.y = (startingCoordinates.origin.y + 10);
  statusLabel.frame         = statusLabelFrame;
  
  statusFieldFrame          = statusField.frame;
  statusFieldFrame.origin.x = 16;
  statusFieldFrame.origin.y = (statusLabelFrame.origin.y + 30);
  statusField.frame         = statusFieldFrame;
  statusField.text          = scheduleStatus;
  
  //Set frame locations and contents - Author label and field
  authorLabelFrame          = authorLabel.frame;
  authorLabelFrame.origin.x = 16;
  authorLabelFrame.origin.y = (statusField.frame.origin.y + 40);
  authorLabel.frame         = authorLabelFrame;
  
  authorFieldFrame          = authorField.frame;
  authorFieldFrame.origin.x = 16;
  authorFieldFrame.origin.y = (authorLabel.frame.origin.y + 30);
  authorField.frame         = authorFieldFrame;
  authorField.text          = scheduleAuthor;
  
  //Add views in scroller
  [provisioningSRPageScroller addSubview:statusLabel];
  [provisioningSRPageScroller addSubview:statusField];
  
  [provisioningSRPageScroller addSubview:authorLabel];
  [provisioningSRPageScroller addSubview:authorField];
  
  //Displaying one or many schedule period entries depending on response parameter
  for (int i = 0; i < schedulePeriodArray.count; i++)
  {
    //Set frame locations - From Date label and field
    fromDateLabelFrame          = fromDateLabel.frame;
    fromDateLabelFrame.origin.x = 16;
    fromDateLabelFrame.origin.y = (authorField.frame.origin.y + 40);
    fromDateLabel.frame         = fromDateLabelFrame;
    
    fromDateFieldFrame          = fromDateField.frame;
    fromDateFieldFrame.origin.x = 16;
    fromDateFieldFrame.origin.y = (fromDateLabelFrame.origin.y + 30);
    fromDateField.frame         = fromDateFieldFrame;
    fromDateField.text          = [[schedulePeriodArray objectAtIndex:i] valueForKey:@"fromDate"];
    
    fromTimeLabelFrame          = fromTimeLabel.frame;
    fromTimeLabelFrame.origin.x = (fromDateLabel.frame.origin.x + 150);
    fromTimeLabelFrame.origin.y = (authorField.frame.origin.y + 40);
    fromTimeLabel.frame         = fromTimeLabelFrame;
    
    fromTimeFieldFrame          = fromTimeField.frame;
    fromTimeFieldFrame.origin.x = (fromDateFieldFrame.origin.x + 150);
    fromTimeFieldFrame.origin.y = (fromTimeLabel.frame.origin.y + 30);
    fromTimeField.frame         = fromTimeFieldFrame;
    fromTimeField.text          = [[schedulePeriodArray objectAtIndex:i] valueForKey:@"fromTime"];
    
    //Set frame locations - To Date label and field
    toDateLabelFrame          = toDateLabel.frame;
    toDateLabelFrame.origin.x = 16;
    toDateLabelFrame.origin.y = (fromDateField.frame.origin.y + 40);
    toDateLabel.frame         = toDateLabelFrame;
    
    toDateFieldFrame          = toDateField.frame;
    toDateFieldFrame.origin.x = 16;
    toDateFieldFrame.origin.y = (toDateLabelFrame.origin.y + 30);
    toDateField.frame         = toDateFieldFrame;
    toDateField.text          = [[schedulePeriodArray objectAtIndex:i] valueForKey:@"toDate"];
    
    toTimeLabelFrame          = toTimeLabel.frame;
    toTimeLabelFrame.origin.x = (toDateLabel.frame.origin.x + 150);
    toTimeLabelFrame.origin.y = (fromTimeField.frame.origin.y + 40);
    toTimeLabel.frame         = toTimeLabelFrame;
    
    toTimeFieldFrame          = toTimeField.frame;
    toTimeFieldFrame.origin.x = (toDateFieldFrame.origin.x + 150);
    toTimeFieldFrame.origin.y = (toTimeLabel.frame.origin.y + 30);
    toTimeField.frame         = toTimeFieldFrame;
    toTimeField.text          = [[schedulePeriodArray objectAtIndex:i] valueForKey:@"toTime"];
    
    //Define separator line for the period entries
    separator.backgroundColor  = [UIColor colorWithWhite:0.7 alpha:1];
    separatorFrame             = separator.frame;
    separatorFrame.origin.x    = 0;
    separatorFrame.origin.y    = (toTimeField.frame.origin.y + 50);
    separatorFrame.size.height = 1;
    separatorFrame.size.width  = 320;
    separator.frame            = separatorFrame;
    
    //Add views in scroller
    [provisioningSRPageScroller addSubview:fromDateLabel];
    [provisioningSRPageScroller addSubview:fromDateField];
    
    [provisioningSRPageScroller addSubview:fromTimeLabel];
    [provisioningSRPageScroller addSubview:fromTimeField];
    
    [provisioningSRPageScroller addSubview:toDateLabel];
    [provisioningSRPageScroller addSubview:toDateField];
    
    [provisioningSRPageScroller addSubview:toTimeLabel];
    [provisioningSRPageScroller addSubview:toTimeField];
    
    [provisioningSRPageScroller addSubview:separator];

    //Adjust scroller height
    [self setScrollerSize];
  }
}


#pragma mark - Display 'Tasks' label and button - Starting point for displaying the fields and labels for 'Tasks' area
-(void) displayTasks
{
  //Initialize Task label
  tasksLabel      = [[UILabel alloc] init];
  tasksLabel.text = @"Tasks: ";
  tasksLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  
  //Set frame location and size - Tasks label
  tasksLabelFrame             = tasksLabel.frame;
  tasksLabelFrame.origin.x    = 16;
  tasksLabelFrame.origin.y    = (separatorFrame.origin.y + 10);
  tasksLabelFrame.size.width  = 320;
  tasksLabelFrame.size.height = 21;
  tasksLabel.frame            = tasksLabelFrame;
  
  [provisioningSRPageScroller addSubview:tasksLabel];
  
  //Set frame location - [Add Tasks] button
  addTasksButtonFrame          = addTasksButton.frame;
  addTasksButtonFrame.origin.x = 16;
  addTasksButtonFrame.origin.y = (tasksLabelFrame.origin.y + 40);
  addTasksButton.frame         = addTasksButtonFrame;
}


#pragma mark - [Add Tasks] button functionality
- (IBAction)addTasks:(id)sender
{
  NSLog(@"Add Tasks");
  
  //Field and label definitions for 'Tasks' area
  //Initialize label
  UILabel *taskNameLabel        = [[UILabel alloc] init];
  UILabel *taskDescriptionLabel = [[UILabel alloc] init];
  UILabel *personnelLabel       = [[UILabel alloc] init];
  UILabel *statusLabel          = [[UILabel alloc] init];
  
  //Initialize fields
  UITextField *taskNameField  = [[UITextField alloc] init];
  personnelField              = [[UITextField alloc] init];
  
  //Set delegate for Personnel field - for the Personel Picker implementation
  personnelField.delegate = self;
  
  //Initialize text view
  UITextView *taskDescriptionTextArea = [[UITextView alloc] init];
  
  //Initialize segmented control for Task Status
  NSArray *statusChoices = [NSArray arrayWithObjects:@"To Do", @"Done", nil];
  UISegmentedControl *statusSegmentedControl = [[UISegmentedControl alloc] initWithItems:statusChoices];
  
  //Set label texts
  taskNameLabel.text        = @"Task Name: ";
  taskDescriptionLabel.text = @"Task Description: ";
  personnelLabel.text       = @"Personnel: ";
  statusLabel.text          = @"Task Status: ";
  
  //Set label style
  taskNameLabel.font        = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  taskDescriptionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  personnelLabel.font       = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  statusLabel.font          = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  
  //Set field style
  taskNameField.borderStyle  = UITextBorderStyleRoundedRect;
  personnelField.borderStyle = UITextBorderStyleRoundedRect;
  
  //Set field placeholder texts
  taskNameField.placeholder  = @"Repair broken wiring";
  personnelField.placeholder = @"Steve Wozniak";
  
  //Set text view style
  taskDescriptionTextArea.backgroundColor = notesTextArea.backgroundColor;
  [taskDescriptionTextArea setFont:[UIFont systemFontOfSize:14]];
  
  //Set label size dimensions
  CGRect labelSize;
  labelSize.size.width  = 320;
  labelSize.size.height = 21;
  
  CGRect taskNameLabelSize = taskNameLabel.frame;
  taskNameLabelSize        = labelSize;
  taskNameLabel.frame      = taskNameLabelSize;
  
  CGRect taskDescriptionLabelSize = taskDescriptionLabel.frame;
  taskDescriptionLabelSize        = labelSize;
  taskDescriptionLabel.frame      = taskDescriptionLabelSize;
  
  CGRect personnelLabelSize = personnelLabel.frame;
  personnelLabelSize        = labelSize;
  personnelLabel.frame      = personnelLabelSize;
  
  CGRect taskStatusLabelSize = statusLabel.frame;
  taskStatusLabelSize        = labelSize;
  statusLabel.frame          = taskStatusLabelSize;
  
  //Set field size dimensions
  CGRect fieldSize;
  fieldSize.size.width  = 287;
  fieldSize.size.height = 30;
  
  CGRect taskNameFieldSize = taskNameField.frame;
  taskNameFieldSize        = fieldSize;
  taskNameField.frame      = taskNameFieldSize;
  
  CGRect personnelFieldSize = personnelField.frame;
  personnelFieldSize        = fieldSize;
  personnelField.frame      = personnelFieldSize;
  
  //Set text view dimensions
  CGRect taskDescriptionSize      = taskDescriptionTextArea.frame;
  taskDescriptionSize.size.height = 120;
  taskDescriptionSize.size.width  = 284;
  taskDescriptionTextArea.frame   = taskDescriptionSize;
  
  CGRect startingCoordinates;
  
  if([taskNameArray count] == 0)
  {
    startingCoordinates.origin.y = (tasksLabelFrame.origin.y);
    
    //Set frame location - Task Name label
    taskNameLabelFrame          = taskNameLabel.frame;
    taskNameLabelFrame.origin.x = 16;
    taskNameLabelFrame.origin.y = (startingCoordinates.origin.y + 40);
    taskNameLabel.frame         = taskNameLabelFrame;
  }
  else
  {
    startingCoordinates.origin.y = (taskSeparatorFrame.origin.y);
    
    //Set frame location - Task Name label
    taskNameLabelFrame          = taskNameLabel.frame;
    taskNameLabelFrame.origin.x = 16;
    taskNameLabelFrame.origin.y = (startingCoordinates.origin.y + 30);
    taskNameLabel.frame         = taskNameLabelFrame;
  }

  //Set frame location - Task name field
  taskNameFieldFrame          = taskNameField.frame;
  taskNameFieldFrame.origin.x = 16;
  taskNameFieldFrame.origin.y = (taskNameLabelFrame.origin.y + 30);
  taskNameField.frame         = taskNameFieldFrame;
  
  //Set frame location - Description label
  taskDescriptionLabelFrame          = taskDescriptionLabel.frame;
  taskDescriptionLabelFrame.origin.x = 16;
  taskDescriptionLabelFrame.origin.y = (taskNameFieldFrame.origin.y + 40);
  taskDescriptionLabel.frame         = taskDescriptionLabelFrame;
  
  //Set frame location - Description text view
  taskDescriptionAreaFrame          = taskDescriptionTextArea.frame;
  taskDescriptionAreaFrame.origin.x = 16;
  taskDescriptionAreaFrame.origin.y = (taskDescriptionLabelFrame.origin.y + 30);
  taskDescriptionTextArea.frame     = taskDescriptionAreaFrame;
  
  //Set frame location - Personnel label
  personnelLabelFrame          = personnelLabel.frame;
  personnelLabelFrame.origin.x = 16;
  personnelLabelFrame.origin.y = (taskDescriptionAreaFrame.origin.y + 130);
  personnelLabel.frame         = personnelLabelFrame;
  
  //Set frame location - Personnel field
  personnelFieldFrame          = personnelField.frame;
  personnelFieldFrame.origin.x = 16;
  personnelFieldFrame.origin.y = (personnelLabelFrame.origin.y + 30);
  personnelField.frame         = personnelFieldFrame;
  
  //Set frame location - Status label
  taskStatusLabelFrame = statusLabel.frame;
  taskStatusLabelFrame.origin.x = 16;
  taskStatusLabelFrame.origin.y = (personnelFieldFrame.origin.y + 50);
  statusLabel.frame = taskStatusLabelFrame;
  
  //Set frame location - Status segmented control
  CGRect statusSegmentedControlFrame      = statusSegmentedControl.frame;
  statusSegmentedControlFrame.size.width  = 175;
  statusSegmentedControlFrame.size.height = 40;
  statusSegmentedControlFrame.origin.x    = 130;
  statusSegmentedControlFrame.origin.y    = (personnelFieldFrame.origin.y + 50);
  statusSegmentedControl.frame            = statusSegmentedControlFrame;
  
  //Initialize functionalities for segmented control
  statusSegmentedControl.selectedSegmentIndex = 0; //default selected is 'To Do'
  [statusSegmentedControl addTarget:self
                             action:nil //@selector()
                   forControlEvents:UIControlEventValueChanged];
  
  //Add separator line at end
  //Define separator line for the Tasks entries
  UIView *taskSeparator          = [[UIView alloc] init];
  taskSeparator.backgroundColor  = [UIColor colorWithWhite:0.7 alpha:1];
  taskSeparatorFrame             = taskSeparator.frame;
  taskSeparatorFrame.origin.x    = 0;
  taskSeparatorFrame.origin.y    = (taskStatusLabelFrame.origin.y + 60);
  taskSeparatorFrame.size.height = 1;
  taskSeparatorFrame.size.width  = 320;
  taskSeparator.frame            = taskSeparatorFrame;
  
  //Set frame location - [Add Tasks] button
  addTasksButtonFrame          = addTasksButton.frame;
  addTasksButtonFrame.origin.x = 16;
  addTasksButtonFrame.origin.y = (taskSeparatorFrame.origin.y + 30);
  addTasksButton.frame         = addTasksButtonFrame;
  
  //Add views in scroller
  [provisioningSRPageScroller addSubview:taskNameLabel];
  [provisioningSRPageScroller addSubview:taskNameField];
  
  [provisioningSRPageScroller addSubview:taskDescriptionLabel];
  [provisioningSRPageScroller addSubview:taskDescriptionTextArea];
  
  [provisioningSRPageScroller addSubview:personnelLabel];
  [provisioningSRPageScroller addSubview:personnelField];
  
  [provisioningSRPageScroller addSubview:statusLabel];
  [provisioningSRPageScroller addSubview:statusSegmentedControl];
  
  [provisioningSRPageScroller addSubview:taskSeparator];
  
  //Store fields in arrays
  [taskNameArray addObject:taskNameField];
  [taskDescriptionArray addObject:taskDescriptionTextArea];
  [personnelArray addObject:personnelField];
  [taskStatusArray addObject:statusSegmentedControl];
  
  
  //Adjust scroller height
  [self setScrollerSize];
}


#pragma mark - Get Personnel endpoint connection for Personnel picker
- (void) getPersonnels
{
  //Set URL for retrieving Personnels
  URL = @"http://192.168.2.113/vertex-api/user/personnel/getPersonnels"; //107
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:URL]];
  
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [getRequest setHTTPMethod:@"GET"];
  NSLog(@"%@", getRequest);
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:getRequest
                                        delegate:self];
  [connection start];
  
  NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
  NSError *error = [[NSError alloc] init];
  
  //GET
  NSData *responseData = [NSURLConnection
                          sendSynchronousRequest:getRequest
                               returningResponse:&urlResponse
                                           error:&error];
  
  if (responseData == nil)
  {
    //Show an alert if connection is not available
    UIAlertView *connectionAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Warning"
                                              message:@"No network connection detected. Displaying data from phone cache."
                                             delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [connectionAlert show];
    
    //TODO: Connect to CoreData for local data
    //!- FOR TESTING ONLY -!
    personnelNameArray = [[NSMutableArray alloc] initWithObjects:
                                      @"Demo - Steve Wozniak"
                                    , @"Demo - Ron Wayne"
                                    , @"Demo - Daniel Kotke"
                                    , nil];
    
    personnelIdArray = [[NSMutableArray alloc] initWithObjects:
                                      @"Demo - 0001"
                                    , @"Demo - 0002"
                                    , @"Demo - 0003"
                                    , nil];
  }
  else
  {
    personnels = [NSJSONSerialization
                  JSONObjectWithData:responseData
                             options:kNilOptions
                               error:&error];
    
    NSLog(@"getPersonnels JSON Result: %@", personnels);
    
    //Get personnel ids
    personnelIdArray = [personnels valueForKey:@"id"];
    NSLog(@"personnelIdArray: %@", personnelIdArray);
    
    for(int i = 0; i < personnels.count; i++)
    {
      //Get personnel name - concatenate and format
      NSMutableString *personnelName = [NSMutableString stringWithFormat:@"%@ %@ %@ %@"
                                        , [[[personnels valueForKey:@"personnelInfo"] valueForKey:@"firstName"] objectAtIndex:i]
                                        , [[[personnels valueForKey:@"personnelInfo"] valueForKey:@"middleName"] objectAtIndex:i]
                                        , [[[personnels valueForKey:@"personnelInfo"] valueForKey:@"lastName"] objectAtIndex:i]
                                        , [[[personnels valueForKey:@"personnelInfo"] valueForKey:@"suffix"] objectAtIndex:i]];
      
      [personnelNameArray addObject:personnelName];
    }
    
    NSLog(@"personnelNameArray: %@", personnelNameArray);
  }
}


#pragma mark - Change assetTypeField to assetTypePicker when clicked
- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
  NSLog(@"textFieldDidBeginEditing - function call");
  if(personnelField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - personnelField");
    [textField resignFirstResponder];
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    personnelPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
    personnelPicker.showsSelectionIndicator = YES;
    personnelPicker.dataSource = self;
    personnelPicker.delegate   = self;
    
    [actionSheet addSubview:personnelPicker];
    
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObject:@"Done"]];
    doneButton.momentary = YES;
    doneButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blackColor];
    [doneButton addTarget:self action:@selector(getPersonnelIndex) forControlEvents:UIControlEventValueChanged];
    
    [actionSheet addSubview:doneButton];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    personnelField.inputView = actionSheet;
    
    return YES;
  }
  else
  {
    return NO;
  }
}


#pragma mark - Implementing the Picker View
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return [personnelNameArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [self.personnelNameArray objectAtIndex:row];
}


#pragma mark - Get the selected personnel Id and name in the Personnel Picker
-(void) getPersonnelIndex
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  int personnelIndex  = [personnelPicker selectedRowInComponent:0];
  selectedPersonnelId = [personnelIdArray objectAtIndex:personnelIndex]; //selectedIndex
  NSLog(@"selectedPersonnelId: %@", selectedPersonnelId);
  
  selectedPersonnelName = [personnelNameArray objectAtIndex:personnelIndex];
  personnelField.text   = selectedPersonnelName;
}


#pragma mark - [Save] button implementation
-(void) saveProvisioningSR
{
  NSLog(@"Save Service Request Provisioning");
  
  [self saveServiceRequestWithTasks];
}


#pragma mark - [Complete] button implementation
-(void) completeSR
{
  NSLog(@"Complete Service Request Provisioning");
  
  //statusId = @20130101420000005;
  //[self updateServiceRequestStatus:@"PROPOSAL"];
}


#pragma mark - [Close] button implementation
-(void) closeSR
{
  NSLog(@"Close Service Request Provisioning");
  
  //statusId = @20130101420000005;
  //[self updateServiceRequestStatus:@"PROPOSAL"];
}


#pragma mark - Save the 'Tasks' for this Service Request
-(void) saveServiceRequestWithTasks
{
  NSLog(@"saveServiceRequestWithTasks");
  
  /*
   "{
      serviceRequest:
      {
        id: long
      },
      assignedTo:
      {
        id: long
      },
      name: string,
      description: string,
      status: boolean
   }"
   */
  
  tasksJson = [[NSMutableDictionary alloc] init];
  
  //serviceRequest
  NSMutableDictionary *serviceRequestIdJson = [[NSMutableDictionary alloc] init];
  [serviceRequestIdJson setObject:[serviceRequestInfo valueForKey:@"id"] forKey:@"id"];
  [tasksJson setObject:serviceRequestIdJson forKey:@"serviceRequest"];
  
  //task array
  NSMutableArray *tasksArray = [[NSMutableArray alloc] init];
  for(int i = 0; i < [taskNameArray count]; i++)
  {
    NSMutableDictionary *tasksDictionary = [[NSMutableDictionary alloc] init];
    UITextField *tempField = [[UITextField alloc] init];
    UITextView *tempView   = [[UITextView alloc] init];
    UISegmentedControl *tempControl = [[UISegmentedControl alloc] init];
    NSNumber *status = [[NSNumber alloc] init];
    
    /*
    tempField = [personnelArray objectAtIndex:i];
    [tasksDictionary setObject:tempField.text forKey:@"ID???"]
    */
    
    //task name
    tempField = [taskNameArray objectAtIndex:i];
    [tasksDictionary setObject:tempField.text forKey:@"name"];
    
    //task description
    tempView = [taskDescriptionArray objectAtIndex:i];
    [tasksDictionary setObject:tempView.text forKey:@"description"];
    
    //task status
    tempControl = [taskStatusArray objectAtIndex:i];
    if(tempControl.selectedSegmentIndex == 0) //To Do
    {
      status = @0;
    }
    else if(tempControl.selectedSegmentIndex == 1) //Done
    {
      status = @1;
    }
    [tasksDictionary setObject:status forKey:@"status"];
    
    [tasksArray addObject:tasksDictionary];
  }
  
  [tasksJson setObject:tasksArray forKey:@"tasks"]; //!!! TODO
  
  //assignedTo
  NSMutableDictionary *assignedToJson = [[NSMutableDictionary alloc] init];
  //[assignedToJson setObject:selectedPersonnelId forKey:@"id"];
  [assignedToJson setObject:@12345 forKey:@"id"]; //!!! TEST ONLY
  [tasksJson setObject:assignedToJson forKey:@"assignedTo"];
  
  /*
  //!!! TEST ONLY
  //name
  [tasksJson setObject:@"test" forKey:@"name"];
  
  //description
  [tasksJson setObject:@"test" forKey:@"description"];
  
  //status
  [tasksJson setObject:@"test" forKey:@"description"];
   */
  
  //Construct JSON request for Add Tasks
  NSLog(@"Tasks JSON: %@", tasksJson);
  NSError *error   = [[NSError alloc] init];
  NSData *jsonData = [NSJSONSerialization
                      dataWithJSONObject:tasksJson
                                 options:NSJSONWritingPrettyPrinted
                                   error:&error];
  
  NSString *jsonString = [[NSString alloc]
                          initWithData:jsonData
                              encoding:NSUTF8StringEncoding];
  
  //NSLog(@"jsonData Request: %@", jsonData);
  //NSLog(@"jsonString Request: %@", jsonString);
  
  //Set URL for Update Service Request
  //http://192.168.2.113/vertex-api/service-request/task/addTask
  //URL = @"http://192.168.2.113/vertex-api/service-request/task/addTask";
  URL = @"http://blah"; //TEST ONLY !!!
  
  NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:URL]];
  
  //POST method - Update
  [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [postRequest setHTTPMethod:@"POST"];
  [postRequest setHTTPBody:[NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]]];
  NSLog(@"%@", postRequest);
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:postRequest
                                        delegate:self];
  
  [connection start];
  
  NSLog(@"addTask - httpResponseCode: %d", httpResponseCode);
  
  //Set alert message display depending on what operation is performed (ACCEPTED or PROPOSAL)
  //NSString *updateAlertMessage     = [[NSString alloc] init];
  //NSString *updateFailAlertMessage = [[NSString alloc] init];
  
  if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
  {
    UIAlertView *addTaskAlert = [[UIAlertView alloc]
                                      initWithTitle:@"Add Task"
                                            message:@"Task for service request added."
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
    [addTaskAlert show];
  }
  else //(httpResponseCode >= 400)
  {
    UIAlertView *addTaskFailAlert = [[UIAlertView alloc]
                                          initWithTitle:@"Add Task"
                                                message:@"Task for service request not added. Please try again later."
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    [addTaskFailAlert show];
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Update Service Request status to 'Acceptance' or 'Proposed Service'
-(void) updateServiceRequestStatus: (NSString *) operationFlag
{
  NSLog(@"updateServiceRequestStatus");
  /*
   "{
   "id" : long,
   "status" :
   {
   "id" : long
   },
   "admin" :
   {
   "id" : long
   },
   "cost" : double,
   "schedules": # schedules can be null
   [
   {
   "status":
   {
   "id": long
   },
   "author":
   {
   "id": long
   },
   "periods":
   [
   {
   "fromDate": string,
   "fromTime": string,
   "fromTimezone": string,
   "toDate": string,
   "toTime": string,
   "toTimezone": string
   }
   , ...
   ],
   "active": boolean
   }
   ],
   "notes": # notes can be null
   [
   {
   "sender":
   {
   "id": long
   },
   "message": string
   }
   , ...
   ]
   }"
   */
  
  serviceRequestJson = [[NSMutableDictionary alloc] init];
  
  //id
  [serviceRequestJson setObject:[serviceRequestInfo valueForKey:@"id"] forKey:@"id"];
  
  //status
  NSLog(@"statusId: %@", statusId);
  NSMutableDictionary *statusJson = [[NSMutableDictionary alloc] init];
  [statusJson setObject:statusId forKey:@"id"]; //For Proposal or Accepted
  [serviceRequestJson setObject:statusJson forKey:@"status"];
  
  //admin
  NSMutableDictionary *adminJson = [[NSMutableDictionary alloc] init];
  [adminJson setObject:userId forKey:@"id"];
  [serviceRequestJson setObject:adminJson forKey:@"admin"];
  NSLog(@"adminJson: %@", adminJson);
  
  //cost - updated based on user input
  [serviceRequestJson setObject:estimatedCostField.text forKey:@"cost"];
  
  //notes
  NSMutableDictionary *notesDictionary = [[NSMutableDictionary alloc] init];
  NSMutableDictionary *notesSenderJson = [[NSMutableDictionary alloc] init];
  NSMutableArray *notesArray           = [[NSMutableArray alloc] init];
  
  for(int i = 0; i < provisioningNotesArray.count; i++)
  {
    //sender
    [notesSenderJson setObject:userId forKey:@"id"];
    [notesDictionary setObject:notesSenderJson forKey:@"sender"];
    
    //message
    UITextView *tempTextView = [[UITextView alloc] init];
    tempTextView = [provisioningNotesArray objectAtIndex:i]; //Begin at second element
    [notesDictionary setObject:tempTextView.text forKey:@"message"];
    
    //save the sender-message node in an array
    [notesArray insertObject:notesDictionary atIndex:i];
  }
  [serviceRequestJson setObject:notesArray forKey:@"notes"];
  
  
  //schedules
  //TODO - schedules !!!
  NSMutableDictionary *scheduleDictionary = [[NSMutableDictionary alloc] init];
  
  //schedule - status
  NSMutableDictionary *scheduleStatusDictionary = [[NSMutableDictionary alloc] init];
  NSMutableArray *scheduleArray = [[NSMutableArray alloc] init];
  
  NSLog(@"service request schedules JSON assembly");
  [scheduleStatusDictionary setObject:statusId forKey:@"id"]; //For Proposal or Accepted
  [scheduleDictionary setObject:scheduleStatusDictionary forKey:@"status"];
  
  //schedule - author
  NSMutableDictionary *scheduleAuthor = [[NSMutableDictionary alloc] init];
  [scheduleAuthor setObject:userId forKey:@"id"];
  [scheduleDictionary setObject:scheduleAuthor forKey:@"author"];
  
  //schedule - periods
  NSMutableArray *schedulePeriodArray = [[NSMutableArray alloc] init];
  /*
  for(int i = 0; i < [fromDatesArray count]; i++)
  {
    NSMutableDictionary *schedulePeriodDictionary = [[NSMutableDictionary alloc] init];
    UITextField *tempField = [[UITextField alloc] init];
    
    tempField = [fromDatesArray objectAtIndex:i];
    [schedulePeriodDictionary setObject:tempField.text forKey:@"fromDate"];
    
    tempField = [fromTimesArray objectAtIndex:i];
    [schedulePeriodDictionary setObject:tempField.text forKey:@"fromTime"];
    
    [schedulePeriodDictionary setObject:[[NSTimeZone systemTimeZone] abbreviation] forKey:@"fromTimezone"];
    
    tempField = [toDatesArray objectAtIndex:i];
    [schedulePeriodDictionary setObject:tempField.text forKey:@"toDate"];
    
    tempField = [toTimesArray objectAtIndex:i];
    [schedulePeriodDictionary setObject:tempField.text forKey:@"toTime"];
    
    [schedulePeriodDictionary setObject:[[NSTimeZone systemTimeZone] abbreviation] forKey:@"toTimezone"];
    
    //Add the dictionary in a schedule period array
    [schedulePeriodArray addObject:schedulePeriodDictionary];
  }
  */
  
  [scheduleDictionary setObject:schedulePeriodArray forKey:@"periods"];
  [serviceRequestJson setObject:scheduleDictionary forKey:@"schedules"];
  
  NSNumber *boolActive = [[NSNumber alloc] initWithBool:YES];
  [scheduleDictionary setObject:boolActive forKey:@"active"]; //TODO: active:boolean
  
  //Store dictionary in array first before passing to serviceRequestJson
  [scheduleArray addObject:scheduleDictionary];
  [serviceRequestJson setObject:scheduleArray forKey:@"schedules"];
  
  //Construct JSON request for Proposal update
  NSLog(@"For Proposal Service Request JSON: %@", serviceRequestJson);
  NSError *error   = [[NSError alloc] init];
  NSData *jsonData = [NSJSONSerialization
                      dataWithJSONObject:serviceRequestJson
                                 options:NSJSONWritingPrettyPrinted
                                   error:&error];
  
  NSString *jsonString = [[NSString alloc]
                          initWithData:jsonData
                              encoding:NSUTF8StringEncoding];
  
  //NSLog(@"jsonData Request: %@", jsonData);
  //NSLog(@"jsonString Request: %@", jsonString);
  
  //Set URL for Update Service Request
  //URL = @"http://192.168.2.113/vertex-api/service-request/updateServiceRequest";
  URL = @"http://192.168.2.107/vertex-api/service-request/updateServiceRequest";
  
  NSMutableURLRequest *putRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:URL]];
  
  //PUT method - Update
  [putRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [putRequest setHTTPMethod:@"PUT"];
  [putRequest setHTTPBody:[NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]]];
  NSLog(@"%@", putRequest);
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:putRequest
                                        delegate:self];
  
  [connection start];
  
  NSLog(@"updateServiceRequest - httpResponseCode: %d", httpResponseCode);
  
  //Set alert message display depending on what operation is performed (ACCEPTED or PROPOSAL)
  NSString *updateAlertMessage     = [[NSString alloc] init];
  NSString *updateFailAlertMessage = [[NSString alloc] init];
  
  //!!! TODO - operationFlag
  if([operationFlag isEqual:@"ACCEPTED"])
  {
    updateAlertMessage     = @"Service Request Accepted.";
    updateFailAlertMessage = @"Service Request not accepted. Please try again later";
  }
  else if([operationFlag isEqual:@"PROPOSAL"])
  {
    updateAlertMessage     = @"Service Request Under Proposal Stage.";
    updateFailAlertMessage = @"Service Request not updated to proposal stage. Please try again later";
  }
  
  NSLog(@"operationFlag: %@", operationFlag);
  if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
  {
    UIAlertView *updateSRAlert = [[UIAlertView alloc]
                                      initWithTitle:@"Service Request"
                                            message:updateAlertMessage
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
    [updateSRAlert show];
  }
  else //(httpResponseCode >= 400)
  {
    UIAlertView *updateSRFailAlert = [[UIAlertView alloc]
                                          initWithTitle:@"Service Request Failed"
                                                message:updateFailAlertMessage
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    [updateSRFailAlert show];
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Service Request Provisioning");
}


#pragma mark - Connection didFailWithError
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  NSLog(@"connection didFailWithError: %@", [error localizedDescription]);
}


#pragma mark - Connection didReceiveResponse
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  NSHTTPURLResponse *httpResponse;
  httpResponse     = (NSHTTPURLResponse *)response;
  httpResponseCode = [httpResponse statusCode];
  NSLog(@"httpResponse status code: %d", httpResponseCode);
}


#pragma mark - Dismiss onscreen keyboard
-(void)dismissKeyboard
{
  for (int i = 0; i < [provisioningSRPageScroller.subviews count]; i++)
  {
    [[[provisioningSRPageScroller subviews] objectAtIndex:i] resignFirstResponder];
  }
}


@end
