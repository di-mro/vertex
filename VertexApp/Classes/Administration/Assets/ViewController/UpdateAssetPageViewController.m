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

/*
@synthesize modelField;
@synthesize brandField;
@synthesize powerConsumptionField;
@synthesize remarksArea;

@synthesize modelLabel;
@synthesize brandLabel;
@synthesize powerConsumptionLabel;
@synthesize remarksLabel;
*/
@synthesize assetTypeAttributes;
@synthesize selectedIndex;
@synthesize attribTextFields;

@synthesize assetTypes;
@synthesize URL;
@synthesize selectedAssetTypeId;
@synthesize httpResponseCode;

@synthesize managedAssetId;
@synthesize selectedAssetId;
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
  NSLog(@"Update Asset Page");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAddAsset)];
  
  //[Update] navigation button - Update Asset
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(updateAsset)];
  
  //Configure Scroller size
  self.updateAssetPageScroller.contentSize = CGSizeMake(320, 720);
  [self.view addSubview:updateAssetPageScroller];
  
  //Configure Picker array
  self.assetTypePickerArray = [[NSArray alloc] init];
  
  NSLog(@"01: selectedAssetId: %@", selectedAssetId);
  
  //Connect to WS endpoint to retrieve details for the chosen Asset - Initialize fields
  [self getAssetInfo];
  
  //Initialize values for Asset Types
  [self getAssetTypes];
  
  //assetTypePicker in assetTypeField
  [assetTypeField setDelegate:self];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - Set Asset ID to the selected assetID from previous page
- (void) setIds:(NSNumber *) assetId : (NSNumber *)assetTypeId
{
  selectedAssetId = assetId;
  selectedAssetTypeId = assetTypeId;
  NSLog(@"UpdateAssetPageViewController - assetOwnedId: %@", selectedAssetId);
}


#pragma mark - Call WS endpoint to get details for the selected asset
-(void) getAssetInfo
{
  URL = @"http://192.168.2.13:8080/vertex-api/asset/getAsset/";
  
  //! TEST
  NSMutableString *urlParams = [NSMutableString
                                stringWithFormat:@"http://192.168.2.13:8080/vertex-api/asset/getAsset/%@"
                                , selectedAssetId];
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:urlParams]];
  
  //GET - Read
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"userId=20130101005100000"]; //Update userId
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
    //assetId
    assetNameField.text = [assetInfo valueForKey:@"name"];
    assetTypeField.text = [[assetInfo valueForKey:@"assetType"] valueForKey:@"name"];
  
    //Setting the asset type fields and values of the particular asset to be edited
    selectedAssetTypeId = [[assetInfo valueForKey:@"assetType"] valueForKey:@"id"];
    NSLog(@"selectedAssetTypeId: %@", selectedAssetTypeId);
    NSMutableDictionary *assetAttribs = [[NSMutableDictionary alloc] init];
    
    if(selectedAssetTypeId == nil)
    {
      NSLog(@"Nil assetTypeId");
    }
    else
    {
      assetAttribs = [assetInfo valueForKey:@"attributes"]; //dictionary keyName-value
      NSLog(@"initial-assetAttrib: %@", assetAttribs);
      
      int textfieldHeight;
      int textfieldWidth;
      //NSString *textFieldLabel = [[NSString alloc] initWithString:[[assetTypeAttributes objectAtIndex:i] description]];
      NSMutableArray *attribKeys = [[NSMutableArray alloc] init];
      NSMutableArray *attribValues = [[NSMutableArray alloc] init];
      
      attribKeys = [assetAttribs valueForKey:@"keyName"];
      attribValues = [assetAttribs valueForKey:@"value"];
      
      //for(NSString *key in [assetAttribs allKeys])
      for(int i = 0; i < [assetAttribs count]; i++)
      {
        UITextField *attribField = [[UITextField alloc] init];
        textfieldHeight = 30;
        textfieldWidth = 280;
        
        NSLog(@"initial-attribKeys atIndex: %@", [attribKeys objectAtIndex:i]);
        NSLog(@"initial-attribValues atIndex: %@", [attribValues objectAtIndex:i]);
        
        attribField = [[UITextField alloc] initWithFrame:CGRectMake(0, (i * textfieldHeight + 10), textfieldWidth, textfieldHeight)];
        attribField.borderStyle = UITextBorderStyleRoundedRect;
        attribField.placeholder = [attribKeys objectAtIndex:i];
        attribField.text = [attribValues objectAtIndex:i];
        attribField.tag = i;
        
        CGRect textFieldFrame = attribField.frame;
        textFieldFrame.origin.x = 20;
        textFieldFrame.origin.y += (170 + (15 * i));
        attribField.frame = textFieldFrame;
        
        [updateAssetPageScroller addSubview:attribField];
        
        //Store attribute field-label in array
        [attribTextFields setObject:attribField forKey:[attribKeys objectAtIndex:i]];
        NSLog(@"initial-attribTextFields: %@", attribTextFields);
        
        attribField = [[UITextField alloc] init];
      }
      
    }
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
    //NSLog(@"assetTypePickerArray: %@", assetTypePickerArray);
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
  
  selectedIndex = [assetTypePicker selectedRowInComponent:0];
  NSString *assetTypeName = [assetTypePickerArray objectAtIndex:selectedIndex];
  assetTypeField.text = assetTypeName;
  
  NSMutableArray *assetTypeIdArray = [[NSMutableArray alloc] init];
  assetTypeIdArray = [assetTypes valueForKey:@"id"];
  selectedAssetTypeId = [assetTypeIdArray objectAtIndex:selectedIndex];
  //selectedAssetTypeId = @111000; //TEST only
  
  [self setAttributesField];
}

