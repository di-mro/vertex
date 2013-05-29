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
@synthesize dateRequestedField;
@synthesize priorityField;
@synthesize srGenericPicker;
@synthesize notesTextArea;

@synthesize currentArray;
@synthesize currentTextField;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize userId;

@synthesize managedAssetsArray;
@synthesize ownedAssetsArray;
@synthesize managedAssetsIdArray;
@synthesize ownedAssetsIdArray;
@synthesize managedAssetTypeIdArray;
@synthesize ownedAssetTypeIdArray;

@synthesize ownedAssets;
@synthesize managedAssets;
@synthesize lifecycles;
@synthesize services;
@synthesize priorities;

@synthesize dateRequested;

@synthesize selectedIndex;

@synthesize assetIdArray;
@synthesize assetTypeIdArray;
@synthesize lifecycleIdArray;
@synthesize servicesIdArray;
@synthesize priorityIdArray;

@synthesize servicesCostArray;
@synthesize serviceCost;

@synthesize selectedAssetId;
@synthesize selectedAssetTypeId;
@synthesize selectedLifecycleId;
@synthesize selectedServicesId;
@synthesize selectedPriorityId;

@synthesize serviceRequestJson;

@synthesize cancelSRConfirmation;


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
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelSR)];
  
  //[Create] navigation button
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(createSR)];
  
  //Scroller size
  self.createSRScroller.contentSize = CGSizeMake(320.0, 900.0);
  
  //getAssetTypes
  assetPickerArray = [[NSMutableArray alloc] init];
  assetIdArray     = [[NSMutableArray alloc] init];
  [self getUserAssets];
  
  //getLifecycle
  lifecyclePickerArray = [[NSArray alloc] init];
  lifecycleIdArray     = [[NSMutableArray alloc] init];
  //Call to getLifecycle is in texFieldDidBeginEditing method, must get the assetType id first before calling getLifecycle
  
  //getServices
  servicePickerArray = [[NSArray alloc] init];
  servicesIdArray    = [[NSMutableArray alloc] init];
  servicesCostArray  = [[NSMutableArray alloc] init];
  serviceCost        = 0;
  //Call to getServices is in texFieldDidBeginEditing method, must get the assetType and lifecycle id first before calling getServices
  
  //getPriorities
  priorityPickerArray = [[NSArray alloc] init];
  priorityIdArray     = [[NSMutableArray alloc] init];
  [self getPriorities];
  
  //Disable editing for 'estimated cost' field, must display default value from selected service
  estimatedCostField.enabled = NO;
  
  //Set delegates for the picker fields
  [assetField setDelegate:self];
  [lifecycleField setDelegate:self];
  [serviceField setDelegate:self];
  [priorityField setDelegate:self];
  
  //Set Date Requested field date
  dateRequested                  = [[NSDate alloc] init];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  NSString *dateRequestedString  = [[NSString alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
  dateRequestedString        = [dateFormatter stringFromDate:dateRequested];
  dateRequestedField.enabled = NO;
  dateRequestedField.text    = dateRequestedString;

  
  //Get logged user userAccountInformation
  userAccountInfoSQLManager = [UserAccountInfoManager alloc];
  userAccountsObject = [UserAccountsObject alloc];
  userAccountsObject = [userAccountInfoSQLManager getUserAccountInfo];
  
  //Get logged user userId for CreateSR operations
  userId = userAccountsObject.userId;
  NSLog(@"Create SR - userId: %@", userId);
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Get user owned assets
-(void) getAssetOwnership
{
  NSMutableString *urlParams = [NSMutableString stringWithFormat:@"http://192.168.2.107/vertex-api/asset/getOwnership/%@", userId];
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:urlParams]];
  
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
    ownedAssetsArray = [[NSArray alloc] initWithObjects:
                          @"Demo - Aircon"
                        , @"Demo - Door"
                        , @"Demo - Exhaust Fan"
                        , @"Demo - Faucet"
                        , @"Demo - Toilet"
                        , @"Demo - Kitchen Sink"
                        , @"Demo - Lighting Fixtures"
                        , nil];
    
    ownedAssetsIdArray = [[NSMutableArray alloc] initWithObjects:
                            @"Demo - 00001"
                          , @"Demo - 00002"
                          , @"Demo - 00004"
                          , @"Demo - 00005"
                          , nil];
  }
  else
  {
    ownedAssets = [NSJSONSerialization
                  JSONObjectWithData:responseData
                             options:kNilOptions
                               error:&error];
    NSLog(@"ownedAssets JSON Result: %@", ownedAssets);
    
    ownedAssetsArray      = [ownedAssets valueForKey:@"name"];
    ownedAssetsIdArray    = [ownedAssets valueForKey:@"id"];
    ownedAssetTypeIdArray = [[ownedAssets valueForKey:@"assetType"] valueForKey:@"id"];
    NSLog(@"ownedAssetsArray: %@", ownedAssetsArray);
  }
}


