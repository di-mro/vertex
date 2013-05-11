//
//  InspectSRPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 5/8/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "InspectSRPageViewController.h"
#import "HomePageViewController.h"

@interface InspectSRPageViewController ()

@end

@implementation InspectSRPageViewController

@synthesize inspectSRScroller;

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

@synthesize schedulesStatusArray;
@synthesize schedulesAuthorArray;

@synthesize schedulesLabel;
@synthesize statusLabel;
@synthesize statusField;

@synthesize authorLabel;
@synthesize authorField;

@synthesize userId;
@synthesize serviceRequestId;
@synthesize serviceRequestInfo;

@synthesize statusId;
@synthesize notesTextAreaArray;

@synthesize serviceRequestJson;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize addNotesButton;
@synthesize addSchedulesButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  NSLog(@"Inspect Service Request Page");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelInspectSR)];
  
  //[Inspect] navigation button
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Inspect" style:UIBarButtonItemStylePlain target:self action:@selector(inspectSR)];
  
  //Scroller size
  self.inspectSRScroller.contentSize = CGSizeMake(320.0, 3000);
  
  //Disable fields - for viewing only
  assetField.enabled         = NO;
  lifecycleField.enabled     = NO;
  serviceField.enabled       = NO;
  //estimatedCostField.enabled = NO;
  dateRequestedField.enabled = NO;
  priorityField.enabled      = NO;
  requestorField.enabled     = NO;
  adminField.enabled         = NO;
  statusField.enabled        = NO;
  authorField.enabled        = NO;
  
  //Populate fields based on previously selected Service Request for Inspection
  [self getServiceRequest];
  
  //Add Notes utilities - Store the first note and its coordinates so that when we add notes, it will align properly
  //notesTextAreaArray = [[NSMutableArray alloc] init];
  //[notesTextAreaArray addObject:notesTextArea];
  
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Set Asset ID to the selected assetID from previous page
- (void) setServiceRequestId:(NSNumber *) srIdFromPrev
{
  serviceRequestId = srIdFromPrev;
  NSLog(@"InspectSrPage - serviceRequestId: %@", serviceRequestId);
}


#pragma mark - [Cancel] button implementation
-(void) cancelInspectSR
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Inspect Service Request");
  
  //Go back to Home Page
  HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Get Service Request by serviceRequestId
-(void) getServiceRequest
{
  //endpoint for getServiceRequest/{serviceRequestId}
  NSMutableString *urlParams = [NSMutableString stringWithFormat:@"http://192.168.2.107/vertex-api/service-request/getServiceRequest/%@", serviceRequestId]; //107
  
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
    statusField.text        = @"Acknowledged";
    authorField.text        = @"Admin - Tim Cook";
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
    NSLog(@"retrievedNotesArray: %@", retrievedNotesArray);
    NSMutableString *notesDisplay = [[NSMutableString alloc] init];
    
    for (int i = 0; i < retrievedNotesArray.count; i++)
    {
      NSMutableDictionary *retrievedNotesDictionary = [[NSMutableDictionary alloc] init];
      [retrievedNotesDictionary setObject:[retrievedNotesArray objectAtIndex:i] forKey:@"notes"];
      NSLog(@"retrievedNotesDictionary: %@", retrievedNotesDictionary);
      
      NSMutableString *notesAuthor = [NSMutableString stringWithFormat:@"%@ %@ %@ %@"
                                      , [[[[retrievedNotesDictionary valueForKey:@"notes"] valueForKey:@"sender"] valueForKey:@"info"] valueForKey:@"firstName"]
                                      , [[[[retrievedNotesDictionary valueForKey:@"notes"] valueForKey:@"sender"] valueForKey:@"info"] valueForKey:@"middleName"]
                                      , [[[[retrievedNotesDictionary valueForKey:@"notes"] valueForKey:@"sender"] valueForKey:@"info"] valueForKey:@"lastName"]
                                      , [[[[retrievedNotesDictionary valueForKey:@"notes"] valueForKey:@"sender"] valueForKey:@"info"] valueForKey:@"suffix"]];
      
      NSMutableString *noteMessage = [[retrievedNotesDictionary valueForKey:@"notes"] valueForKey:@"message"];
      NSMutableString *noteDate = [[retrievedNotesDictionary valueForKey:@"notes"] valueForKey:@"creationDate"];
      
      //Combined information for display in the Notes area
      notesDisplay = [NSMutableString stringWithFormat:@"Sender: %@\nDate: %@\n\n%@", notesAuthor, noteDate, noteMessage];
      NSLog(@"notesDisplay: %@", notesDisplay);
      
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
    
    //For Inspection Schedules
    //!!! TODO - Remove hardcoded data
    statusField.text = @"For Inspection"; //For Inspection statusId = 20130101420000004
    authorField.text = @"Tim Cook"; //logged userId
  }
}