#pragma mark - End editing for the fields, dismiss onscreen keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.view endEditing:YES];
}


#pragma mark - Dynamically set the text fields for Asset Attributes based on Asset Type
-(void) setAttributesField
{
   //TODO: retrieveAssetType
   NSMutableArray *allAssetAttrib = [[NSMutableArray alloc] init];
   attribTextFields = [[NSMutableDictionary alloc] init];
   
   if(selectedAssetTypeId == nil)
   {
     NSLog(@"Nil assetTypeId");
   }
   else
   {
     allAssetAttrib = [assetTypes valueForKey:@"attributes"];
     NSLog(@"allAssetAttrib: %@", allAssetAttrib);
   
     assetTypeAttributes = [allAssetAttrib objectAtIndex:selectedIndex]; //array
     NSLog(@"assetTypeAttributes: %@", assetTypeAttributes);
     
     int textfieldHeight;
     int textfieldWidth;
   
     for(int i = 0; i < [assetTypeAttributes count]; i++)
     {
       NSLog(@"attribute atIndex: %@", [[assetTypeAttributes objectAtIndex:i] description]);
   
       NSString *textFieldLabel = [[NSString alloc] initWithString:[[assetTypeAttributes objectAtIndex:i] description]];
       UITextField *attribField = [[UITextField alloc] init];
       textfieldHeight = 30;
       textfieldWidth = 280;
   
       attribField = [[UITextField alloc] initWithFrame:CGRectMake(0, (i * textfieldHeight + 10), textfieldWidth, textfieldHeight)];
   
       attribField.borderStyle = UITextBorderStyleRoundedRect;
       attribField.placeholder = textFieldLabel;
       attribField.tag = i;
   
       CGRect textFieldFrame = attribField.frame;
       textFieldFrame.origin.x = 20;
       textFieldFrame.origin.y += (170 + (15 * i));
       attribField.frame = textFieldFrame;
   
       [updateAssetPageScroller addSubview:attribField];
   
       //Store attribute field-label in array
       [attribTextFields setObject:attribField forKey:textFieldLabel];
       NSLog(@"attribTextFields: %@", attribTextFields);
   
       attribField = [[UITextField alloc] init];
     }
   }
}


#pragma mark - [Cancel] button implementation
-(void) cancelAddAsset
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Update Asset");
  
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
    [mainDictionary setObject:selectedAssetId forKey:@"id"];
    NSLog(@"updateAsset: %@", selectedAssetId);
    
    //AssetType Object
    NSMutableDictionary *assetTypeDict = [[NSMutableDictionary alloc] init];
    [assetTypeDict setObject:selectedAssetTypeId forKey:@"id"];
    NSLog(@"selectedAssetTypeId: %@", selectedAssetTypeId);
    
    //AssetAttributes Array of Objects - Store key and name in array first before consolidating in a dictionary
    //Use Core Data Model Objects
    //Getting and setting Asset Attributes
    NSMutableArray *assetAttribKeyArray = [[NSMutableArray alloc] init];
    NSMutableArray *assetAttribValueArray = [[NSMutableArray alloc] init];
    UITextField *fieldContent = [[UITextField alloc] init];
    
    for(NSString *key in [attribTextFields allKeys])
    {
      [assetAttribKeyArray addObject:key];
      NSLog(@"assetAttribKeyArray: %@", assetAttribKeyArray);
      
      fieldContent = [attribTextFields valueForKey:key];
      [assetAttribValueArray addObject:fieldContent.text];
      fieldContent = [[UITextField alloc] init];
      NSLog(@"assetAttribValueArray: %@", assetAttribValueArray);
    }
    
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
    NSMutableURLRequest *putRequest = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:URL]];
    
    //PUT method - Update
    [putRequest setValue:@"application/json" forHTTPHeaderField:@"userId=20130101005100000"];
    [putRequest setHTTPMethod:@"PUT"];
    [putRequest setHTTPBody:[NSData dataWithBytes:[jsonString UTF8String]
                                            length:[jsonString length]]];
    NSLog(@"%@", putRequest);
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:putRequest
                                   delegate:self];
    
    [connection start];
    
    //POST
    if(httpResponseCode == 200) //ok
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
    else //(httpResponseCode >= 400)
    {
      UIAlertView *updateAssetFailAlert = [[UIAlertView alloc]
                                           initWithTitle:@"Update Asset Failed"
                                           message:@"Asset not updated. Please try again later"
                                           delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
      [updateAssetFailAlert show];
      
    }
        
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Update Asset");
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
  UIAlertView *updateAssetValidateAlert = [[UIAlertView alloc]
                                           initWithTitle:@"Incomplete Information"
                                           message:@"Please fill out the necessary fields."
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
  
  if([assetNameField.text isEqualToString:(@"")] || [assetTypeField.text isEqualToString:(@"")])
  {
    [updateAssetValidateAlert show];
    return false;
  }
  else
  {
    return true;
  }
  
  for(NSString *key in [attribTextFields allKeys])
  {
    if([[attribTextFields objectForKey:key] isEqualToString:@""])
    {
      [updateAssetValidateAlert show];
      return false;
    }
    else
    {
      return true;
      
    }
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
  
  //Iterate over the asset attribute fields and resignFirstResponder each
  for(NSString *key in [attribTextFields allKeys])
  {
    [[attribTextFields objectForKey:key] resignFirstResponder];
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
  }
  
  return YES;
}


@end