#pragma mark - Get managed assets - assets belonging to the building
-(void) getManagedAssets
{
  URL = @"http://192.168.2.107/vertex-api/asset/getManagedAssets";
  
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
    managedAssetsArray = [[NSArray alloc] initWithObjects:
                            @"Demo - Elevator"
                          , @"Demo - Pool"
                          , @"Demo - Parking lot"
                          , @"Demo - Lobby"
                          , nil];
    
    managedAssetsIdArray = [[NSMutableArray alloc] initWithObjects:
                              @"Demo - 00001"
                            , @"Demo - 00002"
                            , @"Demo - 00004"
                            , nil];
  }
  else
  {
    managedAssets = [NSJSONSerialization
                     JSONObjectWithData:responseData
                                options:kNilOptions
                                  error:&error];
    NSLog(@"managedAssets JSON Result: %@", managedAssets);
    
    managedAssetsArray      = [managedAssets valueForKey:@"name"];
    managedAssetsIdArray    = [managedAssets valueForKey:@"id"];
    managedAssetTypeIdArray = [[managedAssets valueForKey:@"assetType"] valueForKey:@"id"];
    NSLog(@"managedAssetsArray: %@", managedAssetsArray);
  }
}


#pragma mark - Get the assets belonging to a certain user plus the managed assets of the building
- (void) getUserAssets
{
  [self getAssetOwnership];
  [self getManagedAssets];
  
  assetPickerArray = [[NSMutableArray alloc] init];
  [assetPickerArray addObjectsFromArray:ownedAssetsArray];
  [assetPickerArray addObjectsFromArray:managedAssetsArray];

  assetIdArray = [[NSMutableArray alloc] init];
  [assetIdArray addObjectsFromArray:ownedAssetsIdArray];
  [assetIdArray addObjectsFromArray:managedAssetsIdArray];
  
  assetTypeIdArray = [[NSMutableArray alloc] init];
  [assetTypeIdArray addObjectsFromArray:ownedAssetTypeIdArray];
  [assetTypeIdArray addObjectsFromArray:managedAssetTypeIdArray];
}


