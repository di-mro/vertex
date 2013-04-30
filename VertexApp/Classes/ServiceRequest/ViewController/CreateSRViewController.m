//
//  CreateSRViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/15/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "CreateSRViewController.h"
#import "HomePageViewController.h"
#import "ServiceRequestViewController.h"
#import "Reachability.h"

@interface CreateSRViewController ()

@end

@implementation CreateSRViewController

@synthesize createSRScroller;
@synthesize actionSheet;
@synthesize assetPickerArray;
@synthesize lifecyclePickerArray;
@synthesize servicePickerArray;
@synthesize priorityPickerArray;

@synthesize assetField;
@synthesize lifecycleField;
@synthesize serviceField;
@synthesize estimatedCostField;
@synthesize priorityField;
@synthesize srGenericPicker;
@synthesize detailsTextArea;

@synthesize currentArray;
@synthesize currentTextField;

@synthesize URL;
@synthesize httpResponseCode;

//***
@synthesize lifecycles;
@synthesize assetTypes;
@synthesize services;
@synthesize priority;

@synthesize selectedIndex;

@synthesize lifecycleIdArray;
@synthesize assetTypeIdArray;
@synthesize servicesIdArray;
@synthesize priorityIdArray;

@synthesize selectedLifecycleId;
@synthesize selectedAssetTypeId;
@synthesize selectedServicesId;
@synthesize selectedPriorityId;
//***

@synthesize createSRJson;


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
  NSLog(@"Create Service Request Page");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSR)];
  
  //[Create] navigation button
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(createSR)];
  
  //Scroller size
  self.createSRScroller.contentSize = CGSizeMake(320.0, 900.0);
  
  //getAssetTypes
  self.assetPickerArray = [[NSArray alloc] init];
  assetTypeIdArray = [[NSMutableArray alloc] init];
  [self getAssetType];
  
  //getLifecycle
  self.lifecyclePickerArray = [[NSArray alloc] init];
  lifecycleIdArray = [[NSMutableArray alloc] init];
  [self getLifecycles];
  
  //getServices
  self.servicePickerArray = [[NSArray alloc] init];
  servicesIdArray = [[NSMutableArray alloc] init];
  
  //getPriority
  self.priorityPickerArray = [[NSArray alloc] initWithObjects:@"Demo - Emergency", @"Demo - Scheduled", @"Demo - Routine", @"Demo - Urgent", nil];
  priorityIdArray = [[NSMutableArray alloc] init];
  
  //Set delegates for the picker fields
  [assetField setDelegate:self];
  [lifecycleField setDelegate:self];
  [serviceField setDelegate:self];
  [priorityField setDelegate:self];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - getAssetType
- (void) getAssetType
{
  //Set URL for retrieving AssetTypes
  //URL = @"http://192.168.2.113:8080/vertex-api/asset/getAssetTypes";
  URL = @"http://192.168.2.113/vertex-api/asset/getAssetTypes";
  
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
    assetPickerArray = [[NSArray alloc] initWithObjects:@"Demo - Aircon",@"Demo - Door", @"Demo - Exhaust Fan", @"Demo - Faucet", @"Demo - Toilet", @"Demo - Kitchen Sink", @"Demo - Lighting Fixtures", nil];
    assetTypeIdArray = [[NSMutableArray alloc] initWithObjects: @"Demo - 00001", @"Demo - 00002", @"Demo - 00004", @"Demo - 00005", nil];
  }
  else
  {
    assetTypes = [NSJSONSerialization
                  JSONObjectWithData:responseData
                  options:kNilOptions
                  error:&error];
    NSLog(@"getAssetTypes JSON Result: %@", assetTypes);
    
    assetPickerArray = [assetTypes valueForKey:@"name"]; //store assetType names only in PickerArray
    assetTypeIdArray = [assetTypes valueForKey:@"id"];
    NSLog(@"assetPickerArray: %@", assetPickerArray);
  }
}


