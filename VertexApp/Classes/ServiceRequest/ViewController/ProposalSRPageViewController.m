//
//  ProposalSRPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 5/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ProposalSRPageViewController.h"
#import "HomePageViewController.h"

@interface ProposalSRPageViewController ()

@end

@implementation ProposalSRPageViewController

@synthesize proposalSRPageScroller;

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

@synthesize addNotesButton;

@synthesize schedulesLabel;
/*
@synthesize statusLabel;
@synthesize statusField;

@synthesize authorLabel;
@synthesize authorField;
*/

@synthesize addSchedulesButton;

@synthesize addNotesButtonFrame;
@synthesize schedulesLabelFrame;
@synthesize scheduleStatusLabelFrame;
@synthesize scheduleStatusFieldFrame;
@synthesize scheduleAuthorLabelFrame;
@synthesize scheduleAuthorFieldFrame;
@synthesize addScheduleButtonFrame;

@synthesize fromDateLabelFrame;
@synthesize fromDateFieldFrame;
@synthesize fromTimeLabelFrame;
@synthesize fromTimeFieldFrame;
@synthesize toDateLabelFrame;
@synthesize toDateFieldFrame;
@synthesize toTimeLabelFrame;
@synthesize toTimeFieldFrame;

@synthesize separatorFrame;

@synthesize fromDatesArray;
@synthesize fromTimesArray;
@synthesize toDatesArray;
@synthesize toTimesArray;

@synthesize scheduleFromDateDictionary;
@synthesize scheduleToDateDictionary;

@synthesize userId;
@synthesize serviceRequestId;
@synthesize serviceRequestInfo;

@synthesize statusId;
@synthesize notesTextAreaArray;
@synthesize proposalNotesArray;
@synthesize schedulesStatusArray;
@synthesize schedulesAuthorArray;

@synthesize serviceRequestJson;

@synthesize URL;
@synthesize httpResponseCode;


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
  NSLog(@"Proposal Service Request Page");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Back] (Cancel) navigation button
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Back"
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(cancelProposalSR)];
  
  self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backButton, nil];
  
  //[Propose] navigation button
  UIBarButtonItem *proposeButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Propose"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(proposeSR)];

  //[Accept] navigation button
  UIBarButtonItem *acceptButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Accept"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(acceptSR)];
  
  //Initialize bar button items
  self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: proposeButton, acceptButton, nil];
  
  //Scroller size
  self.proposalSRPageScroller.contentSize = CGSizeMake(320.0, 3000);
  
  //Disable fields - for viewing only
  assetField.enabled         = NO;
  lifecycleField.enabled     = NO;
  serviceField.enabled       = NO;
  dateRequestedField.enabled = NO;
  priorityField.enabled      = NO;
  requestorField.enabled     = NO;
  adminField.enabled         = NO;
  //statusField.enabled        = NO;
  //authorField.enabled        = NO;
  
  //EstimatedCostField delegate - for the changing of color when editing
  estimatedCostField.textColor = [UIColor blueColor];
  [estimatedCostField setDelegate:self];
  
  //Populate fields based on previously selected Service Request for Proposal Stage
  [self getServiceRequest];
  
  //Add Notes utilities - Store the first note and its coordinates so that when we add notes, it will align properly
  //notesTextAreaArray = [[NSMutableArray alloc] init];
  //[notesTextAreaArray addObject:notesTextArea];
  
  //Initialize array for proposal notes
  proposalNotesArray = [[NSMutableArray alloc] init];
  
  //Initialize arrays for proposal schedule periods
  fromDatesArray = [[NSMutableArray alloc] init];
  fromTimesArray = [[NSMutableArray alloc] init];
  toDatesArray = [[NSMutableArray alloc] init];
  toTimesArray = [[NSMutableArray alloc] init];
  
  //Initialize dictionaries for proposal schedules
  scheduleFromDateDictionary = [[NSMutableDictionary alloc] init];
  scheduleToDateDictionary = [[NSMutableDictionary alloc] init];
  
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
  NSLog(@"ProposalSRPage - serviceRequestId: %@", serviceRequestId);
}


