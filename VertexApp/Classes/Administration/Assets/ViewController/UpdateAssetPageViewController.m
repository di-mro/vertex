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

@synthesize assetTypeAttributes;
@synthesize selectedIndex;
@synthesize attribTextFields;

@synthesize assetTypes;
@synthesize selectedAssetTypeId;

@synthesize httpResponseCode;
@synthesize URL;

@synthesize attribUnits;

@synthesize assetTypeUnitsJson;
@synthesize assetTypeUnits;

@synthesize managedAssetId;
@synthesize selectedAssetId;
@synthesize assetInfo;

@synthesize cancelUpdateAssetConfirmation;


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
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelUpdateAsset)];
  
  //[Update] navigation button - Update Asset
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(updateAsset)];
  
  //Configure Scroller size
  self.updateAssetPageScroller.contentSize = CGSizeMake(320, 720);
  [self.view addSubview:updateAssetPageScroller];
  
  //Configure Picker array
  self.assetTypePickerArray = [[NSArray alloc] init];
  
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
  selectedAssetId     = assetId;
  selectedAssetTypeId = assetTypeId;
  NSLog(@"UpdateAssetPageViewController - assetOwnedId: %@", selectedAssetId);
}


#pragma mark - Call WS endpoint to get details for the selected asset
-(void) getAssetInfo
{
  //URL = @"http://192.168.2.113/vertex-api/asset/getAsset/";
  URL = @"http://192.168.2.107/vertex-api/asset/getAsset/";
  
  //! TEST
  NSMutableString *urlParams = [NSMutableString
                                stringWithFormat:@"http://192.168.2.107/vertex-api/asset/getAsset/%@"
                                , selectedAssetId];
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:urlParams]];
  
  //GET - Read
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"userId=20130101005100000"]; //TODO Update userId
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
    
    NSMutableDictionary *assetAttribs = [[NSMutableDictionary alloc] init];
    
    if(selectedAssetTypeId == nil)
    {
      NSLog(@"Nil assetTypeId");
    }
    else
    {
      //Retrieved JSON - asset info for the chosen asset for update
      assetAttribs = [assetInfo valueForKey:@"attributes"]; //dictionary keyName-value
      
      int attribTextfieldHeight = 30;
      int attribTextfieldWidth  = 240;
      int unitTextfieldHeight   = 30;
      int yOrigin               = 0;
      
      NSMutableArray *attribKeys   = [[NSMutableArray alloc] init];
      NSMutableArray *attribValues = [[NSMutableArray alloc] init];
      
      attribKeys   = [assetAttribs valueForKey:@"keyName"];
      attribValues = [assetAttribs valueForKey:@"value"];
      
      //for(NSString *key in [assetAttribs allKeys])
      for(int i = 0; i < [assetAttribs count]; i++)
      {
        UITextField *attribField         = [[UITextField alloc] init];
        NSMutableArray *unitsPerAttrib   = [[NSMutableArray alloc] init];
        NSMutableArray *unitIdsPerAttrib = [[NSMutableArray alloc] init];
        
        attribField = [[UITextField alloc] initWithFrame:CGRectMake(0, (i * attribTextfieldHeight + 10), attribTextfieldWidth, attribTextfieldHeight)];
        attribField.borderStyle = UITextBorderStyleRoundedRect;
        attribField.placeholder = [attribKeys objectAtIndex:i];
        attribField.text        = [attribValues objectAtIndex:i];
        
        CGRect attribTextFieldFrame   = attribField.frame;
        attribTextFieldFrame.origin.x = 20;
        attribTextFieldFrame.origin.y += (yOrigin += 15);
        attribField.frame             = attribTextFieldFrame;
        
        //Get asset attribute units of measurement
        [self setAttributeUnits];
        //assetTypeUnits
        
        [unitsPerAttrib addObject:[[assetTypeUnits valueForKey:@"name"] objectAtIndex:i]];
        
        //Initialize choices for the units segmented control per asset attribute
        NSArray *unitChoices = [NSArray arrayWithArray:unitsPerAttrib];
        UISegmentedControl *unitsSegmentedControl = [[UISegmentedControl alloc] initWithItems:unitChoices];
        CGRect attribUnitTextFieldFrame;
        
        //Set segmented control frame length and position
        if([unitChoices count] > 1)
        {
          attribUnitTextFieldFrame = CGRectMake(0, (i * unitTextfieldHeight + 10), 380, 30);
        }
        else
        {
          attribUnitTextFieldFrame = CGRectMake(0, (i * unitTextfieldHeight + 10), 120, 30);
        }
        
        attribUnitTextFieldFrame.origin.x = 20;
        attribUnitTextFieldFrame.origin.y += (yOrigin += 40);
        unitsSegmentedControl.frame       = attribUnitTextFieldFrame;
        
        //Method when button is selected TODO !!!
        unitsSegmentedControl.selectedSegmentIndex = 0;
        [unitsSegmentedControl addTarget:self
                                  action:nil//@selector(saveAttribUnit:)
                        forControlEvents:UIControlEventValueChanged];
        
        [updateAssetPageScroller addSubview:attribField];
        [updateAssetPageScroller addSubview:unitsSegmentedControl];
        
        //Store attribute field-label in array
        [attribTextFields setObject:attribField forKey:[attribKeys objectAtIndex:i]];
        
        //Store units
        [attribUnits setObject:[unitsSegmentedControl titleForSegmentAtIndex:unitsSegmentedControl.selectedSegmentIndex] forKey:[unitIdsPerAttrib objectAtIndex:(unitsSegmentedControl.selectedSegmentIndex)]];
        
        attribField = [[UITextField alloc] init];
      }
    }
  }
}