#pragma mark - Display multiple 'Notes' entries
- (void) displayNotesEntries: (NSString *) noteText
{
  NSLog(@"Display multiple note entries");
  NSLog(@"notesTextAreaArray: %@", notesTextAreaArray);
  
  //Initialize Notes text area frame size
  int height = 120;
  int width = 284;
  
  UITextView *newNoteTextArea = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
  newNoteTextArea.backgroundColor = notesTextArea.backgroundColor;
  [newNoteTextArea setFont:[UIFont systemFontOfSize:14]];
  
  //Set the text of Notes area
  newNoteTextArea.text = noteText;
  
  //Get the location of prev Notes text area and adjust new Notes area location based on that
  UITextView *prevNoteTextView = [[UITextView alloc] init];
  prevNoteTextView = [notesTextAreaArray lastObject];
  CGRect noteFrame = newNoteTextArea.frame;
  noteFrame.origin.x = 17;
  noteFrame.origin.y = (prevNoteTextView.frame.origin.y + 130);
  newNoteTextArea.frame = noteFrame;
  
  //Add Notes text area in view
  [inspectSRScroller addSubview:newNoteTextArea];
  
  //Store added Notes text area in array
  [notesTextAreaArray addObject:newNoteTextArea];
  NSLog(@"notesTextAreaArray: %@", notesTextAreaArray);
  
  //Adjust position of [Add Notes] button when new text area is added
  CGRect addNotesButtonFrame = addNotesButton.frame;
  addNotesButtonFrame.origin.x = 20;
  addNotesButtonFrame.origin.y = (newNoteTextArea.frame.origin.y + 130);
  addNotesButton.frame = addNotesButtonFrame;
  
  //Move all element below the added notesTextArea
  [self adjustFieldAfterNotes];
}


#pragma mark - [Add Notes] functionality
- (IBAction)addNotes:(id)sender
{
  NSLog(@"addNotes");
  
  //Initialize Notes text area frame size
  int height = 120;
  int width = 284;
  
  UITextView *newNoteTextArea = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
  newNoteTextArea.backgroundColor = notesTextArea.backgroundColor;
  [newNoteTextArea setFont:[UIFont systemFontOfSize:14]];
  
  //Get the location of prev Notes text area and adjust new Notes area location based on that
  UITextView *prevNoteTextView = [[UITextView alloc] init];
  prevNoteTextView = [notesTextAreaArray lastObject];
  CGRect noteFrame = newNoteTextArea.frame;
  noteFrame.origin.x = 17;
  noteFrame.origin.y = (prevNoteTextView.frame.origin.y + 130);
  newNoteTextArea.frame = noteFrame;
  
  //Add Notes text area in view
  [inspectSRScroller addSubview:newNoteTextArea];
  
  //Store added Notes text area in array
  [notesTextAreaArray addObject:newNoteTextArea];
  NSLog(@"notesTextAreaArray: %@", notesTextAreaArray);
  
  //Adjust position of [Add Notes] button when new text area is added
  CGRect addNotesButtonFrame = addNotesButton.frame;
  addNotesButtonFrame.origin.x = 20;
  addNotesButtonFrame.origin.y = (newNoteTextArea.frame.origin.y + 130);
  addNotesButton.frame = addNotesButtonFrame;
  
  //Move all element below the added notesTextArea
  [self adjustFieldAfterNotes];
}


#pragma mark - Adjust aligment and placement of elements after the added Note / multiple Note entries
- (void) adjustFieldAfterNotes
{
  NSLog(@"adjustFieldAfterNotes");
  
  //Move the Y coordinate of the elements, X remains constant
  //Get [Add Notes] button location
  CGRect addNotesButtonFrame = addNotesButton.frame;
  float addNotesButtonY = addNotesButtonFrame.origin.y;
  
  //Schedules Label
  CGRect schedulesLabelFrame = schedulesLabel.frame;
  schedulesLabelFrame.origin.y = (addNotesButtonY + 70);
  schedulesLabel.frame = schedulesLabelFrame;
  
  //Status Label
  CGRect scheduleStatusLabelFrame = statusLabel.frame;
  scheduleStatusLabelFrame.origin.y = (schedulesLabelFrame.origin.y + 30);
  statusLabel.frame = scheduleStatusLabelFrame;
  
  //Status Field
  CGRect scheduleStatusFieldFrame = statusField.frame;
  scheduleStatusFieldFrame.origin.y = (scheduleStatusLabelFrame.origin.y + 30);
  statusField.frame = scheduleStatusFieldFrame;
  
  //Author Label
  CGRect scheduleAuthorLabelFrame = authorLabel.frame;
  scheduleAuthorLabelFrame.origin.y = (scheduleStatusFieldFrame.origin.y + 35);
  authorLabel.frame = scheduleAuthorLabelFrame;
  
  //Author Field
  CGRect scheduleAuthorFieldFrame = authorField.frame;
  scheduleAuthorFieldFrame.origin.y = (scheduleAuthorLabelFrame.origin.y + 30);
  authorField.frame = scheduleAuthorFieldFrame;
  
  //Add Schedules Button
  CGRect addScheduleButtonFrame = addSchedulesButton.frame;
  addScheduleButtonFrame.origin.y = (scheduleAuthorFieldFrame.origin.y + 45);
  addSchedulesButton.frame = addScheduleButtonFrame;
}