#pragma mark - getLifecycle
-(void) getLifecycles
{
  //endpoint for getLifecycles
  //URL = @"http://192.168.2.113:8080/vertex-api/lifecycle/getLifecycles";
  URL = @"http://192.168.2.113/vertex-api/lifecycle/getLifecycles";
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                      requestWithURL:[NSURL URLWithString:URL]];
  
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
    UIAlertView *lifecycleAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Warning"
                                    message:@"No network connection detected. Displaying data from phone cache."
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [lifecycleAlert show];
    
    //Connect to CoreData for local data
    //!- FOR TESTING ONLY -!
    lifecyclePickerArray = [[NSArray alloc] initWithObjects: @"Demo - Canvas", @"Demo - Requisition", @"Demo - Purchase", @"Demo - Installation", @"Demo - Repair", @"Demo - Decommission", nil];
    lifecycleIdArray = [[NSMutableArray alloc] initWithObjects: @"Demo - 00001", @"Demo - 00002", @"Demo - 00004", @"Demo - 00005", nil];
  }
  else
  {
    lifecycles = [NSJSONSerialization
                  JSONObjectWithData:responseData
                  options:kNilOptions
                  error:&error];
    NSLog(@"lifecycles JSON Result: %@", lifecycles);
    
    lifecyclePickerArray = [lifecycles valueForKey:@"name"]; //store lifecycles names only in PickerArray
    lifecycleIdArray = [lifecycles valueForKey:@"id"];
    NSLog(@"lifecyclePickerArray: %@", lifecyclePickerArray);
  }
}


#pragma mark - getServices
-(void) getServices
{
  //endpoint for getServices
  //URL = @"http://192.168.2.113:8080/vertex-api/service/getServices/{assetTypeId}/{lifecycleId}";
  //URL = @"http://192.168.2.113/vertex-api/service/getServices/{assetTypeId}/{lifecycleId}";
  //TODO - get selected assetTypeId & lifecycleId, construct URL
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:URL]];
  
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
    UIAlertView *servicesAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Warning"
                                   message:@"No network connection detected. Displaying data from phone cache."
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
    [servicesAlert show];
    
    //Connect to CoreData for local data
    //!- FOR TESTING ONLY -!
    servicePickerArray = [[NSArray alloc] initWithObjects: @"Demo - Fix broken pipe", @"Demo - Replace wiring", @"Demo - Repaint unit", @"Demo - Fix cooling unit", nil];
    servicesIdArray = [[NSMutableArray alloc] initWithObjects: @"Demo - 00001", @"Demo - 00002", @"Demo - 00004", @"Demo - 00005", nil];
    
  }
  else
  {
    services = [NSJSONSerialization
                  JSONObjectWithData:responseData
                  options:kNilOptions
                  error:&error];
    NSLog(@"services JSON Result: %@", services);
    
    servicePickerArray = [services valueForKey:@"name"]; //store lifecycles names only in PickerArray
    servicesIdArray = [services valueForKey:@"id"];
    NSLog(@"servicePickerArray: %@", servicePickerArray);
  }
}