#pragma mark - [Cancel] button implementation
-(void) cancelProposalSR
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Proposal Service Request");
  
  //Go back to Home Page
  HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
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
    //statusField.text        = @"Acknowledged";
    //authorField.text        = @"Admin - Tim Cook";
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
    
    //!!! TODO - Retrieve values for Schedules
    NSMutableArray *retrievedSchedulesArray = [[NSMutableArray alloc] init];
    retrievedSchedulesArray = [serviceRequestInfo valueForKey:@"schedules"];
    NSLog(@"retrievedSchedulesArray: %@", retrievedSchedulesArray);
    
    for(int i = 0; i < retrievedSchedulesArray.count; i++)
    {
      NSMutableDictionary *retrievedSchedulesDictionary = [[NSMutableDictionary alloc] init];
      [retrievedSchedulesDictionary setObject:[retrievedSchedulesArray objectAtIndex:i] forKey:@"schedules"];
      NSLog(@"retrievedSchedulesDictionary: %@", retrievedSchedulesDictionary);
      
      //Status
      NSMutableString *scheduleStatus = [[NSMutableString alloc] init];
      scheduleStatus = [[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"status"] valueForKey:@"name"];
      NSLog(@"scheduleStatus: %@", scheduleStatus);
      
      //Author
      NSMutableString *scheduleAuthor = [NSMutableString stringWithFormat:@"%@ %@ %@ %@"
                                      , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"firstName"]
                                      , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"middleName"]
                                      , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"lastName"]
                                      , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"suffix"]];
      NSLog(@"scheduleAuthor: %@", scheduleAuthor);
      
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
  }
}


#pragma mark - Display multiple 'Notes' entries from response JSON
- (void) displayNotesEntries: (NSString *) noteText
{
  NSLog(@"Display multiple note entries");
  
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
  [proposalSRPageScroller addSubview:newNoteTextArea];
  
  //Store added Notes text area in array
  [notesTextAreaArray addObject:newNoteTextArea];
  NSLog(@"notesTextAreaArray: %@", notesTextAreaArray);
  
  //Adjust position of [Add Notes] button when new text area is added
  addNotesButtonFrame = addNotesButton.frame;
  addNotesButtonFrame.origin.x = 20;
  addNotesButtonFrame.origin.y = (newNoteTextArea.frame.origin.y + 130);
  addNotesButton.frame = addNotesButtonFrame;
  
  //Move all element below the added notesTextArea
  [self adjustFieldAfterNotes];
}


