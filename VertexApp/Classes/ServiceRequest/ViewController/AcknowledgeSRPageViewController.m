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

@synthesize notesLabel;
@synthesize notesTextArea;

@synthesize userId;
@synthesize serviceRequestId;
@synthesize serviceRequestInfo;

@synthesize statusId;
@synthesize notesTextAreaArray;
//@synthesize notesDictionary;
//@synthesize notesArray;

@synthesize addNotesButton;

@synthesize  serviceRequestJson;

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
  NSLog(@"Acknowledge Service Request Page");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAcknowledgeSR)];
  
  //[Reject] navigation button
  UIBarButtonItem *rejectButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Reject"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(rejectSR)];
  
  //[Accept] navigation button
  UIBarButtonItem *acceptButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Accept"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(acknowledgeSR)];
  
  //Initialize bar button items
  self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rejectButton, acceptButton, nil];
  
  //Scroller size
  self.acknowledgeSRScroller.contentSize = CGSizeMake(320.0, 2000.0);
  
  //Disable fields - for viewing only
  assetField.enabled = NO;
  lifecycleField.enabled = NO;
  serviceField.enabled = NO;
  estimatedCostField.enabled = NO;
  dateRequestedField.enabled = NO;
  priorityField.enabled = NO;
  
  //Populate fields based on previously selected Service Request for Acknowledgement
  [self getServiceRequest];
  
  //Add Notes utilities
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
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Acknowledge Service Request");
  
  /*
  //Go back to Acknowledgement List Page
  AcknowledgeSRListViewController* controller = (AcknowledgeSRListViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AcknowledgeSRListPage"];
  */
  
  //Go back to Home Page
  HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Get Service Request by serviceRequestId
-(void) getServiceRequest
{
  //endpoint for getServiceRequest/{serviceRequestId}
  NSMutableString *urlParams = [NSMutableString stringWithFormat:@"http://192.168.2.113/vertex-api/service-request/getServiceRequest/%@", serviceRequestId]; //107
  
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
    notesTextArea.text      = @"Filter is dirty";

  }
  else
  {
    serviceRequestInfo = [NSJSONSerialization
                                      JSONObjectWithData:responseData
                                      options:kNilOptions
                                      error:&error];
    NSLog(@"getServiceRequest JSON Result: %@", serviceRequestInfo);
    
    NSLog(@"%@", [[serviceRequestInfo valueForKey:@"asset"] valueForKey:@"name"]);
    NSLog(@"%@", [[serviceRequestInfo valueForKey:@"lifecycle"] valueForKey:@"name"]);
    NSLog(@"%@", [[serviceRequestInfo valueForKey:@"service"] valueForKey:@"name"]);
    NSLog(@"%@", [serviceRequestInfo valueForKey:@"cost"]);
    NSLog(@"%@", [serviceRequestInfo valueForKey:@"createdDate"]);
    NSLog(@"%@", [[serviceRequestInfo valueForKey:@"priority"] valueForKey:@"name"]);
    //NSLog(@"%@", [[serviceRequestInfo valueForKey:@"notes"] valueForKey:@"message"]);
    
    assetField.text         = [[serviceRequestInfo valueForKey:@"asset"] valueForKey:@"name"];
    lifecycleField.text     = [[serviceRequestInfo valueForKey:@"lifecycle"] valueForKey:@"name"];
    serviceField.text       = [[serviceRequestInfo valueForKey:@"service"] valueForKey:@"name"];
    estimatedCostField.text = [serviceRequestInfo valueForKey:@"cost"];
    dateRequestedField.text = [serviceRequestInfo valueForKey:@"createdDate"];
    priorityField.text      = [[serviceRequestInfo valueForKey:@"priority"] valueForKey:@"name"];
    //notesTextArea.text      = @"Blah blah";
    
    /*
     notes: [
     {
      id: "20130506026000026",
      sender: 
      {
        id: "20130101500000001",
        info: 
        {
          lastName: "dela Cruz",
          firstName: "Juan",
          middleName: "Pedro",
          suffix: "Sr"
        }
      },
      creationDate: "20130506",
      creationTime: "1519",
      creationTimezone: "PHT",
      message: "Aircon in living room"
     }
     ]
     */
    
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
      NSMutableString *noteDate = [[retrievedNotesDictionary valueForKey:@"notes"] valueForKey:@"creationDate"];
      
      notesDisplay = [NSMutableString stringWithFormat:@"Sender: %@\nDate: %@\n\n%@", notesAuthor, noteDate, noteMessage];
      NSLog(@"notesDisplay: %@", notesDisplay);
      
    }
    
    notesTextArea.text = notesDisplay;
  }
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
  [newNoteTextArea setFont:[UIFont systemFontOfSize:17]];
  
  //Get the location of prev Notes text area and adjust new Notes area location based on that
  UITextView *prevNoteTextView = [[UITextView alloc] init];
  prevNoteTextView = [notesTextAreaArray lastObject];
  CGRect noteFrame = newNoteTextArea.frame;
  noteFrame.origin.x = 17;
  noteFrame.origin.y = (prevNoteTextView.frame.origin.y + 130);
  newNoteTextArea.frame = noteFrame;
  
  //Add Notes text area in view
  [acknowledgeSRScroller addSubview:newNoteTextArea];
  
  //Store added Notes text area in array
  [notesTextAreaArray addObject:newNoteTextArea];
  NSLog(@"notesTextAreaArray: %@", notesTextAreaArray);
  
  //Adjust position of [Add Notes] button when new text area is added
  CGRect addNotesButtonFrame = addNotesButton.frame;
  addNotesButtonFrame.origin.x = 20;
  addNotesButtonFrame.origin.y = (newNoteTextArea.frame.origin.y + 150);
  addNotesButton.frame = addNotesButtonFrame;
}