#pragma mark - Check for network availability
-(BOOL)reachable
{
  Reachability *r = [Reachability  reachabilityWithHostName:URL];
  NetworkStatus internetStatus = [r currentReachabilityStatus];
  
  if(internetStatus == NotReachable)
  {
    return NO;
    
    UIAlertView *reachableAlert = [[UIAlertView alloc]
                                  initWithTitle:@"Warning"
                                  message:@"No network connection detected. Displaying data from phone cache."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
    [reachableAlert show];
    
  }
  
  return YES;
}


#pragma mark - Generic Picker definitions
-(void) defineGenericPicker
{
  //Generic Picker definition
  srGenericPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
  srGenericPicker.showsSelectionIndicator = YES;
  srGenericPicker.dataSource = self;
  srGenericPicker.delegate = self;
}


#pragma mark - Set fields to pickers
- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
  NSLog(@"textFieldDidBeginEditing");
  
  //Action Sheet definition
  actionSheet = [[UIActionSheet alloc] initWithTitle:nil
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
  [doneButton addTarget:self action:@selector(selectedRow) forControlEvents:UIControlEventValueChanged];
  
  [actionSheet addSubview:doneButton];
  [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
  [actionSheet setBounds :CGRectMake(0, 0, 320, 485)];

  if(assetField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - assetField");
    [textField resignFirstResponder];
    
    currentArray = [[NSArray alloc] initWithObjects: nil];
    [self defineGenericPicker];
    [actionSheet addSubview:srGenericPicker];
    
    currentArray = assetPickerArray;
    currentTextField = assetField;
    assetField.inputView = actionSheet;
    
    selectedAssetTypeId = [assetTypeIdArray objectAtIndex:selectedIndex];

    return YES;
  }
  else if(lifecycleField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - lifecycleField");
    [textField resignFirstResponder];
    
    currentArray = [[NSArray alloc] initWithObjects: nil];
    [self defineGenericPicker];
    [actionSheet addSubview:srGenericPicker];
    
    currentArray = lifecyclePickerArray;
    currentTextField = lifecycleField;
    lifecycleField.inputView = actionSheet;
    
    selectedLifecycleId = [lifecycleIdArray objectAtIndex:selectedIndex];
    
    return YES;
  }
  else if(serviceField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - serviceField");
    [textField resignFirstResponder];
    
    currentArray = [[NSArray alloc] initWithObjects: nil];
    [self defineGenericPicker];
    [actionSheet addSubview:srGenericPicker];
    
    currentArray = servicePickerArray;
    currentTextField = serviceField;
    serviceField.inputView = actionSheet;
    
    selectedServicesId = [servicesIdArray objectAtIndex:selectedIndex];
    
    return YES;
  }
  else if(priorityField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - priorityField");
    [textField resignFirstResponder];
    
    currentArray = [[NSArray alloc] initWithObjects: nil];
    [self defineGenericPicker];
    [actionSheet addSubview:srGenericPicker];
    
    currentArray = priorityPickerArray;
    currentTextField = priorityField;
    priorityField.inputView = actionSheet;
    
    selectedPriorityId = [priorityIdArray objectAtIndex:selectedIndex];
    
    return YES;
  }
  else
  {
    return NO;
  }
}


#pragma mark - Get selected row in Picker
-(void)selectedRow
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  selectedIndex = [srGenericPicker selectedRowInComponent:0];
  NSString *selectedEntity = [currentArray objectAtIndex:selectedIndex];
  currentTextField.text = selectedEntity;
}

#pragma mark - Dismissing onscreen keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.view endEditing:YES];
}

#pragma mark - Picker view functionalities
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  NSLog(@"Current Array - numberOfRowsInComponent: %@", currentArray);
  return [currentArray count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [currentArray objectAtIndex:row];
}


#pragma mark - [Cancel] button implementation
-(void) cancelSR
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Service Request");
  
  //Go back to Home
  HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - [Create] button implementation