#pragma mark - [Add Notes] button functionality
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
  [proposalSRPageScroller addSubview:newNoteTextArea];
  
  //Store added Notes text area in array for service request proposal notes
  [proposalNotesArray addObject:newNoteTextArea];
  
  //Adjust position of [Add Notes] button when new text area is added
  addNotesButtonFrame = addNotesButton.frame;
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
  addNotesButtonFrame = addNotesButton.frame;
  //float addNotesButtonY = addNotesButtonFrame.origin.y;

  //Schedules Label
  schedulesLabelFrame = schedulesLabel.frame;
  schedulesLabelFrame.origin.y = (addNotesButtonFrame.origin.y + 70);
  schedulesLabel.frame = schedulesLabelFrame;

  //displayScheduleEntries
  //!!! TODO - Retrieve values for Schedules
  //adjust fieldsss
  NSMutableArray *retrievedSchedulesArray = [[NSMutableArray alloc] init];
  retrievedSchedulesArray = [serviceRequestInfo valueForKey:@"schedules"];
  NSLog(@"retrievedSchedulesArray: %@", retrievedSchedulesArray);
  
  for(int i = 0; i < retrievedSchedulesArray.count; i++)
  {
    NSMutableDictionary *retrievedSchedulesDictionary = [[NSMutableDictionary alloc] init];
    [retrievedSchedulesDictionary setObject:[retrievedSchedulesArray objectAtIndex:i] forKey:@"schedules"];
    NSLog(@"retrievedSchedulesDictionary: %@", retrievedSchedulesDictionary);
    
    //Status
    NSMutableString *scheduleStatus = [[NSMutableString alloc] init];
    scheduleStatus = [[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"status"] valueForKey:@"name"];
    NSLog(@"scheduleStatus: %@", scheduleStatus);
    
    //Author
    NSMutableString *scheduleAuthor = [NSMutableString stringWithFormat:@"%@ %@ %@ %@"
                                       , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"firstName"]
                                       , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"middleName"]
                                       , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"lastName"]
                                       , [[[[retrievedSchedulesDictionary valueForKey:@"schedules"] valueForKey:@"author"] valueForKey:@"info"] valueForKey:@"suffix"]];
    NSLog(@"scheduleAuthor: %@", scheduleAuthor);
    
    //First display
    CGRect startingCoordinates;
    startingCoordinates.origin.x = 16;
    if(i == 0)
    {
      startingCoordinates.origin.y = (schedulesLabelFrame.origin.y + 30);
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

  //Add Schedules Button
  addScheduleButtonFrame = addSchedulesButton.frame;
  addScheduleButtonFrame.origin.y = (separatorFrame.origin.y + 45);
  addSchedulesButton.frame = addScheduleButtonFrame;
  
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
  
  
  //Set label size dimensions
  CGRect labelSize;
  labelSize.size.width  = 116;
  labelSize.size.height = 21;
  
  CGRect statusLabelSize = statusLabel.frame;
  statusLabelSize = labelSize;
  statusLabel.frame = statusLabelSize;
  
  CGRect authorLabelSize = authorLabel.frame;
  authorLabelSize = labelSize;
  authorLabel.frame = authorLabelSize;
  
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
  fieldSize.size.width  = 141;
  fieldSize.size.height = 30;
  
  CGRect statusFieldSize = statusField.frame;
  statusFieldSize.size.width = 287;
  statusFieldSize.size.height = 30;
  statusField.frame = statusFieldSize;
  
  CGRect authorFieldSize = authorField.frame;
  authorFieldSize.size.width = 287;
  authorFieldSize.size.height = 30;
  authorField.frame = authorFieldSize;
  
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

  //Set frame locations and contents - Status label and field
  scheduleStatusLabelFrame = statusLabel.frame;
  scheduleStatusLabelFrame.origin.x = 16;
  scheduleStatusLabelFrame.origin.y = (startingCoordinates.origin.y + 10);
  statusLabel.frame = scheduleStatusLabelFrame;
  [proposalSRPageScroller addSubview:statusLabel];
  
  scheduleStatusFieldFrame = statusField.frame;
  scheduleStatusFieldFrame.origin.x = 16;
  scheduleStatusFieldFrame.origin.y = (scheduleStatusLabelFrame.origin.y + 30);
  statusField.frame = scheduleStatusFieldFrame;
  statusField.text = scheduleStatus;
  [proposalSRPageScroller addSubview:statusField];
  
  //Set frame locations and contents - Author label and field
  scheduleAuthorLabelFrame = authorLabel.frame;
  scheduleAuthorLabelFrame.origin.x = 16;
  scheduleAuthorLabelFrame.origin.y = (statusField.frame.origin.y + 40);
  authorLabel.frame = scheduleAuthorLabelFrame;
  [proposalSRPageScroller addSubview:authorLabel];
  
  scheduleAuthorFieldFrame = authorField.frame;
  scheduleAuthorFieldFrame.origin.x = 16;
  scheduleAuthorFieldFrame.origin.y = (authorLabel.frame.origin.y + 30);
  authorField.frame = scheduleAuthorFieldFrame;
  authorField.text = scheduleAuthor;
  [proposalSRPageScroller addSubview:authorField];
  
  //Displaying one or many schedule period entries
  for (int i = 0; i < schedulePeriodArray.count; i++)
  {
    //Set frame locations - From Date label and field
    fromDateLabelFrame = fromDateLabel.frame;
    fromDateLabelFrame.origin.x = 16;
    fromDateLabelFrame.origin.y = (authorField.frame.origin.y + 40);
    fromDateLabel.frame = fromDateLabelFrame;
    [proposalSRPageScroller addSubview:fromDateLabel];
    
    fromDateFieldFrame = fromDateField.frame;
    fromDateFieldFrame.origin.x = 16;
    fromDateFieldFrame.origin.y = (fromDateLabelFrame.origin.y + 30);
    fromDateField.frame = fromDateFieldFrame;
    fromDateField.text = [[schedulePeriodArray objectAtIndex:i] valueForKey:@"fromDate"];
    [proposalSRPageScroller addSubview:fromDateField];
    
    fromTimeLabelFrame = fromTimeLabel.frame;
    fromTimeLabelFrame.origin.x = (fromDateLabel.frame.origin.x + 150);
    fromTimeLabelFrame.origin.y = (authorField.frame.origin.y + 40);
    fromTimeLabel.frame = fromTimeLabelFrame;
    [proposalSRPageScroller addSubview:fromTimeLabel];
    
    fromTimeFieldFrame = fromTimeField.frame;
    fromTimeFieldFrame.origin.x = (fromDateFieldFrame.origin.x + 150);
    fromTimeFieldFrame.origin.y = (fromTimeLabel.frame.origin.y + 30);
    fromTimeField.frame = fromTimeFieldFrame;
    fromTimeField.text = [[schedulePeriodArray objectAtIndex:i] valueForKey:@"fromTime"];
    [proposalSRPageScroller addSubview:fromTimeField];
    
    
    //Set frame locations - To Date label and field
    toDateLabelFrame = toDateLabel.frame;
    toDateLabelFrame.origin.x = 16;
    toDateLabelFrame.origin.y = (fromDateField.frame.origin.y + 40);
    toDateLabel.frame = toDateLabelFrame;
    [proposalSRPageScroller addSubview:toDateLabel];
    
    toDateFieldFrame = toDateField.frame;
    toDateFieldFrame.origin.x = 16;
    toDateFieldFrame.origin.y = (toDateLabelFrame.origin.y + 30);
    toDateField.frame = toDateFieldFrame;
    toDateField.text = [[schedulePeriodArray objectAtIndex:i] valueForKey:@"toDate"];
    [proposalSRPageScroller addSubview:toDateField];
    
    toTimeLabelFrame = toTimeLabel.frame;
    toTimeLabelFrame.origin.x = (toDateLabel.frame.origin.x + 150);
    toTimeLabelFrame.origin.y = (fromTimeField.frame.origin.y + 40);
    toTimeLabel.frame = toTimeLabelFrame;
    [proposalSRPageScroller addSubview:toTimeLabel];
    
    toTimeFieldFrame = toTimeField.frame;
    toTimeFieldFrame.origin.x = (toDateFieldFrame.origin.x + 150);
    toTimeFieldFrame.origin.y = (toTimeLabel.frame.origin.y + 30);
    toTimeField.frame = toTimeFieldFrame;
    toTimeField.text = [[schedulePeriodArray objectAtIndex:i] valueForKey:@"toTime"];
    [proposalSRPageScroller addSubview:toTimeField];

    //Define separator line for the period entries
    separator.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    separatorFrame = separator.frame;
    separatorFrame.origin.x = 0;
    separatorFrame.origin.y = (toTimeField.frame.origin.y + 50);
    separatorFrame.size.height = 1;
    separatorFrame.size.width = 320;
    separator.frame = separatorFrame;
    [proposalSRPageScroller addSubview:separator];

    //Move add schedules button location
    //Add Schedules Button
    addScheduleButtonFrame = addSchedulesButton.frame;
    addScheduleButtonFrame.origin.y = (separatorFrame.origin.y + 30);
    addSchedulesButton.frame = addScheduleButtonFrame;
  }
}