#pragma mark - Get specific asset type of the selected asset and set attributes unit of measurement fields
-(void) setAttributeUnits
{
  //Set URL for retrieving asset type and associated asset attribute - unit of measurement
  //URL = @"http://192.168.2.113/vertex-api/asset/getAssetType/";
  URL = @"http://192.168.2.107/vertex-api/asset/getAssetType/";
  
  //Pass assetType id as parameter
  NSMutableString *urlParams = [NSMutableString
                                stringWithFormat:@"http://192.168.2.107/vertex-api/asset/getAssetType/%@"
                                , [[assetInfo valueForKey:@"assetType"] valueForKey:@"id" ]];
  
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
    
  }
  else
  {
    assetTypeUnitsJson = [NSJSONSerialization
                          JSONObjectWithData:responseData
                                     options:kNilOptions
                                       error:&error];
    
    NSLog(@"assetTypeUnits JSON Result: %@", assetTypeUnits);
    
    [[assetTypeUnits valueForKey:@"attributes"] valueForKey:@"units"];
  }
}


#pragma mark - Get AssetTypes for Asset Type picker
- (void) getAssetTypes
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
    self.assetTypePickerArray = [[NSArray alloc] initWithObjects:
                                   @"Demo - Aircon",@"Demo - Door"
                                 , @"Demo - Exhaust Fan"
                                 , @"Demo - Faucet"
                                 , @"Demo - Toilet"
                                 , @"Demo - Kitchen Sink"
                                 , @"Demo - Lighting Fixtures"
                                 , nil];
  }
  else
  {
    assetTypes = [NSJSONSerialization
                  JSONObjectWithData:responseData
                             options:kNilOptions
                               error:&error];
    
    NSLog(@"getAssetTypes JSON Result: %@", assetTypes);
    
    assetTypePickerArray = [assetTypes valueForKey:@"name"]; //store assetType names only in PickerArray
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
    assetTypePicker.delegate   = self;
    
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
  assetTypeField.text     = assetTypeName;
  
  NSMutableArray *assetTypeIdArray = [[NSMutableArray alloc] init];
  assetTypeIdArray    = [assetTypes valueForKey:@"id"];
  selectedAssetTypeId = [assetTypeIdArray objectAtIndex:selectedIndex];
  
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
  NSMutableDictionary *assetAttribs = [[NSMutableDictionary alloc] init];
  attribTextFields = [[NSMutableDictionary alloc] init];
  
  if(selectedAssetTypeId == nil)
  {
    NSLog(@"Nil assetTypeId");
  }
  else
  {
    //Retrieved JSON - asset info for the chosen asset for update
    assetAttribs = [assetInfo valueForKey:@"attributes"]; //dictionary keyName-value
    NSLog(@"initial-assetAttrib: %@", assetAttribs);
  
    int attribTextfieldHeight = 30;
    int attribTextfieldWidth  = 240;
    int unitTextfieldHeight   = 30;
    int yOrigin               = 0;
    
    NSMutableArray *attribKeys   = [[NSMutableArray alloc] init];
    NSMutableArray *attribValues = [[NSMutableArray alloc] init];
    
    attribKeys   = [assetAttribs valueForKey:@"keyName"];
    attribValues = [assetAttribs valueForKey:@"value"];
    
    //for(NSString *key in [assetAttribs allKeys])
    for(int i = 0; i < [assetAttribs count]; i++)
    {
      UITextField *attribField         = [[UITextField alloc] init];
      NSMutableArray *unitsPerAttrib   = [[NSMutableArray alloc] init];
      NSMutableArray *unitIdsPerAttrib = [[NSMutableArray alloc] init];
      
      
      attribField = [[UITextField alloc] initWithFrame:CGRectMake(0, (i * attribTextfieldHeight + 10), attribTextfieldWidth, attribTextfieldHeight)];
      attribField.borderStyle = UITextBorderStyleRoundedRect;
      attribField.placeholder = [attribKeys objectAtIndex:i];
      attribField.text = [attribValues objectAtIndex:i];
      
      CGRect attribTextFieldFrame   = attribField.frame;
      attribTextFieldFrame.origin.x = 20;
      attribTextFieldFrame.origin.y += (yOrigin += 15);
      attribField.frame             = attribTextFieldFrame;
      
      //Get asset attribute units of measurement
      [self setAttributeUnits];
      //assetTypeUnits
      
      [unitsPerAttrib addObject:[[assetTypeUnits valueForKey:@"name"] objectAtIndex:i]];
      
      //Initialize choices for the units segmented control per asset attribute
      NSArray *unitChoices = [NSArray arrayWithArray:unitsPerAttrib];
      UISegmentedControl *unitsSegmentedControl = [[UISegmentedControl alloc] initWithItems:unitChoices];
      CGRect attribUnitTextFieldFrame;
      
      //Set segmented control frame length and position
      if([unitChoices count] > 1)
      {
        attribUnitTextFieldFrame = CGRectMake(0, (i * unitTextfieldHeight + 10), 380, 30);
      }
      else
      {
        attribUnitTextFieldFrame = CGRectMake(0, (i * unitTextfieldHeight + 10), 120, 30);
      }
      
      attribUnitTextFieldFrame.origin.x = 20;
      attribUnitTextFieldFrame.origin.y += (yOrigin += 40);
      unitsSegmentedControl.frame       = attribUnitTextFieldFrame;
      
      //Method when button is selected TODO !!!
      unitsSegmentedControl.selectedSegmentIndex = 0;
      [unitsSegmentedControl addTarget:self
                                action:nil
                      forControlEvents:UIControlEventValueChanged];
      
      [updateAssetPageScroller addSubview:attribField];
      [updateAssetPageScroller addSubview:unitsSegmentedControl];
      
      //Store attribute field-label in array
      [attribTextFields setObject:attribField forKey:[attribKeys objectAtIndex:i]];
      
      //Store units
      [attribUnits setObject:[unitsSegmentedControl titleForSegmentAtIndex:unitsSegmentedControl.selectedSegmentIndex] forKey:[unitIdsPerAttrib objectAtIndex:(unitsSegmentedControl.selectedSegmentIndex)]];
      
      attribField = [[UITextField alloc] init];
    }
  }
}