#pragma mark - [Add Schedules] button implementation
- (IBAction)addInspectionSchedules:(id)sender
{
  NSLog(@"Add Inspection Schedules");
  
  //Add at least one schedule for inspection
  //Initialize fields and labels
  UILabel *fromDateLabel = [[UILabel alloc] init];
  UILabel *fromTimeLabel = [[UILabel alloc] init];
  UILabel *toDateLabel = [[UILabel alloc] init];
  UILabel *toTimeLabel = [[UILabel alloc] init];
  
  UITextField *fromDateField = [[UITextField alloc] init];
  UITextField *fromTimeField = [[UITextField alloc] init];
  UITextField *toDateField = [[UITextField alloc] init];
  UITextField *toTimeField = [[UITextField alloc] init];
  
  //Set label style
  fromDateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  fromTimeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  toDateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  toTimeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  
  //Set field style
  fromDateField.borderStyle = UITextBorderStyleRoundedRect;
  fromTimeField.borderStyle = UITextBorderStyleRoundedRect;
  toDateField.borderStyle = UITextBorderStyleRoundedRect;
  toTimeField.borderStyle = UITextBorderStyleRoundedRect;
  
  //Set label size dimensions
  CGRect labelSize;
  labelSize.size.width = 116;
  labelSize.size.height = 21;
  
  CGRect fromDateLabelSize = fromDateLabel.frame;
  fromDateLabelSize = labelSize;
  fromDateLabel.frame = fromDateLabelSize;
  
  CGRect fromTimeLabelSize = fromTimeLabel.frame;
  fromTimeLabelSize = labelSize;
  fromTimeLabel.frame = fromTimeLabelSize;
  
  CGRect toDateLabelSize = toDateLabel.frame;
  toDateLabelSize = labelSize;
  toDateLabel.frame = toDateLabelSize;
  
  CGRect toTimeLabelSize = toTimeLabel.frame;
  toTimeLabelSize = labelSize;
  toTimeLabel.frame = toTimeLabelSize;
  
  //Set field size dimensions
  CGRect fieldSize;
  fieldSize.size.width = 141;
  fieldSize.size.height = 30;
  
  CGRect fromDateFieldSize = fromDateField.frame;
  fromDateFieldSize = fieldSize;
  fromDateField.frame = fromDateFieldSize;
  
  CGRect fromTimeFieldSize = fromTimeField.frame;
  fromTimeFieldSize = fieldSize;
  fromTimeField.frame = fromTimeFieldSize;
  
  CGRect toDateFieldSize = toDateField.frame;
  toDateFieldSize = fieldSize;
  toDateField.frame = toDateFieldSize;
  
  CGRect toTimeFieldSize = toTimeField.frame;
  toTimeFieldSize = fieldSize;
  toTimeField.frame = toTimeFieldSize;
  
  //Set frame location
  CGRect frame;
  
  frame = fromDateLabel.frame;
  frame.origin.x = 16;
  frame.origin.y = 915;
  fromDateLabel.frame = frame;
  
  frame = fromDateField.frame;
  frame.origin.x = 16;
  frame.origin.y = 945;
  fromDateField.frame = frame;
  
  /*
  [inspectSRScroller addSubview:fromDateLabel];
  [inspectSRScroller addSubview:fromDateField];
  
  //move add schedules button
  //Add Schedules Button
  CGRect addScheduleButtonFrame = addSchedulesButton.frame;
  addScheduleButtonFrame.origin.y = (frame.origin.y + 45);
  addSchedulesButton.frame = addScheduleButtonFrame;
   */
}



#pragma mark - [Inspect] button implementation
- (void) inspectSR
{
  NSLog(@"Inspect Service Request");
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
  httpResponse = (NSHTTPURLResponse *)response;
  httpResponseCode = [httpResponse statusCode];
  NSLog(@"httpResponse status code: %d", httpResponseCode);
}


#pragma mark - Transition to Assets Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0) //OK
  {
    //Go back to Home
    HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
    
    [self.navigationController pushViewController:controller animated:YES];
  }
}


#pragma mark - Dismiss onscreen keyboard
-(void)dismissKeyboard
{
  [assetField resignFirstResponder];
  [lifecycleField resignFirstResponder];
  [serviceField resignFirstResponder];
  [estimatedCostField resignFirstResponder];
  [dateRequestedField resignFirstResponder];
  [priorityField resignFirstResponder];
  [requestorField resignFirstResponder];
  [adminField resignFirstResponder];
  [statusField resignFirstResponder];
  [authorField resignFirstResponder];
  [notesTextArea resignFirstResponder];
  
  for(int i = 0; i < notesTextAreaArray.count; i++)
  {
    [[notesTextAreaArray objectAtIndex:i] resignFirstResponder];
  }
}



@end