#pragma mark - getLifecycle
-(void) getLifecycles
{
  //endpoint for getLifecycles
  NSLog(@"getLifecycles - selectedAssetTypeId: %@", selectedAssetTypeId);
  NSMutableString *urlParams = [NSMutableString stringWithFormat:@"http://192.168.2.107/vertex-api/lifecycle/getAssetTypeLifecycles/%@", selectedAssetTypeId];
  
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
    UIAlertView *lifecycleAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Warning"
                                              message:@"No network connection detected. Displaying data from phone cache."
                                             delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [lifecycleAlert show];
    
    //Connect to CoreData for local data
    //!- FOR TESTING ONLY -!
    lifecyclePickerArray = [[NSArray alloc] initWithObjects:
                              @"Demo - Canvas"
                            , @"Demo - Requisition"
                            , @"Demo - Purchase"
                            , @"Demo - Installation"
                            , @"Demo - Repair"
                            , @"Demo - Decommission"
                            , nil];
    
    lifecycleIdArray = [[NSMutableArray alloc] initWithObjects:
                          @"Demo - 00001"
                        , @"Demo - 00002"
                        , @"Demo - 00004"
                        , @"Demo - 00005"
                        , nil];
  }
  else
  {
    lifecycles = [NSJSONSerialization
                  JSONObjectWithData:responseData
                             options:kNilOptions
                               error:&error];
    NSLog(@"lifecycles JSON Result: %@", lifecycles);
    
    lifecyclePickerArray = [lifecycles valueForKey:@"name"]; //store lifecycles names only in PickerArray
    lifecycleIdArray     = [lifecycles valueForKey:@"id"];
    NSLog(@"lifecyclePickerArray: %@", lifecyclePickerArray);
  }
}


#pragma mark - getServices
-(void) getServices
{
  //endpoint for getServices
  //URL = @"http://192.168.2.113/vertex-api/service/getServices/{assetTypeId}/{lifecycleId}";
  //URL = @"http://192.168.2.107/vertex-api/service/getServices/{assetTypeId}/{lifecycleId}";
  
  NSLog(@"selectedAssetTypeId: %@", selectedAssetTypeId);
  NSLog(@"selectedLifecycleId: %@", selectedLifecycleId);
  
  //Get selected assetTypeId & lifecycleId then construct URL
  NSMutableString *urlParams = [NSMutableString stringWithFormat:@"http://192.168.2.107/vertex-api/service/getServices/%@/%@"
                                , selectedAssetTypeId
                                , selectedLifecycleId];
  
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
    servicePickerArray = [[NSArray alloc] initWithObjects:
                            @"Demo - Fix broken pipe"
                          , @"Demo - Replace wiring"
                          , @"Demo - Repaint unit"
                          , @"Demo - Fix cooling unit"
                          , nil];
    
    servicesIdArray = [[NSMutableArray alloc] initWithObjects:
                         @"Demo - 00001"
                       , @"Demo - 00002"
                       , @"Demo - 00003"
                       , @"Demo - 00004"
                       , nil];
    
    servicesCostArray = [[NSMutableArray alloc] initWithObjects:
                           @"Demo - 100.00"
                         , @"Demo - 200.00"
                         , @"Demo - 300.00"
                         , @"Demo - 400.00"
                         , nil];
  }
  else
  {
    services = [NSJSONSerialization
                  JSONObjectWithData:responseData
                             options:kNilOptions
                               error:&error];
    NSLog(@"services JSON Result: %@", services);
    
    servicePickerArray = [services valueForKey:@"name"]; //store lifecycles names only in PickerArray
    servicesIdArray    = [services valueForKey:@"id"];
    servicesCostArray  = [services valueForKey:@"cost"];
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
    self.priorityPickerArray = [[NSArray alloc] initWithObjects:
                                  @"Demo - High"
                                , @"Demo - Medium"
                                , @"Demo - Low"
                                , nil];
    
    priorityIdArray = [[NSMutableArray alloc] initWithObjects:
                         @"Demo - 00001"
                       , @"Demo - 00002"
                       , @"Demo - 00003"
                       , nil];
  }
  else
  {
    priorities = [NSJSONSerialization
                  JSONObjectWithData:responseData
                             options:kNilOptions
                               error:&error];
    NSLog(@"priorities JSON Result: %@", priorities);
    
    priorityPickerArray = [priorities valueForKey:@"name"]; //store priority names only in PickerArray
    priorityIdArray     = [priorities valueForKey:@"id"];
    NSLog(@"priorityPickerArray: %@", priorityPickerArray);
  }
}