#pragma mark - [Add Schedules] button implementation
- (IBAction)addProposalSchedules:(id)sender
{
  NSLog(@"Add Proposal Schedules");
  
  //Display status and author fields with default value
  
  /*
  //Add at least one schedule for proposal
  //Initialize fields and labels
  UILabel *fromDateLabel = [[UILabel alloc] init];
  UILabel *fromTimeLabel = [[UILabel alloc] init];
  UILabel *toDateLabel = [[UILabel alloc] init];
  UILabel *toTimeLabel = [[UILabel alloc] init];
  
  UITextField *fromDateField = [[UITextField alloc] init];
  UITextField *fromTimeField = [[UITextField alloc] init];
  UITextField *toDateField = [[UITextField alloc] init];
  UITextField *toTimeField = [[UITextField alloc] init];
  
  //Set label texts
  fromDateLabel.text = @"From Date: ";
  fromTimeLabel.text = @"From Time: ";
  toDateLabel.text = @"To Date: ";
  toTimeLabel.text = @"To Time: ";
  
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
  
  CGRect startingCoordinates;
  //* If schedule date dictionary is empty - this is the first entry for schedules.
   //Begin after schedule author field.

  if (([scheduleFromDateDictionary count] == 0) || ([scheduleToDateDictionary count] == 0))
  {
    startingCoordinates.origin.y = (scheduleAuthorFieldFrame.origin.y + 45);
  }
  //* If schedule date dictionary is not empy - there are fields already set.
   //Begin after the last 'To Date' field.
  else
  {
    startingCoordinates.origin.y = (toDateFieldFrame.origin.y + 50);
  }
  
  UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(0, (startingCoordinates.origin.y), 320, 1)];
  separator.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
  [proposalSRPageScroller addSubview:separator];
  
  //Set frame locations - From Date Label and Field
  fromDateLabelFrame = fromDateLabel.frame;
  fromDateLabelFrame.origin.x = 16;
  fromDateLabelFrame.origin.y = (startingCoordinates.origin.y + 10);
  fromDateLabel.frame = fromDateLabelFrame;
  
  fromDateFieldFrame = fromDateField.frame;
  fromDateFieldFrame.origin.x = 16;
  fromDateFieldFrame.origin.y = (fromDateLabelFrame.origin.y + 30);
  fromDateField.frame = fromDateFieldFrame;
  
  fromTimeLabelFrame = fromTimeLabel.frame;
  fromTimeLabelFrame.origin.x = (fromDateLabel.frame.origin.x + 150);
  fromTimeLabelFrame.origin.y = (startingCoordinates.origin.y + 10);
  fromTimeLabel.frame = fromTimeLabelFrame;
  
  fromTimeFieldFrame = fromTimeField.frame;
  fromTimeFieldFrame.origin.x = (fromDateFieldFrame.origin.x + 150);
  fromTimeFieldFrame.origin.y = (fromTimeLabel.frame.origin.y + 30);
  fromTimeField.frame = fromTimeFieldFrame;
  
  
  //Set frame locations - To Date Label and Field
  toDateLabelFrame = toDateLabel.frame;
  toDateLabelFrame.origin.x = 16;
  toDateLabelFrame.origin.y = (fromDateField.frame.origin.y + 40);
  toDateLabel.frame = toDateLabelFrame;
  
  toDateFieldFrame = toDateField.frame;
  toDateFieldFrame.origin.x = 16;
  toDateFieldFrame.origin.y = (toDateLabelFrame.origin.y + 30);
  toDateField.frame = toDateFieldFrame;
  
  toTimeLabelFrame = toTimeLabel.frame;
  toTimeLabelFrame.origin.x = (toDateLabel.frame.origin.x + 150);
  toTimeLabelFrame.origin.y = (fromTimeField.frame.origin.y + 40);
  toTimeLabel.frame = toTimeLabelFrame;
  
  toTimeFieldFrame = toTimeField.frame;
  toTimeFieldFrame.origin.x = (toDateFieldFrame.origin.x + 150);
  toTimeFieldFrame.origin.y = (toTimeLabel.frame.origin.y + 30);
  toTimeField.frame = toTimeFieldFrame;
  
  //move add schedules button
  //Add Schedules Button
  addScheduleButtonFrame = addSchedulesButton.frame;
  addScheduleButtonFrame.origin.y = (toDateField.frame.origin.y + 60);
  addSchedulesButton.frame = addScheduleButtonFrame;
  
  //Add the fields in scroller
  [proposalSRPageScroller addSubview:fromDateLabel];
  [proposalSRPageScroller addSubview:fromDateField];
  
  [proposalSRPageScroller addSubview:fromTimeLabel];
  [proposalSRPageScroller addSubview:fromTimeField];
  
  [proposalSRPageScroller addSubview:toDateLabel];
  [proposalSRPageScroller addSubview:toDateField];
  
  [proposalSRPageScroller addSubview:toTimeLabel];
  [proposalSRPageScroller addSubview:toTimeField];
  
  //Store fields in arrays
  [fromDatesArray addObject:fromDateField];
  [fromTimesArray addObject:fromTimeField];
  [toDatesArray addObject:toDateField];
  [toTimesArray addObject:toTimeField];
  
  NSLog(@"fromDatesArray: %@", fromDatesArray);
  NSLog(@"fromTimesArray: %@", fromTimesArray);
  NSLog(@"toDatesArray: %@", toDatesArray);
  NSLog(@"toTimesArray: %@", toTimesArray);
  
  //Store the fields in a dictionary
  [scheduleFromDateDictionary setObject:fromDateField forKey:fromTimeField];
  [scheduleToDateDictionary setObject:toDateField forKey:toTimeField];
  
  //NSLog(@"scheduleFromDateDictionary: %@", scheduleFromDateDictionary);
  //NSLog(@"scheduleToDateDictionary: %@", scheduleToDateDictionary);
  */
}


