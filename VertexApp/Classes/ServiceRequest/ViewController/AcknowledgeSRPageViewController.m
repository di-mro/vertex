//
//  AcknowledgeSRPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 5/6/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AcknowledgeSRPageViewController.h"
#import "AcknowledgeSRListViewController.h"
#import "HomePageViewController.h"
#import "ServiceRequestViewController.h"

@interface AcknowledgeSRPageViewController ()

@end

@implementation AcknowledgeSRPageViewController

@synthesize acknowledgeSRScroller;

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

@synthesize notesLabel;
@synthesize notesTextArea;

@synthesize userId;
@synthesize serviceRequestId;
@synthesize serviceRequestInfo;

@synthesize statusId;
@synthesize notesTextAreaArray;

@synthesize addNotesButton;

@synthesize  serviceRequestJson;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize cancelSRAcknowledgementConfirmation;
@synthesize rejectSRAcknowledgementConfirmation;


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
  NSLog(@"Acknowledge Service Request Page");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Back] (Cancel) navigation button
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back"
                                           style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(cancelAcknowledgeSR)];
  
  //[Reject] navigation button
  UIBarButtonItem *rejectButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Reject"
                                           style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(rejectSR)];
  
  self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:
                                              backButton
                                            , rejectButton
                                            , nil];
  
  //[Accept] navigation button
  UIBarButtonItem *acceptButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Accept"
                                           style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(acknowledgeSR)];
  
  //Initialize right bar button items
  self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:
                                               acceptButton
                                             , nil];
  
  //Scroller size
  self.acknowledgeSRScroller.contentSize = CGSizeMake(320.0, 3000.0);
  
  //Disable fields - for viewing only
  assetField.enabled         = NO;
  lifecycleField.enabled     = NO;
  serviceField.enabled       = NO;
  estimatedCostField.enabled = NO;
  dateRequestedField.enabled = NO;
  priorityField.enabled      = NO;
  requestorField.enabled     = NO;
  
  //Populate fields based on previously selected Service Request for Acknowledgement
  [self getServiceRequest];
  
  //Get logged user userAccountInformation
  userAccountInfoSQLManager = [UserAccountInfoManager alloc];
  userAccountsObject = [UserAccountsObject alloc];
  userAccountsObject = [userAccountInfoSQLManager getUserAccountInfo];
  
  userId = userAccountsObject.userId;
  NSLog(@"Acknowledge SR - userId: %@", userId);
  
  //Add Notes utilities - Store the first note and its coordinates so that when we add notes it will align properly
  notesTextAreaArray = [[NSMutableArray alloc] init];
  [notesTextAreaArray addObject:notesTextArea];
  
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
  NSLog(@"AcknowledgeSRPage - serviceRequestId: %@", serviceRequestId);
}


#pragma mark - [Cancel] button implementation
-(void) cancelAcknowledgeSR
{
  NSLog(@"Cancel Acknowledge Service Request");
  
  cancelSRAcknowledgementConfirmation = [[UIAlertView alloc]
                                             initWithTitle:@"Cancel Service Acknowledgement"
                                                   message:@"Are you sure you want to cancel this service request acknowledgement?"
                                                  delegate:self
                                         cancelButtonTitle:@"Yes"
                                         otherButtonTitles:@"No", nil];
  
  [cancelSRAcknowledgementConfirmation show];
  
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
    
    NSMutableString *requestorName = [NSMutableString stringWithFormat:@"%@ %@ %@ %@"
                                      , [[[serviceRequestInfo valueForKey:@"requestor"] valueForKey:@"info"] valueForKey:@"firstName"]
                                      , [[[serviceRequestInfo valueForKey:@"requestor"] valueForKey:@"info"] valueForKey:@"middleName"]
                                      , [[[serviceRequestInfo valueForKey:@"requestor"] valueForKey:@"info"] valueForKey:@"lastName"]
                                      , [[[serviceRequestInfo valueForKey:@"requestor"] valueForKey:@"info"] valueForKey:@"suffix"]];
    requestorField.text = requestorName;
    
    //Retrieving notes for display
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
      NSMutableString *noteDate    = [[retrievedNotesDictionary valueForKey:@"notes"] valueForKey:@"creationDate"];
      
      notesDisplay = [NSMutableString stringWithFormat:@"Sender: %@\nDate: %@\n\n%@"
                      , notesAuthor
                      , noteDate
                      , noteMessage];
      
      NSLog(@"notesDisplay: %@", notesDisplay);
    }
    notesTextArea.text = notesDisplay;
  }
}