#pragma mark - Generic Picker definitions
-(void) defineGenericPicker
{
  //Generic Picker definition
  srGenericPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
  srGenericPicker.showsSelectionIndicator = YES;
  srGenericPicker.dataSource = self;
  srGenericPicker.delegate   = self;
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
  
  UISegmentedControl *doneButton   = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObject:@"Done"]];
  doneButton.momentary             = YES;
  doneButton.frame                 = CGRectMake(260, 7.0f, 50.0f, 30.0f);
  doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
  doneButton.tintColor             = [UIColor blackColor];
  
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
    
    currentArray         = assetPickerArray;
    currentTextField     = assetField;
    assetField.inputView = actionSheet;
    
    [doneButton addTarget:self
                   action:@selector(getAssetTypeIndex)
         forControlEvents:UIControlEventValueChanged];
    
    return YES;
  }
  else if(lifecycleField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - lifecycleField");
    [textField resignFirstResponder];
    
    //Connect to endpoint with the selected asset type id as parameter
    [self getLifecycles];
    
    currentArray = [[NSArray alloc] initWithObjects: nil];
    [self defineGenericPicker];
    [actionSheet addSubview:srGenericPicker];
    
    currentArray             = lifecyclePickerArray;
    currentTextField         = lifecycleField;
    lifecycleField.inputView = actionSheet;
    
    //[Done] button functionality changes depending on what field/picker is being edited
    [doneButton addTarget:self
                   action:@selector(getLifecycleIndex)
         forControlEvents:UIControlEventValueChanged];
    
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
    
    currentArray           = servicePickerArray;
    currentTextField       = serviceField;
    serviceField.inputView = actionSheet;
    
    [doneButton addTarget:self
                   action:@selector(getServiceIndex)
         forControlEvents:UIControlEventValueChanged];
    
    return YES;
  }
  else if(priorityField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - priorityField");
    [textField resignFirstResponder];
    
    currentArray = [[NSArray alloc] initWithObjects: nil];
    [self defineGenericPicker];
    [actionSheet addSubview:srGenericPicker];
    
    currentArray            = priorityPickerArray;
    currentTextField        = priorityField;
    priorityField.inputView = actionSheet;
    
    [doneButton addTarget:self
                   action:@selector(getPriorityIndex)
         forControlEvents:UIControlEventValueChanged];
    
    return YES;
  }
  else
  {
    return NO;
  }
}


#pragma mark - Get the selected asset type id of the selected asset in Asset Picker
-(void) getAssetTypeIndex
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  int assetTypeIndex  = [srGenericPicker selectedRowInComponent:0];
  selectedAssetId     = [assetIdArray objectAtIndex:assetTypeIndex];
  selectedAssetTypeId = [assetTypeIdArray objectAtIndex:assetTypeIndex]; //selectedIndex
  NSLog(@"selectedAssetTypeId: %@", selectedAssetTypeId);
  
  NSString *selectedEntity = [currentArray objectAtIndex:assetTypeIndex];
  currentTextField.text    = selectedEntity;
}


#pragma mark - Get the id of the selected lifecycle in Lifecycle Picker
-(void) getLifecycleIndex
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  int lifecycleIndex  = [srGenericPicker selectedRowInComponent:0];
  selectedLifecycleId = [lifecycleIdArray objectAtIndex:lifecycleIndex]; //selectedIndex
  NSLog(@"selectedLifecycleId: %@", selectedLifecycleId);
  
  NSString *selectedEntity = [currentArray objectAtIndex:lifecycleIndex];
  currentTextField.text    = selectedEntity;
}


#pragma mark - Get the id of the selected service in Services Picker
-(void) getServiceIndex
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  int serviceIndex   = [srGenericPicker selectedRowInComponent:0];
  selectedServicesId = [servicesIdArray objectAtIndex:serviceIndex]; //selectedIndex
  NSLog(@"selectedServicesId: %@", selectedServicesId);
  
  serviceCost             = [servicesCostArray objectAtIndex:serviceIndex];
  estimatedCostField.text = serviceCost.description;
  NSLog(@"serviceCost: %@", serviceCost);
  
  NSString *selectedEntity = [currentArray objectAtIndex:serviceIndex];
  currentTextField.text    = selectedEntity;
}