#pragma mark - [Reject] button implementation
-(void) rejectSR
{
  NSLog(@"Reject Service Request");
  
  statusId = @20130101420000002;
  [self updateServiceRequestStatus];
}


#pragma mark - [Accept] button implementation
-(void) acknowledgeSR
{
  NSLog(@"Acknowledge Service Request");
  
  statusId = @20130101420000003;
  [self updateServiceRequestStatus];
}


#pragma mark - Update Service Request status to 'Acknowledged'
-(void) updateServiceRequestStatus
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
  NSMutableDictionary *statusJson = [[NSMutableDictionary alloc] init];
  [statusJson setObject:statusId forKey:@"id"]; //Acknowledge or Reject
  [serviceRequestJson setObject:statusJson forKey:@"status"];
  
  //admin
  NSMutableDictionary *adminJson = [[NSMutableDictionary alloc] init];
  [adminJson setObject:@20130101500000001 forKey:@"id"]; //TEST ONLY !!!
  [serviceRequestJson setObject:adminJson forKey:@"admin"];
  
  //cost
  [serviceRequestJson setObject:[serviceRequestInfo valueForKey:@"cost"] forKey:@"cost"];
  
  //schedules
  NSMutableDictionary *scheduleDictionary = [[NSMutableDictionary alloc] init];
  [scheduleDictionary setObject:[serviceRequestInfo valueForKey:@"schedules"] forKey:@"schedules"]; //>> change schedule status to 'Acknowledged'
  
  //notes
  NSMutableDictionary *notesDictionary = [[NSMutableDictionary alloc] init];
  NSMutableDictionary *notesSenderJson = [[NSMutableDictionary alloc] init];
  NSMutableArray *notesArray = [[NSMutableArray alloc] init];
  
  for(int i = 1; i < notesTextAreaArray.count; i++) //begin at the second text area
  {
    //sender
    [notesSenderJson setObject:@20130101500000001 forKey:@"id"]; //TEST ONLY - Remove hardcoded value
    [notesDictionary setObject:notesSenderJson forKey:@"sender"];
    
    //message
    UITextView *tempTextView = [[UITextView alloc] init];
    tempTextView = [notesTextAreaArray objectAtIndex:i];
    [notesDictionary setObject:tempTextView.text forKey:@"message"];
    
    //save the sender-message node in an array
    [notesArray insertObject:notesDictionary atIndex:(i-1)];
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
  
  //Set URL for Add Service Request
  URL = @"http://192.168.2.113/vertex-api/service-request/updateServiceRequest";
  //URL = @"http://192.168.2.107/vertex-api/service-request/updateServiceRequest";
  
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
  
  NSLog(@"addServiceRequest - httpResponseCode: %d", httpResponseCode);
  if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
  {
    UIAlertView *updateSRAlert = [[UIAlertView alloc]
                                  initWithTitle:@"Service Request"
                                  message:@"Service Request Acknowledged."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
    [updateSRAlert show];
  }
  else //(httpResponseCode >= 400)
  {
    UIAlertView *updateSRFailAlert = [[UIAlertView alloc]
                                      initWithTitle:@"Acknowledge Service Request Failed"
                                      message:@"Service Request not acknowledged. Please try again later"
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
  [notesTextArea resignFirstResponder];
  
  for(int i = 0; i < notesTextAreaArray.count; i++)
  {
    [[notesTextAreaArray objectAtIndex:i] resignFirstResponder];
  }
}


@end