#pragma mark - [Cancel] button implementation
-(void) cancelUpdateAsset
{
  NSLog(@"Cancel Update Asset");
  
  cancelUpdateAssetConfirmation = [[UIAlertView alloc]
                                       initWithTitle:@"Cancel Update Asset"
                                             message:@"Are you sure you want to cancel updating this asset?"
                                            delegate:self
                                   cancelButtonTitle:@"Yes"
                                   otherButtonTitles:@"No", nil];
  
  [cancelUpdateAssetConfirmation show];
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
        [           
          {
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
    
    //Getting and setting Asset Attributes
    NSMutableArray *assetAttribKeyArray    = [[NSMutableArray alloc] init];
    NSMutableArray *assetAttribValueArray  = [[NSMutableArray alloc] init];
    NSMutableArray *assetAttribUnitIdArray = [[NSMutableArray alloc] init];
    UITextField *fieldContent              = [[UITextField alloc] init];
    
    //Store keysName and value pair
    for(NSString *key in [attribTextFields allKeys])
    {
      [assetAttribKeyArray addObject:key];
      
      fieldContent = [attribTextFields valueForKey:key];
      [assetAttribValueArray addObject:fieldContent.text];
      
      fieldContent = [[UITextField alloc] init];
    }
    
    //Store all attribute unit Ids in array
    for(NSString *key in [attribUnits allKeys])
    {
      [assetAttribUnitIdArray addObject:key];
    }
    
    NSMutableDictionary *assetAttributesDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *attribUnitsDict     = [[NSMutableDictionary alloc] init];
    NSMutableArray *innerAssetAttribArray    = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [assetAttribKeyArray count]; i++) //attribute number
    {
      [assetAttributesDict setObject:[assetAttribKeyArray objectAtIndex:i] forKey:@"keyName"];
      [assetAttributesDict setObject:[assetAttribValueArray objectAtIndex:i] forKey:@"value"];
      
      //Pair the unit of measure id with "id" key
      [attribUnitsDict setObject:[assetAttribUnitIdArray objectAtIndex:i] forKey:@"id"];
      //Add the pair inside asset attributes dictionary
      [assetAttributesDict setObject:attribUnitsDict forKey:@"unit"];
      
      //Add the consolidated single asset attribute info to the array of asset attributes
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
    //URL = @"http://192.168.2.113/vertex-api/asset/updateAsset";
    URL = @"http://192.168.2.107/vertex-api/asset/updateAsset";
    
    NSMutableURLRequest *putRequest = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:URL]];
    
    //PUT method - Update
    [putRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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
  httpResponse     = (NSHTTPURLResponse *)response;
  httpResponseCode = [httpResponse statusCode];
  NSLog(@"httpResponse status code: %d", httpResponseCode);
}


#pragma mark - Transition to Assets Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if([alertView isEqual:cancelUpdateAssetConfirmation])
  {
    NSLog(@"Cancel Update Asset Confirmation");
    if(buttonIndex == 0) //Yes - Cancel
    {
      //Go back to SR Page
      AssetPageViewController *controller = (AssetPageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AssetsPage"];
      
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
    for(NSString *key in [attribTextFields allKeys])
    {
      UITextField *tempField = [[UITextField alloc] init];
      
      tempField = [attribTextFields objectForKey:key];
      if(tempField.hasText)
      {
        return true;
      }
      else
      {
        [updateAssetValidateAlert show];
        return false;
      }
    }
  }
  
  return true;
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