#pragma mark - [Add Notes] button implementation
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
  prevNoteTextView   = [notesTextAreaArray lastObject];
  CGRect noteFrame   = newNoteTextArea.frame;
  noteFrame.origin.x = 17;
  noteFrame.origin.y = (prevNoteTextView.frame.origin.y + 130);
  newNoteTextArea.frame = noteFrame;
  
  //Add Notes text area in view
  [acknowledgeSRScroller addSubview:newNoteTextArea];
  
  //Store added Notes text area in array
  [notesTextAreaArray addObject:newNoteTextArea];
  
  //Adjust position of [Add Notes] button when new text area is added
  CGRect addNotesButtonFrame   = addNotesButton.frame;
  addNotesButtonFrame.origin.x = 20;
  addNotesButtonFrame.origin.y = (newNoteTextArea.frame.origin.y + 150);
  addNotesButton.frame = addNotesButtonFrame;
}


#pragma mark - [Reject] button implementation
-(void) rejectSR
{
  NSLog(@"Reject Service Request");
  
  rejectSRAcknowledgementConfirmation = [[UIAlertView alloc]
                                             initWithTitle:@"Reject Service Request"
                                                   message:@"Are you sure you want to reject this service request?"
                                                  delegate:self
                                         cancelButtonTitle:@"Yes"
                                         otherButtonTitles:@"No", nil];
  
  [rejectSRAcknowledgementConfirmation show];
  
  //StatusId setting is in alertView delegate method
}