#pragma mark - Updating the color of entry in estimatedCostField depending whether changed or same with original
- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
  NSLog(@"textFieldDidBeginEditing");
  
  if(estimatedCostField.isEditing)
  {
    NSLog(@"estimatedCost field editing");
    estimatedCostField.textColor = [UIColor redColor];
    return YES;
  }
  else
  {
    return YES;
  }
}


#pragma mark - Updating the color of entry in estimatedCostField depending whether changed or same with original
- (void)textFieldDidEndEditing:(UITextField *)textField
{
  NSString *originalEstimatedCost = [[NSString alloc] init];
  originalEstimatedCost = [serviceRequestInfo valueForKey:@"cost"];
  
  //!!! TODO - Handling decimal digits
  NSMutableString *enteredCost = [NSMutableString stringWithFormat:@"%@.0", estimatedCostField.text];
  
  if([originalEstimatedCost isEqualToString:enteredCost])
  {
    //Not changed - Blue
    estimatedCostField.textColor = [UIColor blueColor];
  }
  else
  {
    //Changed - Red
    estimatedCostField.textColor = [UIColor redColor];
  }
}


#pragma mark - [Propose] button implementation
- (void) proposeSR
{
  NSLog(@"Proposal Service Request");
  
  statusId = @20130101420000005;
  [self updateServiceRequestStatus:@"PROPOSAL"];
}