-(void) createSR
{
  if ([self validateCreateSRFields])
  {
    /*
     "{
        ""asset"" :
        {
          ""id"" : number
        },
        ""lifecycle"" :
        {
          ""id"" : number
        },
        ""service"" :
        {
          ""id"" : number
        },
        ""admin"" :
        {
          ""id"" : number
        },
        ""requestor"" :
        {
          ""id"" : number
        },
        ""cost"" : double,
        ""remarks"" : string,
        ""adminRemarks"" : string,
        ""priority"" :
        {
          ""id"" : number
        },
        ""status"" :
        {
          ""id"" : number
        }
        ""schedules"" :
        [
          ""schedDate"" : date
        ]
     }"
     */
    //TODO : Construct JSON request body from user inputs in UI
    createSRJson = [[NSMutableDictionary alloc] init];
    
    //asset
    NSMutableDictionary *assetJson = [[NSMutableDictionary alloc] init];
    [assetJson setObject:selectedAssetTypeId forKey:@"id"];
    [createSRJson setObject:assetJson forKey:@"asset"];
    
    //lifecycle
    NSMutableDictionary *lifecycleJson = [[NSMutableDictionary alloc] init];
    [lifecycleJson setObject:selectedLifecycleId forKey:@"id"];
    [createSRJson setObject:lifecycleJson forKey:@"lifecycle"];
    
    //service
    NSMutableDictionary *serviceJson = [[NSMutableDictionary alloc] init];
    [serviceJson setObject:@1000000000 forKey:@"id"]; //TEST ONLY !!!
    [createSRJson setObject:serviceJson forKey:@"service"];
    
    //admin
    NSMutableDictionary *adminJson = [[NSMutableDictionary alloc] init];
    [adminJson setObject:@1000000000 forKey:@"id"]; //TEST ONLY !!!
    [createSRJson setObject:adminJson forKey:@"admin"];
    
    //requestor
    NSMutableDictionary *requestorJson = [[NSMutableDictionary alloc] init];
    [requestorJson setObject:@000000001 forKey:@"id"]; //TEST ONLY!!!
    [createSRJson setObject:requestorJson forKey:@"requestor"];
    
    //TEST ONLY!!! - ***
    [createSRJson setObject:@100.00 forKey:@"cost"];
    [createSRJson setObject:@"DEMO - Remarks" forKey:@"remarks"];
    [createSRJson setObject:@"DEMO - Admin Remarks" forKey:@"adminRemarks"];
    //***
    
    //priority
    NSMutableDictionary *priorityJson = [[NSMutableDictionary alloc] init];
    [priorityJson setObject:@2000000000 forKey:@"id"]; //TEST ONLY !!!
    [createSRJson setObject:priorityJson forKey:@"priority"];
    
    //status
    NSMutableDictionary *statusJson = [[NSMutableDictionary alloc] init];
    [statusJson setObject:@3000000000 forKey:@"id"]; //TEST ONLY !!!
    [createSRJson setObject:statusJson forKey:@"status"];
    
    //schedules
    NSMutableDictionary *scheduleJson = [[NSMutableDictionary alloc] init];
    [scheduleJson setObject:@"2013/04/09" forKey:@"schedDate"];
    [createSRJson setObject:scheduleJson forKey:@"schedules"];
    
    NSLog(@"Create Service Request JSON: %@", createSRJson);
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:createSRJson
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                            encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonData Request: %@", jsonData);
    NSLog(@"jsonString Request: %@", jsonString);
    
    //Set URL for Add Service Request
    //URL = @"http://192.168.2.113:8080/vertex-api/service-request/addServiceRequest";
    URL = @"http://192.168.2.113/vertex-api/service-request/addServiceRequest";
    NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:URL]];
    
    //POST method - Create
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]]];
    NSLog(@"%@", postRequest);
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:postRequest
                                   delegate:self];
    
    [connection start];
    
    NSLog(@"addServiceRequest - httpResponseCode: %d", httpResponseCode);
    if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
    {
      UIAlertView *createSRAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Create Service Request"
                                    message:@"Service Request Created."
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
      [createSRAlert show];
    }
    else //(httpResponseCode >= 400)
    {
      UIAlertView *createSRFailAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Create Service Request Failed"
                                        message:@"Service Request not created. Please try again later"
                                        delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
      [createSRFailAlert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Service Request Created");
    
    //Inform user Service Request is saved
    UIAlertView *createSRAlert = [[UIAlertView alloc] initWithTitle:@"Service Request"
                                                            message:@"Service Request Created."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
    [createSRAlert show];
    //Transition to Service Request Page - alertView clickedButtonAtIndex
  }
  else
  {
    NSLog(@"Unable to create Service Request");
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


#pragma mark - Dismiss Picker action sheet
-(void)dismissActionSheet:(id) sender
{
  [sender dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - 'Create Service Request' validation of fields
-(BOOL) validateCreateSRFields
{
  UIAlertView *createSRValidateAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Incomplete Information"
                                              message:@"Please fill out the necessary fields."
                                             delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
  
  if([assetField.text isEqualToString:(@"")]
     || [lifecycleField.text isEqualToString:(@"")]
     || [serviceField.text isEqualToString:(@"")]
     || [priorityField.text isEqualToString:(@"")])
  {
    [createSRValidateAlert show];
    return false;
  }
  else
  {
    return true;
  }
}

#pragma mark - Dismiss onscreen keyboard
-(void)dismissKeyboard
{
  [assetField resignFirstResponder];
  [lifecycleField resignFirstResponder];
  [serviceField resignFirstResponder];
  [estimatedCostField resignFirstResponder];
  [priorityField resignFirstResponder];
  [detailsTextArea resignFirstResponder];
}


@end
