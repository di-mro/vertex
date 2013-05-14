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
@synthesize inspectionNotesArray;

@synthesize serviceRequestJson;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize datePicker;
@synthesize fromDate;

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
  
  //EstimatedCostField delegate - for the changing of color when editing
  estimatedCostField.textColor = [UIColor blueColor];
  [estimatedCostField setDelegate:self];
  
  //Populate fields based on previously selected Service Request for Inspection
  [self getServiceRequest];
  
  //Add Notes utilities - Store the first note and its coordinates so that when we add notes, it will align properly
  //notesTextAreaArray = [[NSMutableArray alloc] init];
  //[notesTextAreaArray addObject:notesTextArea];
  
  //Initialize array for inspection notes
  inspectionNotesArray = [[NSMutableArray alloc] init];
  
  //Initialize arrays for inspection schedule periods
  fromDatesArray = [[NSMutableArray alloc] init];
  fromTimesArray = [[NSMutableArray alloc] init];
  toDatesArray = [[NSMutableArray alloc] init];
  toTimesArray = [[NSMutableArray alloc] init];
  
  //Initialize dictionaries for inspection schedules
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
  addNotesButtonFrame = addNotesButton.frame;
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
  
  //Store added Notes text area in array for service request inspection notes
  [inspectionNotesArray addObject:newNoteTextArea];
  
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
  float addNotesButtonY = addNotesButtonFrame.origin.y;
  
  //Schedules Label
  schedulesLabelFrame = schedulesLabel.frame;
  schedulesLabelFrame.origin.y = (addNotesButtonY + 70);
  schedulesLabel.frame = schedulesLabelFrame;
  
  //Status Label
  scheduleStatusLabelFrame = statusLabel.frame;
  scheduleStatusLabelFrame.origin.y = (schedulesLabelFrame.origin.y + 30);
  statusLabel.frame = scheduleStatusLabelFrame;
  
  //Status Field
  scheduleStatusFieldFrame = statusField.frame;
  scheduleStatusFieldFrame.origin.y = (scheduleStatusLabelFrame.origin.y + 30);
  statusField.frame = scheduleStatusFieldFrame;
  
  //Author Label
  scheduleAuthorLabelFrame = authorLabel.frame;
  scheduleAuthorLabelFrame.origin.y = (scheduleStatusFieldFrame.origin.y + 35);
  authorLabel.frame = scheduleAuthorLabelFrame;
  
  //Author Field
  scheduleAuthorFieldFrame = authorField.frame;
  scheduleAuthorFieldFrame.origin.y = (scheduleAuthorLabelFrame.origin.y + 30);
  authorField.frame = scheduleAuthorFieldFrame;
  
  //Add Schedules Button
  addScheduleButtonFrame = addSchedulesButton.frame;
  addScheduleButtonFrame.origin.y = (scheduleAuthorFieldFrame.origin.y + 45);
  addSchedulesButton.frame = addScheduleButtonFrame;
}


#pragma mark - [Add Schedules] button implementation
- (IBAction)addInspectionScheduleFields:(id)sender
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
  /* If schedule date dictionary is empty - this is the first entry for schedules.
     Begin after schedule author field.
   */
  if (([scheduleFromDateDictionary count] == 0) || ([scheduleToDateDictionary count] == 0))
  {
    startingCoordinates.origin.y = (scheduleAuthorFieldFrame.origin.y + 45);
  }
  /* If schedule date dictionary is not empy - there are fields already set.
     Begin after the last 'To Date' field.
   */
  else
  {
    startingCoordinates.origin.y = (toDateFieldFrame.origin.y + 50);
  }
  
  UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(0, (startingCoordinates.origin.y), 320, 1)];
  separator.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
  [inspectSRScroller addSubview:separator];
  
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
  [inspectSRScroller addSubview:fromDateLabel];
  [inspectSRScroller addSubview:fromDateField];
  
  [inspectSRScroller addSubview:fromTimeLabel];
  [inspectSRScroller addSubview:fromTimeField];
  
  [inspectSRScroller addSubview:toDateLabel];
  [inspectSRScroller addSubview:toDateField];
  
  [inspectSRScroller addSubview:toTimeLabel];
  [inspectSRScroller addSubview:toTimeField];
  
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
}


-(void)getDate
{
  //[textfield setText:pick.date];
  fromDate = datePicker.date;
  NSLog(@"FROM DATE: %@", fromDate);
}