#pragma mark - Transition to a Page depending on what alert box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if([alertView isEqual:cancelSRAcknowledgementConfirmation])
  {
    NSLog(@"Cancel SR Acknowledement");
    if(buttonIndex == 0) //Yes - Cancel
    {
      //Go back to SR Page
      ServiceRequestViewController* controller = (ServiceRequestViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SRPage"];
      
      [self.navigationController pushViewController:controller animated:YES];
    }
  }
  else if ([alertView isEqual:rejectSRAcknowledgementConfirmation])
  {
    NSLog(@"Reject SR Acknowledgement");
    
    if(buttonIndex == 0) //Yes - Reject
    {
      statusId = @20130101420000002;
      [self updateServiceRequestStatus:@"REJECT"];
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


#pragma mark - [Accept] button implementation
-(void) acknowledgeSR
{
  NSLog(@"Acknowledge Service Request");
  
  statusId = @20130101420000003;
  [self updateServiceRequestStatus:@"ACKNOWLEDGE"];
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
  [statusJson setObject:statusId forKey:@"id"]; //Acknowledge or Reject
  [serviceRequestJson setObject:statusJson forKey:@"status"];
  
  //admin
  NSMutableDictionary *adminJson = [[NSMutableDictionary alloc] init];
  [adminJson setObject:@20130101500000001 forKey:@"id"]; //!!!TODO - TEST ONLY !!!
  [serviceRequestJson setObject:adminJson forKey:@"admin"];
  
  //cost
  [serviceRequestJson setObject:[serviceRequestInfo valueForKey:@"cost"] forKey:@"cost"];
  
  
  //schedules
  NSMutableDictionary *scheduleDictionary = [[NSMutableDictionary alloc] init];
  //schedule - status
  NSMutableDictionary *scheduleStatusDictionary = [[NSMutableDictionary alloc] init];
  NSMutableArray *scheduleArray = [[NSMutableArray alloc] init];
  
  //Check if schedules node is null before updating
  //TODO - schedules validation
  if([[serviceRequestInfo objectForKey:@"schedules"] count] == 0)
  {
    NSLog(@"No record for Service Request Schedules");
  }
  else
  {
    NSLog(@"service request schedules JSON assembly");
    [scheduleStatusDictionary setObject:statusId forKey:@"id"]; //Acknowledge or Reject
    [scheduleDictionary setObject:scheduleStatusDictionary forKey:@"status"];
    
    //schedule - author
    NSMutableDictionary *scheduleAuthor = [[NSMutableDictionary alloc] init];
    [scheduleAuthor setObject:userId forKey:@"id"];
    [scheduleDictionary setObject:scheduleAuthor forKey:@"author"];
    
    //schedule - periods
    //Only one or no schedule is set in SR Acknowledgement phase
    [scheduleDictionary setObject:[[[serviceRequestInfo valueForKey:@"schedules"] valueForKey:@"periods"] objectAtIndex:0] forKey:@"periods"];
    NSLog(@"scheduleDictionary - periods: %@", [scheduleDictionary valueForKey:@"periods"]);
    
    NSNumber *boolActive = [[NSNumber alloc] initWithBool:YES];
    [scheduleDictionary setObject:boolActive forKey:@"active"]; //TODO: active:boolean
    
    //Store dictionary in array first before passing to serviceRequestJson
    [scheduleArray addObject:scheduleDictionary];
  }
  
  [serviceRequestJson setObject:scheduleArray forKey:@"schedules"];

  
  //notes
  NSMutableDictionary *notesDictionary = [[NSMutableDictionary alloc] init];
  NSMutableDictionary *notesSenderJson = [[NSMutableDictionary alloc] init];
  NSMutableArray *notesArray = [[NSMutableArray alloc] init];

  //Check if notes node is null before updating
  //TODO - Notes validation
  if ([[serviceRequestInfo objectForKey:@"notes"] count] == 0)
  {
    NSLog(@"No record for Service Request Notes");
  }
  else
  {
    for(int i = 1; i < notesTextAreaArray.count; i++) //begin at the second text area
    {
      //sender
      [notesSenderJson setObject:userId forKey:@"id"];
      [notesDictionary setObject:notesSenderJson forKey:@"sender"];
      
      //message
      UITextView *tempTextView = [[UITextView alloc] init];
      tempTextView = [notesTextAreaArray objectAtIndex:i]; //Begin at second element
      [notesDictionary setObject:tempTextView.text forKey:@"message"];
      
      //save the sender-message node in an array, (i-1) because we begin at the second notes area
      [notesArray insertObject:notesDictionary atIndex:(i-1)];
    }
  }
  
  [serviceRequestJson setObject:notesArray forKey:@"notes"];
  
  
  NSLog(@"Acknowledge Service Request JSON: %@", serviceRequestJson);
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
  //URL = @"http://blah";
  
  NSMutableURLRequest *putRequest = [NSMutableURLRequest
                                      requestWithURL:[NSURL URLWithString:URL]];
  
  //PUT method - Update
  [putRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [putRequest setHTTPMethod:@"PUT"];
  [putRequest setHTTPBody:[NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]]];
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:putRequest
                                        delegate:self];
  
  [connection start];
  
  NSLog(@"updateServiceRequest - httpResponseCode: %d", httpResponseCode);
  
  //Set alert message display depending on what operation is performed (Acknowledged || Rejected)
  NSString *updateAlertMessage     = [[NSString alloc] init];
  NSString *updateFailAlertMessage = [[NSString alloc] init];
  
  if([operationFlag isEqual:@"REJECT"])
  {
    updateAlertMessage     = @"Service Request Rejected.";
    updateFailAlertMessage = @"Service Request not rejected. Please try again later";
  }
  else if([operationFlag isEqual:@"ACKNOWLEDGE"])
  {
    updateAlertMessage     = @"Service Request Acknowledged.";
    updateFailAlertMessage = @"Service Request not acknowledged. Please try again later";
  }
  
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
                                          initWithTitle:@"Acknowledge Service Request Failed"
                                                message:updateFailAlertMessage
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    [updateSRFailAlert show];
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Service Request Acknowledged");
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
  [assetField resignFirstResponder];
  [lifecycleField resignFirstResponder];
  [serviceField resignFirstResponder];
  [estimatedCostField resignFirstResponder];
  [dateRequestedField resignFirstResponder];
  [priorityField resignFirstResponder];
  [requestorField resignFirstResponder];
  [notesTextArea resignFirstResponder];
  
  for(int i = 0; i < notesTextAreaArray.count; i++)
  {
    [[notesTextAreaArray objectAtIndex:i] resignFirstResponder];
  }
}


@end
