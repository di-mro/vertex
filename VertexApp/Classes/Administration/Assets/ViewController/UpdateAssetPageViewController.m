//
//  UpdateAssetPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 3/20/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "UpdateAssetPageViewController.h"
#import "HomePageViewController.h"
#import "AssetPageViewController.h"
#import "Reachability.h"

@interface UpdateAssetPageViewController ()

@end

@implementation UpdateAssetPageViewController

@synthesize updateAssetPageScroller;
@synthesize assetTypePickerArray;
@synthesize assetTypePicker;
@synthesize actionSheet;

@synthesize assetNameField;
@synthesize assetTypeField;
@synthesize modelField;
@synthesize brandField;
@synthesize powerConsumptionField;
@synthesize remarksArea;

@synthesize modelLabel;
@synthesize brandLabel;
@synthesize powerConsumptionLabel;
@synthesize remarksLabel;

@synthesize assetTypes;
@synthesize URL;
@synthesize selectedAssetTypeId;
@synthesize httpResponseCode;

@synthesize managedAssetId;
@synthesize assetOwnedId;
@synthesize assetInfo;


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
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAddAsset)];
  
  //[Update] navigation button - Update Asset
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(updateAsset)];
  
  //Configure Scroller size
  self.updateAssetPageScroller.contentSize = CGSizeMake(320, 720);
  
  //Configure Picker array
  self.assetTypePickerArray = [[NSArray alloc] init];
  
  [self getAssetTypes];
  
  //assetTypePicker in assetTypeField
  [assetTypeField setDelegate:self];
  
  NSLog(@"UpdateAssetPageViewController - assetOwnedId: %@", assetOwnedId);
  
  //Connect to WS endpoint to retrieve details for the chosen Asset - Initialize fields
  [self getAssetInfo];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - Call WS endpoint to get details for the selected asset
-(void) getAssetInfo
{
  URL = @"http://192.168.2.13:8080/vertex-api/asset/getAsset/";
  
  //! TEST
  //NSString *assetId = @"20130101010200000";
  NSMutableString *urlParams = [NSMutableString
                                stringWithFormat:@"http://192.168.2.13:8080/vertex-api/asset/getAsset/%@"
                                , assetOwnedId];
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:urlParams]];
  
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"userId=20130101005100000"];
  [getRequest setHTTPMethod:@"GET"];
  NSLog(@"%@", getRequest);
  
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
  
  if (responseData == nil)
  {
    //Show an alert if connection is not available
    UIAlertView *connectionAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Warning"
                                    message:@"No network connection detected. Displaying data from phone cache."
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [connectionAlert show];
    
    //TODO: Retrieve local records from CoreData
  }
  else
  {
    //JSON
    assetInfo = [NSJSONSerialization
                 JSONObjectWithData:responseData
                 options:kNilOptions
                 error:&error];
    NSLog(@"assetInfo JSON: %@", assetInfo);
    
    //Set the field texts using the retrieved values
    assetNameField.text = [assetInfo valueForKey:@"name"];
    assetTypeField.text = [[assetInfo valueForKey:@"assetType"] valueForKey:@"name"];
    
    //For TESTING
    //modelLabel.text = [[assetInfo valueForKey:@"attributes"] valueOfAttribute:@"keyName" forResultAtIndex:0];
    //modelField.text = [[assetInfo valueForKey:@"attributes"] valueOfAttribute:@"value" forResultAtIndex:0];
    modelField.text = @"Lorem Ipsum";
    brandField.text = @"Lorem Ipsum";
    powerConsumptionField.text = @"Lorem Ipsum";
    remarksArea.text = @"Lorem Ipsum";
    
  }
}


#pragma mark - Get AssetTypes
- (void) getAssetTypes
{
  //Set URL for retrieving AssetTypes
  URL = @"http://192.168.2.13:8080/vertex-api/asset/getAssetTypes";
  
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
    self.assetTypePickerArray = [[NSArray alloc] initWithObjects:@"Demo - Aircon",@"Demo - Door", @"Demo - Exhaust Fan", @"Demo - Faucet", @"Demo - Toilet", @"Demo - Kitchen Sink", @"Demo - Lighting Fixtures", nil];
  }
  else
  {
    assetTypes = [NSJSONSerialization
                  JSONObjectWithData:responseData
                  options:kNilOptions
                  error:&error];
    NSLog(@"getAssetTypes JSON Result: %@", assetTypes);
    
    assetTypePickerArray = [assetTypes valueForKey:@"name"]; //store assetType names only in PickerArray
    NSLog(@"assetTypePickerArray: %@", assetTypePickerArray);
  }
}


#pragma mark - Change assetTypeField to assetTypePicker when clicked
- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
  if(assetTypeField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - function call");
    [textField resignFirstResponder];
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    assetTypePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
    assetTypePicker.showsSelectionIndicator = YES;
    assetTypePicker.dataSource = self;
    assetTypePicker.delegate = self;
    
    [actionSheet addSubview:assetTypePicker];
    
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObject:@"Done"]];
    doneButton.momentary = YES;
    doneButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blackColor];
    [doneButton addTarget:self action:@selector(selectedRow) forControlEvents:UIControlEventValueChanged];
    
    [actionSheet addSubview:doneButton];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    assetTypeField.inputView = actionSheet;
    
    return YES;
  }
  else if(remarksArea.isEditable)
  {
    remarksArea.text = @"";
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
  return [assetTypePickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [self.assetTypePickerArray objectAtIndex:row];
}


#pragma mark - Get the selected row in assetTypePicker
-(void)selectedRow
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  int selectedIndex = [assetTypePicker selectedRowInComponent:0];
  NSString *assetTypeName = [assetTypePickerArray objectAtIndex:selectedIndex];
  assetTypeField.text = assetTypeName;
  
  NSMutableArray *assetTypeIdArray = [[NSMutableArray alloc] init];
  assetTypeIdArray = [assetTypes valueForKey:@"id"];
  selectedAssetTypeId = [assetTypeIdArray objectAtIndex:selectedIndex];
  //selectedAssetTypeId = @111000; //TEST only
}

