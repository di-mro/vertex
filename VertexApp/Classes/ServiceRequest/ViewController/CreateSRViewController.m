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
@synthesize notesTextArea;

@synthesize currentArray;
@synthesize currentTextField;

@synthesize URL;
@synthesize httpResponseCode;

//***
@synthesize lifecycles;
@synthesize assetTypes;
@synthesize services;
@synthesize priorities;

@synthesize selectedIndex;

@synthesize lifecycleIdArray;
@synthesize assetTypeIdArray;
@synthesize servicesIdArray;
@synthesize priorityIdArray;

@synthesize servicesCostArray;
@synthesize serviceCost;

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
  servicesCostArray = [[NSMutableArray alloc] init];
  serviceCost = 0;
  estimatedCostField.enabled = NO;
  //[self getServices];
  
  //getPriorities
  self.priorityPickerArray = [[NSArray alloc] init];
  priorityIdArray = [[NSMutableArray alloc] init];
  [self getPriorities];
  
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
  //URL = @"http://192.168.2.113/vertex-api/asset/getAssetTypes";
  URL = @"http://192.168.2.107/vertex-api/asset/getAssetTypes";
  
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
  //URL = @"http://192.168.2.113/vertex-api/lifecycle/getLifecycles";
  URL = @"http://192.168.2.107/vertex-api/lifecycle/getLifecycles";
  
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
  //URL = @"http://192.168.2.113/vertex-api/service/getServices/{assetTypeId}/{lifecycleId}";
  //URL = @"http://192.168.2.113/vertex-api/service/getServices";
  //URL = @"http://192.168.2.107/vertex-api/service/getServices/{assetTypeId}/{lifecycleId}";
  //URL = @"http://192.168.2.107/vertex-api/service/getServices";
  
  NSLog(@"selectedAssetTypeId: %@", selectedAssetTypeId);
  NSLog(@"selectedLifecycleId: %@", selectedLifecycleId);
  
  //TODO - get selected assetTypeId & lifecycleId, construct URL
  NSMutableString *urlParams = [NSMutableString stringWithFormat:@"http://192.168.2.107/vertex-api/service/getServices/%@/%@", selectedAssetTypeId, selectedLifecycleId];
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:urlParams]]; //URL
  
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
    servicesIdArray = [[NSMutableArray alloc] initWithObjects: @"Demo - 00001", @"Demo - 00002", @"Demo - 00003", @"Demo - 00004", nil];
    servicesCostArray = [[NSMutableArray alloc] initWithObjects:@"Demo - 100.00", @"Demo - 200.00", @"Demo - 300.00", @"Demo - 400.00", nil];
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
    servicesCostArray = [services valueForKey:@"cost"];
    NSLog(@"servicePickerArray: %@", servicePickerArray);
  }
}


#pragma mark - getPriorities
-(void) getPriorities
{
  //endpoint for getPriorities
  //URL = @"http://192.168.2.113/vertex-api/service-request/getPriorities";
  URL = @"http://192.168.2.107/vertex-api/service-request/getPriorities";
  
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
    UIAlertView *prioritiesAlert = [[UIAlertView alloc]
                                  initWithTitle:@"Warning"
                                  message:@"No network connection detected. Displaying data from phone cache."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
    [prioritiesAlert show];
    
    //Connect to CoreData for local data
    //!- FOR TESTING ONLY -!
    self.priorityPickerArray = [[NSArray alloc] initWithObjects:@"Demo - High", @"Demo - Medium", @"Demo - Low", nil];
    priorityIdArray = [[NSMutableArray alloc] initWithObjects: @"Demo - 00001", @"Demo - 00002", @"Demo - 00003", nil];
  }
  else
  {
    priorities = [NSJSONSerialization
                JSONObjectWithData:responseData
                options:kNilOptions
                error:&error];
    NSLog(@"priorities JSON Result: %@", priorities);
    
    priorityPickerArray = [priorities valueForKey:@"name"]; //store priority names only in PickerArray
    priorityIdArray = [priorities valueForKey:@"id"];
    NSLog(@"priorityPickerArray: %@", priorityPickerArray);
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
  //[doneButton addTarget:self action:@selector(selectedRow) forControlEvents:UIControlEventValueChanged];
  
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
    
    [doneButton addTarget:self action:@selector(getAssetTypeIndex) forControlEvents:UIControlEventValueChanged];
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
    
    //[Done] button functionality changes depending on what field/picker is being edited
    [doneButton addTarget:self action:@selector(getLifecycleIndex) forControlEvents:UIControlEventValueChanged];
    return YES;
  }
  else if(serviceField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - serviceField");
    [textField resignFirstResponder];
    
    //Connect to endpoint with the selected asset type and lifecycle ids as parameters
    [self getServices];
    
    currentArray = [[NSArray alloc] initWithObjects: nil];
    [self defineGenericPicker];
    [actionSheet addSubview:srGenericPicker];
    
    currentArray = servicePickerArray;
    currentTextField = serviceField;
    serviceField.inputView = actionSheet;
    
    [doneButton addTarget:self action:@selector(getServiceIndex) forControlEvents:UIControlEventValueChanged];
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
    
    [doneButton addTarget:self action:@selector(getPriorityIndex) forControlEvents:UIControlEventValueChanged];
    return YES;
  }
  else
  {
    return NO;
  }
}