#pragma mark - Get the id of the selected priority in Priority Picker
-(void) getPriorityIndex
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  int priorityIndex  = [srGenericPicker selectedRowInComponent:0];
  selectedPriorityId = [priorityIdArray objectAtIndex:priorityIndex]; //selectedIndex
  NSLog(@"selectedPriorityId: %@", selectedPriorityId);
  
  NSString *selectedEntity = [currentArray objectAtIndex:priorityIndex];
  currentTextField.text    = selectedEntity;
}


#pragma mark - Get selected row name in picker field and display it in the text field
-(void)selectedRow
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  selectedIndex = 0;
  selectedIndex = [srGenericPicker selectedRowInComponent:0];
  NSString *selectedEntity = [currentArray objectAtIndex:selectedIndex];
  currentTextField.text    = selectedEntity;
  
  //Show estimated cost based on selected service. Show only, no editing
  estimatedCostField.text = @"";
  estimatedCostField.text = serviceCost.description;
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
  return [currentArray count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [currentArray objectAtIndex:row];
}


#pragma mark - [Cancel] button implementation
-(void) cancelSR
{
  NSLog(@"Cancel Service Request");
  
  cancelSRConfirmation = [[UIAlertView alloc]
                              initWithTitle:@"Cancel Service Request"
                                    message:@"Are you sure you want to cancel this service request?"
                                   delegate:self
                          cancelButtonTitle:@"Yes"
                          otherButtonTitles:@"No", nil];
  
  [cancelSRConfirmation show];  
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
    
    //Construct JSON request body from user inputs in UI
    //TODO: Remove hardcoded userIds
    serviceRequestJson = [[NSMutableDictionary alloc] init];
    
    //asset
    NSMutableDictionary *assetJson = [[NSMutableDictionary alloc] init];
    [assetJson setObject:selectedAssetId forKey:@"id"];
    [serviceRequestJson setObject:assetJson forKey:@"asset"];
    
    //lifecycle
    NSMutableDictionary *lifecycleJson = [[NSMutableDictionary alloc] init];
    [lifecycleJson setObject:selectedLifecycleId forKey:@"id"];
    [serviceRequestJson setObject:lifecycleJson forKey:@"lifecycle"];
    
    //service
    NSMutableDictionary *serviceJson = [[NSMutableDictionary alloc] init];
    [serviceJson setObject:selectedServicesId forKey:@"id"];
    [serviceRequestJson setObject:serviceJson forKey:@"service"];
    
    //priority
    NSMutableDictionary *priorityJson = [[NSMutableDictionary alloc] init];
    [priorityJson setObject:selectedPriorityId forKey:@"id"];
    [serviceRequestJson setObject:priorityJson forKey:@"priority"];
    
    //status
    NSMutableDictionary *statusJson = [[NSMutableDictionary alloc] init];
    [statusJson setObject:@20130101420000001 forKey:@"id"]; //Service Request Creation Status Id - 20130101420000001
    [serviceRequestJson setObject:statusJson forKey:@"status"];
    
    //requestor
    NSMutableDictionary *requestorJson = [[NSMutableDictionary alloc] init];
    [requestorJson setObject:userId forKey:@"id"];
    [serviceRequestJson setObject:requestorJson forKey:@"requestor"];
    
    //admin
    NSMutableDictionary *adminJson = [[NSMutableDictionary alloc] init];
    [adminJson setObject:@20130101500000001 forKey:@"id"]; //TODO - TEST ONLY !!!
    [serviceRequestJson setObject:adminJson forKey:@"admin"];
    
    //cost
    [serviceRequestJson setObject:serviceCost forKey:@"cost"];
    
    //schedules - No schedules yet for Creation status, can be null
    NSMutableDictionary *scheduleDictionary = [[NSMutableDictionary alloc] init];
    /*
    //schedule - status
    NSMutableDictionary *scheduleStatusDictionary = [[NSMutableDictionary alloc] init];
    [scheduleStatusDictionary setObject:@20130101420000001 forKey:@"id"]; //Service Request Creation Status Id - 20130101420000001
    [scheduleDictionary setObject:scheduleStatusDictionary forKey:@"status"];
    
    //schedule - author
    NSMutableDictionary *scheduleAuthor = [[NSMutableDictionary alloc] init];
    [scheduleAuthor setObject:userId forKey:@"id"]; //!!! TODO - TEST ONLY !!!
    [scheduleDictionary setObject:scheduleAuthor forKey:@"author"];
    
    //schedule - periods
    //date formatter
    //!!! TODO
    NSMutableDictionary *schedulePeriodDictionary = [[NSMutableDictionary alloc] init];
    [schedulePeriodDictionary setObject:dateRequested.description forKey:@"fromDate"];
    [schedulePeriodDictionary setObject:@"12:12:12" forKey:@"fromTime"];
    [schedulePeriodDictionary setObject:@"GMT+8" forKey:@"fromTimezone"];
    [schedulePeriodDictionary setObject:@"2013-05-06" forKey:@"toDate"];
    [schedulePeriodDictionary setObject:@"11:11:11" forKey:@"toTime"];
    [schedulePeriodDictionary setObject:@"GMT+8" forKey:@"toTimezone"];
    
    NSMutableArray *schedulePeriodArray = [[NSMutableArray alloc] init];
    [schedulePeriodArray addObject:schedulePeriodDictionary];
    [scheduleDictionary setObject:schedulePeriodArray forKey:@"periods"];
    
    NSNumber *boolActive = [[NSNumber alloc] initWithBool:YES];
    [scheduleDictionary setObject:boolActive forKey:@"active"]; //active:boolean
    //*/
    
    NSMutableArray *scheduleArray = [[NSMutableArray alloc] init];
    [scheduleArray addObject:scheduleDictionary];
    [serviceRequestJson setObject:scheduleArray forKey:@"schedules"];
    
    //notes
    NSMutableDictionary *notesDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *notesSenderJson = [[NSMutableDictionary alloc] init];
    
    [notesSenderJson setObject:userId forKey:@"id"];
    [notesDictionary setObject:notesSenderJson forKey:@"sender"];
    [notesDictionary setObject:notesTextArea.text forKey:@"message"];
    
    NSMutableArray *notesArray = [[NSMutableArray alloc] init];
    [notesArray addObject:notesDictionary];
    [serviceRequestJson setObject:notesArray forKey:@"notes"];
    
    NSLog(@"Create Service Request JSON: %@", serviceRequestJson);
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
    
    //Set URL for Add Service Request
    //URL = @"http://192.168.2.113/vertex-api/service-request/addServiceRequest";
    URL = @"http://192.168.2.107/vertex-api/service-request/addServiceRequest";
    //URL = @"http://blah"; //TEST ONLY
    
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
  httpResponse     = (NSHTTPURLResponse *)response;
  httpResponseCode = [httpResponse statusCode];
  NSLog(@"httpResponse status code: %d", httpResponseCode);
}


#pragma mark - Transition to a page depending on what alert box is shown and what button is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if([alertView isEqual:cancelSRConfirmation])
  {
    NSLog(@"Cancel SR Confirmation");
    if(buttonIndex == 0) //Yes - Cancel
    {
      //Go back to SR Page
      ServiceRequestViewController* controller = (ServiceRequestViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SRPage"];
      
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
  [dateRequestedField resignFirstResponder];
  [priorityField resignFirstResponder];
  [notesTextArea resignFirstResponder];
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



@end