#pragma mark - End editing for the fields, dismiss onscreen keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.view endEditing:YES];
}


#pragma mark - [Cancel] button implementation
-(void) cancelAddAsset
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Add Asset");
  
  //Go back to Home Page
  HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - [Update] button implementation
-(void) updateAsset
{
  if([self validateAddAssetFields])
  {
    //Constructing JSON Request Object - POST
    /*
     "{
     id: long
     name: string
     assetType :
     {
     id: long
     }
     assetAttributes :
     [           {
     keyName: string,
     value : string
     }, ...
     ]
     }"
     */
    //Asset
    NSMutableDictionary *mainDictionary = [[NSMutableDictionary alloc] init];
    [mainDictionary setObject:assetNameField.text forKey:@"name"];
    
    //AssetType Object
    NSMutableDictionary *assetTypeDict = [[NSMutableDictionary alloc] init];
    [assetTypeDict setObject:selectedAssetTypeId forKey:@"id"];
    NSLog(@"selectedAssetTypeId: %@", selectedAssetTypeId);
    
    //AssetAttributes Array of Objects - Store key and name in array first before consolidating in a dictionary
    //Use Core Data Model Objects
    NSMutableArray *assetAttribKeyArray = [[NSMutableArray alloc] initWithObjects:@"Model", @"Brand", @"Power Consumption", @"Remark", nil];
    NSMutableArray *assetAttribValueArray = [[NSMutableArray alloc] initWithObjects:modelField.text, brandField.text, powerConsumptionField.text, remarksArea.text , nil];
    
    NSMutableDictionary *assetAttributesDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *innerAssetAttribArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [assetAttribKeyArray count]; i++) //attribute number
    {
      [assetAttributesDict setObject:[assetAttribKeyArray objectAtIndex:i] forKey:@"keyName"];
      [assetAttributesDict setObject:[assetAttribValueArray objectAtIndex:i] forKey:@"value"];
      
      [innerAssetAttribArray insertObject:assetAttributesDict atIndex:i];
      assetAttributesDict = [[NSMutableDictionary alloc] init];
    }
    
    [mainDictionary setObject:assetTypeDict forKey:@"assetType"];
    [mainDictionary setObject:innerAssetAttribArray forKey:@"attributes"];
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:mainDictionary
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                            encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonData Request: %@", jsonData);
    NSLog(@"jsonString Request: %@", jsonString);
    
    //Set URL for Update Asset
    URL = @"http://192.168.2.13:8080/vertex-api/asset/updateAsset";
    NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:URL]];
    
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"userId=20130101005100000"];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[jsonString UTF8String]
                                            length:[jsonString length]]];
    NSLog(@"%@", postRequest);
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:postRequest
                                   delegate:self];
    
    [connection start];
    
    //POST
    if(httpResponseCode >= 400)
    {
      UIAlertView *updateAssetFailAlert = [[UIAlertView alloc]
                                           initWithTitle:@"Update Asset Failed"
                                           message:@"Asset not updated. Please try again later"
                                           delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
      [updateAssetFailAlert show];
      
    }
    else
    {
      UIAlertView *updateAssetAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Update Asset"
                                       message:@"Asset Updated."
                                       delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
      [updateAssetAlert show];
      //Transition to Assets Page - alertView clickedButtonAtIndex
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Create Asset");
  }
  else
  {
    NSLog(@"Unable to update Asset");
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
  if (buttonIndex == 0)
  {
    AssetPageViewController* controller = (AssetPageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AssetsPage"];
    
    [self.navigationController pushViewController:controller animated:YES];
  }
}


#pragma mark - Login fields validation
-(BOOL) validateAddAssetFields
{
  UIAlertView *addAssetValidateAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Incomplete Information"
                                        message:@"Please fill out the necessary fields."
                                        delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  
  if([assetNameField.text isEqualToString:(@"")]
     || [assetTypeField.text isEqualToString:(@"")]
     || [modelField.text isEqualToString:(@"")]
     || [brandField.text isEqualToString:(@"")])
  {
    [addAssetValidateAlert show];
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
  [assetNameField resignFirstResponder];
  [assetTypeField resignFirstResponder];
  [modelField resignFirstResponder];
  [brandField resignFirstResponder];
  [powerConsumptionField resignFirstResponder];
  [remarksArea resignFirstResponder];
}


#pragma mark - Check for network availability
-(BOOL)reachable
{
  Reachability *r = [Reachability  reachabilityWithHostName:URL];
  NetworkStatus internetStatus = [r currentReachabilityStatus];
  
  if(internetStatus == NotReachable)
  {
    return NO;
  }
  
  return YES;
}


@end