//****
-(void) getAssetTypeIndex
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  int assetTypeIndex = [srGenericPicker selectedRowInComponent:0];
  NSLog(@"assetTypeIndex: %d", assetTypeIndex);
  selectedAssetTypeId = [assetTypeIdArray objectAtIndex:assetTypeIndex]; //selectedIndex
  NSLog(@"selectedAssetTypeId: %@", selectedAssetTypeId);
  
  NSString *selectedEntity = [currentArray objectAtIndex:assetTypeIndex];
  currentTextField.text = selectedEntity;
}

-(void) getLifecycleIndex
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  int lifecycleIndex = [srGenericPicker selectedRowInComponent:0];
  NSLog(@"lifecycleIndex: %d", lifecycleIndex);
  selectedLifecycleId = [lifecycleIdArray objectAtIndex:lifecycleIndex]; //selectedIndex
  NSLog(@"selectedLifecycleId: %@", selectedLifecycleId);
  
  NSString *selectedEntity = [currentArray objectAtIndex:lifecycleIndex];
  currentTextField.text = selectedEntity;
}

-(void) getServiceIndex
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  int serviceIndex = [srGenericPicker selectedRowInComponent:0];
  NSLog(@"serviceIndex: %d", serviceIndex);
  selectedServicesId = [servicesIdArray objectAtIndex:serviceIndex]; //selectedIndex
  NSLog(@"selectedServicesId: %@", selectedServicesId);
  
  serviceCost = [servicesCostArray objectAtIndex:serviceIndex];
  estimatedCostField.text = serviceCost;
  NSLog(@"serviceCost: %@", serviceCost);
  
  NSString *selectedEntity = [currentArray objectAtIndex:serviceIndex];
  currentTextField.text = selectedEntity;
}

-(void) getPriorityIndex
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  int priorityIndex = [srGenericPicker selectedRowInComponent:0];
  NSLog(@"priorityIndex: %d", priorityIndex);
  selectedPriorityId = [priorityIdArray objectAtIndex:priorityIndex]; //selectedIndex
  NSLog(@"selectedPriorityId: %@", selectedPriorityId);
  
  NSString *selectedEntity = [currentArray objectAtIndex:priorityIndex];
  currentTextField.text = selectedEntity;
}
//****


