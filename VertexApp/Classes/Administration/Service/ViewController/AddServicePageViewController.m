//
//  AddServicePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/2/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AddServicePageViewController.h"
#import "HomePageViewController.h"
#import "ServiceConfigurationPageViewController.h"

@interface AddServicePageViewController ()

@end

@implementation AddServicePageViewController

@synthesize addServiceScroller;

@synthesize assetTypeLabel;
@synthesize assetTypeField;
@synthesize lifecycleLabel;
@synthesize lifecycleField;
@synthesize serviceLabel;
@synthesize serviceField;
@synthesize serviceCostLabel;
@synthesize serviceCostField;

@synthesize assetPickerArray;
@synthesize assetTypeIdArray;
@synthesize lifecyclePickerArray;
@synthesize lifecycleIdArray;

@synthesize assetTypes;
@synthesize lifecycles;

@synthesize srGenericPicker;
@synthesize currentArray;
@synthesize currentTextField;
@synthesize actionSheet;

@synthesize selectedIndex;
@synthesize selectedAssetTypeId;
@synthesize selectedLifecycleId;

@synthesize URL;
@synthesize httpResponseCode;


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
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //Configure Scroller size
  self.addServiceScroller.contentSize = CGSizeMake(320, 720);
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelAddService)];
  
  //[Add] navigation button - Add Lifecycle
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(addService)];
  
  //For populating the values in the Picker fields
  [self getAssetType];
  [self getLifecycles];
  
  //Set delegates for the Picker fields
  [assetTypeField setDelegate:self];
  [lifecycleField setDelegate:self];
  
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
    assetPickerArray = [[NSMutableArray alloc] initWithObjects:
                          @"Demo - Aircon"
                        , @"Demo - Door"
                        , @"Demo - Exhaust Fan"
                        , @"Demo - Faucet"
                        , @"Demo - Toilet"
                        , @"Demo - Kitchen Sink"
                        , @"Demo - Lighting Fixtures"
                        , nil];
    
    assetTypeIdArray = [[NSMutableArray alloc] initWithObjects:
                          @"Demo - 00001"
                        , @"Demo - 00002"
                        , @"Demo - 00004"
                        , @"Demo - 00005"
                        , nil];
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
    lifecyclePickerArray = [[NSMutableArray alloc] initWithObjects:
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
  
  if(assetTypeField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - assetTypeField");
    [textField resignFirstResponder];
    
    currentArray = [[NSArray alloc] initWithObjects: nil];
    [self defineGenericPicker];
    [actionSheet addSubview:srGenericPicker];
    
    currentArray             = assetPickerArray;
    currentTextField         = assetTypeField;
    assetTypeField.inputView = actionSheet;
    
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
    
    currentArray             = lifecyclePickerArray;
    currentTextField         = lifecycleField;
    lifecycleField.inputView = actionSheet;
    
    [doneButton addTarget:self action:@selector(getLifecycleIndex) forControlEvents:UIControlEventValueChanged];
    return YES;
  }
  else
  {
    return NO;
  }
}


#pragma mark - Get selected index in Asset Type picker
-(void) getAssetTypeIndex
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  int assetTypeIndex  = [srGenericPicker selectedRowInComponent:0];
  selectedAssetTypeId = [assetTypeIdArray objectAtIndex:assetTypeIndex]; //selectedIndex
  
  NSString *selectedEntity = [currentArray objectAtIndex:assetTypeIndex];
  currentTextField.text    = selectedEntity;
}


#pragma mark - Get selected index in Lifecycle Picker
-(void) getLifecycleIndex
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  int lifecycleIndex  = [srGenericPicker selectedRowInComponent:0];
  selectedLifecycleId = [lifecycleIdArray objectAtIndex:lifecycleIndex]; //selectedIndex
  
  NSString *selectedEntity = [currentArray objectAtIndex:lifecycleIndex];
  currentTextField.text    = selectedEntity;
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
-(void) cancelAddService
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Add Service");
  
  //Go back to Home Page
  HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Add Service
-(void) addService
{
  if([self validateAddServiceFields])
  {
    //Set JSON Request
    /*
     "{
        "assetTypeId" : long,
        "lifecycleId" : long,
        "services" :
        [
          {
            "name" : string,
            "cost" : number
          },
          {
            ..
          }
        ]
     }"
     */
    NSMutableDictionary *addServiceJson = [[NSMutableDictionary alloc] init];
    [addServiceJson setObject:selectedAssetTypeId forKey:@"assetTypeId"];
    [addServiceJson setObject:selectedLifecycleId forKey:@"lifecycleId"];
    
    NSMutableDictionary *servicesDictionary = [[NSMutableDictionary alloc] init];
    [servicesDictionary setObject:serviceField.text forKey:@"name"];
    [servicesDictionary setObject:serviceCostField.text forKey:@"cost"];
    
    NSMutableArray *servicesArray = [[NSMutableArray alloc] init];
    [servicesArray addObject:servicesDictionary];
    [addServiceJson setObject:servicesArray forKey:@"services"];
    
    NSLog(@"addService JSON: %@", addServiceJson);
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:addServiceJson
                                   options:NSJSONWritingPrettyPrinted
                                     error:&error];
    
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                                encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonData Request: %@", jsonData);
    NSLog(@"jsonString Request: %@", jsonString);
    
    //Set URL for Add Service
    //URL = @"http://192.168.2.113/vertex-api/service/addServices";
    URL = @"http://192.168.2.107/vertex-api/service/addServices";
    
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
    
    NSLog(@"addService - httpResponseCode: %d", httpResponseCode);
    if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
    {
      UIAlertView *addServiceAlert = [[UIAlertView alloc]
                                          initWithTitle:@"Add Service"
                                                message:@"Service Added."
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
      [addServiceAlert show];
    }
    else //(httpResponseCode >= 400)
    {
      UIAlertView *addServiceAlert = [[UIAlertView alloc]
                                          initWithTitle:@"Add Service Failed"
                                                message:@"Service not added. Please try again later"
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
      [addServiceAlert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Add Service");
  }
  else
  {
    NSLog(@"Unable to add service");
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


#pragma mark - Transition to Assets Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0)
  {
    HomePageViewController *controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    /*
    ServiceConfigurationPageViewController *controller = (ServiceConfigurationPageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ServiceConfigPage"];
    
    [self.navigationController pushViewController:controller animated:YES];
     */
  }
}


#pragma mark - Login fields validation
-(BOOL) validateAddServiceFields
{
  UIAlertView *addServiceValidateAlert = [[UIAlertView alloc]
                                               initWithTitle:@"Incomplete Information"
                                                     message:@"Please fill out the necessary fields."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
  
  if([assetTypeField.text isEqualToString:(@"")]
     || [lifecycleField.text isEqualToString:(@"")]
     || [serviceField.text isEqualToString:(@"")]
     || [serviceCostField.text isEqualToString:(@"")])
  {
    [addServiceValidateAlert show];
    return false;
  }
  else
  {
    return true;
  }
}


#pragma mark - Dismiss assetTypePicker action sheet
-(void)dismissActionSheet:(id) sender
{
  [sender dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark - Dismiss onscreen keyboard
-(void)dismissKeyboard
{
  [assetTypeField resignFirstResponder];
  [lifecycleField resignFirstResponder];
  [serviceField resignFirstResponder];
  [serviceCostField resignFirstResponder];
}

@end