#pragma mark - Updating the color of entry in estimatedCostField depending whether changed or same with original
- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
  NSLog(@"textFieldDidBeginEditing");
  
  //Action Sheet definition
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                            delegate:nil
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:nil
                                   otherButtonTitles:nil];
  [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
  
  UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObject:@"Done"]];
  doneButton.momentary = YES;
  doneButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
  doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
  doneButton.tintColor = [UIColor blackColor];
  [doneButton addTarget:self action:@selector(getDate) forControlEvents:UIControlEventValueChanged];
  
  [actionSheet addSubview:doneButton];
  [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
  [actionSheet setBounds :CGRectMake(0, 0, 320, 500)];
  
  UIDatePicker *datePicker = [[UIDatePicker alloc] init];
  [datePicker setDatePickerMode:UIDatePickerModeDate];
  [actionSheet addSubview:datePicker];
  
  
  UITextField *tempField1 = [[UITextField alloc] init];
  tempField1 = [fromDatesArray objectAtIndex:0];
  
  UITextField *tempField2 = [[UITextField alloc] init];
  tempField2 = [fromTimesArray objectAtIndex:0];
  
  if(estimatedCostField.isEditing)
  {
    NSLog(@"estimatedCost field editing");
    estimatedCostField.textColor = [UIColor redColor];
    return YES;
  }
  else if (tempField1.isEditing)
  {
    NSLog(@"fromDate field");
    
    tempField1.delegate = self;
    tempField1.inputView = actionSheet;
  }
  else if (tempField2.isEditing)
  {
    NSLog(@"fromTimes field");
    tempField2.delegate = self;
    tempField2.inputView = actionSheet;
  }
  else
  {
    //estimatedCostField.textColor = [UIColor blueColor];
    return YES;
  }
  
  /*
   txtFecha.delegate = self;
   
   datePicker = [[UIDatePicker alloc]init];
   [datePicker setDatePickerMode:UIDatePickerModeDate];
   
   self.txtFecha.inputView = datePicker;
   */
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


#pragma mark - [Inspect] button implementation
- (void) inspectSR
{
  NSLog(@"Inspect Service Request");
  
  statusId = @20130101420000004;
  [self updateServiceRequestStatus:@"FOR INSPECTION"];
}


#pragma mark - Update Service Request status to 'Acknowledged'
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
  [statusJson setObject:statusId forKey:@"id"]; //For Inspection
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
  
  for(int i = 0; i < inspectionNotesArray.count; i++)
  {
    //sender
    [notesSenderJson setObject:@20130101500000001 forKey:@"id"]; //TEST ONLY - Remove hardcoded value
    [notesDictionary setObject:notesSenderJson forKey:@"sender"];
    
    //message
    UITextView *tempTextView = [[UITextView alloc] init];
    tempTextView = [inspectionNotesArray objectAtIndex:i]; //Begin at second element
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
  [scheduleStatusDictionary setObject:statusId forKey:@"id"]; //For Inspection
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
  
  //Validate if there are entries for Schedule periods
  if([self validateSchedulePeriods:[[serviceRequestJson valueForKey:@"schedules"] valueForKey:@"periods"]])
  {
    
    NSLog(@"For Inspection Service Request JSON: %@", serviceRequestJson);
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
    //URL = @"http://192.168.2.107/vertex-api/service-request/updateServiceRequest";
    URL = @"http://"; //TEST
    
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
    
    //Set alert message display depending on what operation is performed in this case (FOR INSPECTION)
    NSString *updateAlertMessage = [[NSString alloc] init];
    NSString *updateFailAlertMessage = [[NSString alloc] init];
    if([operationFlag isEqual:@"FOR INSPECTION"])
    {
      updateAlertMessage = @"Service Request Inspected.";
      updateFailAlertMessage = @"Service Request not inspected. Please try again later";
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
                                        initWithTitle:@"Inspect Service Request Failed"
                                        message:updateFailAlertMessage
                                        delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
      [updateSRFailAlert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Service Request Inspected");
  }
  else
  {
    NSLog(@"Service Request Not Inspected. Incomplete information.");
  }
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


#pragma mark - Dismiss onscreen keyboard
-(void)dismissKeyboard
{
  /*
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
  */
  
  for (int i = 0; i < [inspectSRScroller.subviews count]; i++)
  {
    [[[inspectSRScroller subviews] objectAtIndex:i] resignFirstResponder];
  }  
}



@end