#pragma mark - Get selected row name in picker field and display it in the text field
-(void)selectedRow
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  selectedIndex = 0;
  selectedIndex = [srGenericPicker selectedRowInComponent:0];
  NSLog(@"selectedIndex: %d", selectedIndex);
  NSString *selectedEntity = [currentArray objectAtIndex:selectedIndex];
  currentTextField.text = selectedEntity;
  
  //Show estimated cost based on selected service. Show only, no editing
  estimatedCostField.text = @"";
  estimatedCostField.text = serviceCost;
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
  //NSLog(@"Current Array - numberOfRowsInComponent: %@", currentArray);
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
        "asset" :
        {
          "id" : long
        },
        "lifecycle" :
        {
          "id" : long
        },
        "service" :
        {
          "id" : long
        },
        "priority" :
        {
          "id" : long
        },
        "status" :
        {
          "id" : long
        },
        "requestor" :
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
                "fromDate"    : string,
                "fromTime"    : string,
                "fromTimezone": string,
                "toDate"      : string,
                "toTime"      : string,
                "toTimezone"  : string
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
    [serviceJson setObject:selectedServicesId forKey:@"id"]; //TEST ONLY !!!
    [createSRJson setObject:serviceJson forKey:@"service"];
    
    //priority
    NSMutableDictionary *priorityJson = [[NSMutableDictionary alloc] init];
    [priorityJson setObject:selectedPriorityId forKey:@"id"];
    [createSRJson setObject:priorityJson forKey:@"priority"];
    
    //status
    NSMutableDictionary *statusJson = [[NSMutableDictionary alloc] init];
    [statusJson setObject:@"Demo - StatusID0001" forKey:@"id"];
    [createSRJson setObject:statusJson forKey:@"status"];
    
    //requestor
    NSMutableDictionary *requestorJson = [[NSMutableDictionary alloc] init];
    [requestorJson setObject:@20130101500000001 forKey:@"id"]; //TEST ONLY!!!
    [createSRJson setObject:requestorJson forKey:@"requestor"];
    
    //admin
    NSMutableDictionary *adminJson = [[NSMutableDictionary alloc] init];
    [adminJson setObject:@20130101800000001 forKey:@"id"]; //TEST ONLY !!!
    [createSRJson setObject:adminJson forKey:@"admin"];
    
    //cost
    [createSRJson setObject:serviceCost forKey:@"cost"];
    
    
    //TODO - schedules !!!
    NSMutableDictionary *scheduleDictionary = [[NSMutableDictionary alloc] init];
    
    //schedule - status
    NSMutableDictionary *scheduleStatusDictionary = [[NSMutableDictionary alloc] init];
    [scheduleStatusDictionary setObject:@1234567890 forKey:@"id"];
    [scheduleDictionary setObject:scheduleStatusDictionary forKey:@"status"];
    
    //schedule - author
    NSMutableDictionary *scheduleAuthor = [[NSMutableDictionary alloc] init];
    [scheduleAuthor setObject:@1234567890 forKey:@"id"];
    [scheduleDictionary setObject:scheduleAuthor forKey:@"author"];
    
    //schedule - periods
    //NSDate *date
    NSMutableDictionary *schedulePeriodDictionary = [[NSMutableDictionary alloc] init];
    [schedulePeriodDictionary setObject:@"2013-05-05" forKey:@"fromDate"];
    [schedulePeriodDictionary setObject:@"12:12:12" forKey:@"fromTime"];
    [schedulePeriodDictionary setObject:@"GMT+8" forKey:@"fromTimezone"];
    [schedulePeriodDictionary setObject:@"2013-05-06" forKey:@"toDate"];
    [schedulePeriodDictionary setObject:@"11:11:11" forKey:@"toTime"];
    [schedulePeriodDictionary setObject:@"GMT+8" forKey:@"toTimezone"];
    
    [scheduleDictionary setObject:schedulePeriodDictionary forKey:@"periods"];
    NSNumber *boolActive = [[NSNumber alloc] initWithBool:YES];
    [scheduleDictionary setObject:boolActive forKey:@"active"]; //active:boolean
    [createSRJson setObject:scheduleDictionary forKey:@"schedule"];
    
    
    //TODO - notes !!!
    NSMutableDictionary *notesDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *notesSenderJson = [[NSMutableDictionary alloc] init];
    [notesSenderJson setObject:@1234567890 forKey:@"id"];
    [notesDictionary setObject:notesSenderJson forKey:@"sender"];
    [notesDictionary setObject:notesTextArea.text forKey:@"message"];
    [createSRJson setObject:notesDictionary forKey:@"notes"];
    
    //***
  
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
    //URL = @"http://192.168.2.113/vertex-api/service-request/addServiceRequest";
    URL = @"http://192.168.2.107/vertex-api/service-request/addServiceRequest";
    
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
                                    initWithTitle:@"Service Request"
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
  [notesTextArea resignFirstResponder];
}


@end