#pragma mark - [Accept] button implementation
- (void) acceptSR
{
  NSLog(@"Accept Service Request");
  
  statusId = @20130101420000006;
  [self updateServiceRequestStatus:@"ACCEPTED"];
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
  [adminJson setObject:@20130101500000001 forKey:@"id"]; //TEST ONLY !!!
  [serviceRequestJson setObject:adminJson forKey:@"admin"];
  NSLog(@"adminJson: %@", adminJson);
  
  //cost - updated based on user input
  [serviceRequestJson setObject:estimatedCostField.text forKey:@"cost"];
  
  
  //notes
  NSMutableDictionary *notesDictionary = [[NSMutableDictionary alloc] init];
  NSMutableDictionary *notesSenderJson = [[NSMutableDictionary alloc] init];
  NSMutableArray *notesArray = [[NSMutableArray alloc] init];
  
  for(int i = 0; i < proposalNotesArray.count; i++)
  {
    //sender
    [notesSenderJson setObject:@20130101500000001 forKey:@"id"]; //TEST ONLY - Remove hardcoded value
    [notesDictionary setObject:notesSenderJson forKey:@"sender"];
    
    //message
    UITextView *tempTextView = [[UITextView alloc] init];
    tempTextView = [proposalNotesArray objectAtIndex:i]; //Begin at second element
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
  [scheduleAuthor setObject:@20130101500000001 forKey:@"id"]; //TEST ONLY !!! - Update
  [scheduleDictionary setObject:scheduleAuthor forKey:@"author"];
  
  //schedule - periods
  NSMutableArray *schedulePeriodArray = [[NSMutableArray alloc] init];
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
  
  [scheduleDictionary setObject:schedulePeriodArray forKey:@"periods"];
  [serviceRequestJson setObject:scheduleDictionary forKey:@"schedules"];
  
  NSNumber *boolActive = [[NSNumber alloc] initWithBool:YES];
  [scheduleDictionary setObject:boolActive forKey:@"active"]; //TODO: active:boolean
  
  //Store dictionary in array first before passing to serviceRequestJson
  [scheduleArray addObject:scheduleDictionary];
  [serviceRequestJson setObject:scheduleArray forKey:@"schedules"];
  
  //Construct JSON request for Proposal update
  NSLog(@"For Proposal Service Request JSON: %@", serviceRequestJson);
  NSError *error = [[NSError alloc] init];
  NSData *jsonData = [NSJSONSerialization
                      dataWithJSONObject:serviceRequestJson
                      options:NSJSONWritingPrettyPrinted
                      error:&error];
  NSString *jsonString = [[NSString alloc]
                          initWithData:jsonData
                          encoding:NSUTF8StringEncoding];
  
  NSLog(@"jsonData Request: %@", jsonData);
  NSLog(@"jsonString Request: %@", jsonString);
  
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
  NSString *updateAlertMessage = [[NSString alloc] init];
  NSString *updateFailAlertMessage = [[NSString alloc] init];
  if([operationFlag isEqual:@"ACCEPTED"])
  {
    updateAlertMessage = @"Service Request Accepted.";
    updateFailAlertMessage = @"Service Request not accepted. Please try again later";
  }
  else if([operationFlag isEqual:@"PROPOSAL"])
  {
    updateAlertMessage = @"Service Request Under Proposal Stage.";
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
  NSLog(@"Service Request Proposal");
  
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


/*
#pragma mark - Validation if there are Schedule Periods entered
-(BOOL) validateSchedulePeriods: (NSMutableArray *) schedulePeriod
{
  NSLog(@"validateSchedulePeriods");
  NSLog(@"schedulePeriod count: %d", [schedulePeriod count]);
  //!!! TODO
  if ([schedulePeriod count] == 1) //1 element meaning default 'periods' node but empty of contents
  {
    UIAlertView *emptySchedulePeriodAlert = [[UIAlertView alloc]
                                             initWithTitle:@"Incomplete Information"
                                             message:@"No schedule period dates entered."
                                             delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [emptySchedulePeriodAlert show];
    
    return FALSE;
  }
  else
  {
    return TRUE;
  }
}
*/


#pragma mark - Dismiss onscreen keyboard
-(void)dismissKeyboard
{
  for (int i = 0; i < [proposalSRPageScroller.subviews count]; i++)
  {
    [[[proposalSRPageScroller subviews] objectAtIndex:i] resignFirstResponder];
  }  
}



@end