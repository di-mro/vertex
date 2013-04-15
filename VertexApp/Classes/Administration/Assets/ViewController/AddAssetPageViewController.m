//
//  AddAssetPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AddAssetPageViewController.h"
#import "HomePageViewController.h"
#import "AssetPageViewController.h"
#import "Reachability.h"
#import "AppDelegate.h"

#import "Assets.h"
#import "AssetAttributes.h"
#import "AssetTypes.h"

#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>


@interface AddAssetPageViewController ()

@end

@implementation AddAssetPageViewController

@synthesize assetTypePickerArray;
@synthesize assetTypePicker;
@synthesize addAssetScroller;
@synthesize actionSheet;

@synthesize addAssetView;

@synthesize assetNameField;
@synthesize assetTypeField;

@synthesize selectedIndex;

@synthesize attribTextFields;
@synthesize attribUnitFields;
@synthesize assetAttributeScroller;
@synthesize attributesPicker;

@synthesize genericPicker;
@synthesize currentPickerArray;
@synthesize currentTextField;

@synthesize selectedUnitIds;

@synthesize assetTypes;
@synthesize assetTypeAttributes;
@synthesize selectedAssetTypeId;
@synthesize URL;
@synthesize httpResponseCode;

@synthesize context;


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
  
  //[Add] navigation button - Add Asset
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(createAsset)];
  
  //Configure Scroller size
  self.addAssetScroller.contentSize = CGSizeMake(320, 720);
  [self.view addSubview:addAssetScroller];
  
  //Configure Picker array
  self.assetTypePickerArray = [[NSArray alloc] init];
  
  [self getAssetTypes];
  
  //Configure Asset Attributes Scroller size
  self.assetAttributeScroller.contentSize = CGSizeMake(188, 500);
  [self.view addSubview:assetAttributeScroller];
  
  //assetTypePicker in assetTypeField
  [assetTypeField setDelegate:self];
  
  //CoreData
  AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  context = [appDelegate managedObjectContext];
  NSLog(@"appDelegate %@", appDelegate);
  NSLog(@"context: %@", context);
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get AssetTypes
- (void) getAssetTypes
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


#pragma mark - Generic Picker definitions
-(void) defineGenericPicker
{
  //Generic Picker definition
  genericPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
  genericPicker.showsSelectionIndicator = YES;
  genericPicker.dataSource = self;
  genericPicker.delegate = self;
}


#pragma mark - Change assetTypeField to assetTypePicker when clicked
- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
  /*
  //assetAttribute units
  UITextField *attribField = [[UITextField alloc] init];
  attribField = [[attribUnitFields valueForKey:@"unit"] objectAtIndex:0]; // * * *
  */
  
  //action sheet definition
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
  [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
  
  
  if(assetTypeField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - function call");
    [textField resignFirstResponder];
    
    assetTypePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
    assetTypePicker.showsSelectionIndicator = YES;
    assetTypePicker.dataSource = self;
    assetTypePicker.delegate = self;
    
    [actionSheet addSubview:assetTypePicker];
    
    assetTypeField.inputView = actionSheet;
    
    /*
    currentPickerArray = [[NSArray alloc] initWithObjects: nil];
    [self defineGenericPicker];
    [actionSheet addSubview:genericPicker];
     
    currentPickerArray = assetTypePickerArray;
    currentTextField = assetTypeField;
    assetTypeField.inputView = actionSheet;
    //selectedAssetTypeId = [assetTypeIdArray objectAtIndex:selectedIndex];
    */
    
    //clear subviews (attribute field)
    NSArray *subviews = [[assetAttributeScroller subviews] copy];
    NSLog(@"subviews: %@", subviews);
    for (UIView *subview in subviews)
    {
      [subview removeFromSuperview];
    }
    
    return YES;
  }
  /*
  else if(attribField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing attribField - function call");
    [attribField resignFirstResponder];
    
    attributesPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
    attributesPicker.showsSelectionIndicator = YES;
    attributesPicker.dataSource = self;
    attributesPicker.delegate = self;
    
    [actionSheet addSubview:attributesPicker];
    
    assetTypeField.inputView = actionSheet;

    return YES;
  }
   */
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
  NSLog(@"selectedRow-selectedAssetTypeId: %@", selectedAssetTypeId);
  
  [self setAttributesField];
}

/*
#pragma mark - Get selected row in Picker
-(void)selectedRow
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  selectedIndex = [genericPicker selectedRowInComponent:0];
  NSString *selectedEntity = [currentArray objectAtIndex:selectedIndex];
  currentTextField.text = selectedEntity;
}
*/

#pragma mark - Get the selected unit in assetAttribUnitsPicker
-(void) selectedUnit
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  
}


#pragma mark - Dynamically set the text fields for Asset Attributes based on Asset Type
-(void) setAttributesField
{
  if(selectedAssetTypeId == nil)
  {
    NSLog(@"Nil assetTypeId");
  }
  else
  {
    //TODO: assetTypeAttributes
    NSMutableArray *allAssetAttrib = [[NSMutableArray alloc] init];
    attribTextFields = [[NSMutableDictionary alloc] init];
    attribUnitFields = [[NSMutableDictionary alloc] init];
    
    allAssetAttrib = [assetTypes valueForKey:@"attributes"];
    NSLog(@"allAssetAttrib: %@", allAssetAttrib);
    
    assetTypeAttributes = [allAssetAttrib objectAtIndex:selectedIndex]; //array
    NSLog(@"assetTypeAttributes: %@", assetTypeAttributes);
    
    /*
    NSMutableDictionary *unitsPerAttrib = [[NSMutableDictionary alloc] init];
    unitsPerAttrib = [assetTypeAttributes valueForKey:@"units"];
    NSLog(@"unitsPerAttrib: %@", unitsPerAttrib);
    */
    
    NSMutableArray *unitNames = [[NSMutableArray alloc] init];
    unitNames = [[assetTypeAttributes valueForKey:@"units"] valueForKey:@"name"];
    NSLog(@"unitNames: %@", unitNames);
    
    int attribTextfieldHeight = 30;
    int attribTextfieldWidth = 240;
    int unitTextfieldHeight = 30;
    int unitTextfieldWidth = 90;
    int yOrigin = 0;
    
    UITextField *attribField = [[UITextField alloc] init];
    UITextField *unitField = [[UITextField alloc] init];
    
    for(int i = 0; i < [assetTypeAttributes count]; i++)
    {
      NSString *textFieldLabel = [[NSString alloc] initWithString:[[assetTypeAttributes objectAtIndex:i] valueForKey:@"keyName"]];
      
      NSMutableArray *unitsPerAttrib = [[NSMutableArray alloc] init];
      unitsPerAttrib = [unitNames objectAtIndex:i];
      NSLog(@"unitsPerAttrib: %@", unitsPerAttrib);

      
      //attributeField
      attribField = [[UITextField alloc] initWithFrame:CGRectMake(0, (i * attribTextfieldHeight + 10), attribTextfieldWidth, attribTextfieldHeight)];
      attribField.borderStyle = UITextBorderStyleRoundedRect;
      attribField.placeholder = textFieldLabel;
      
      CGRect attribTextFieldFrame = attribField.frame;
      attribTextFieldFrame.origin.x = 20;
      attribTextFieldFrame.origin.y += (yOrigin += 15);
      attribField.frame = attribTextFieldFrame;
      
      //attributeUnits Field
      unitField = [[UITextField alloc] initWithFrame:CGRectMake(0, (i * unitTextfieldHeight + 10), unitTextfieldWidth, unitTextfieldHeight)];
      unitField.borderStyle = UITextBorderStyleRoundedRect;
      unitField.placeholder = @"Pick unit";
      
      CGRect attribUnitTextFieldFrame = unitField.frame;
      attribUnitTextFieldFrame.origin.x = 40;
      attribUnitTextFieldFrame.origin.y += (yOrigin += 40);
      unitField.frame = attribUnitTextFieldFrame;

      //Add fields in scroller
      [assetAttributeScroller addSubview:attribField];
      [assetAttributeScroller addSubview:unitField];
      
      //Store attribute field-label in dictionary
      [attribTextFields setObject:attribField forKey:textFieldLabel];
      //NSLog(@"attribTextFields: %@", attribTextFields);
      
      //Store units
      [attribUnitFields setObject:unitField forKey:@"unit"];
      //NSLog(@"attribUnitFields: %@", attribUnitFields);
      
      attribField = [[UITextField alloc] init];
      unitField = [[UITextField alloc] init];
    }
  }
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


#pragma mark - [Add] button implementation
-(void) createAsset
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
            unit
            {
              id: long
            }
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
    
    //Set URL for Add Asset
    //URL = @"http://192.168.2.113:8080/vertex-api/asset/addAsset";
    URL = @"http://192.168.2.113/vertex-api/asset/addAsset";
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                       requestWithURL:[NSURL URLWithString:URL]];
    
    //POST method - Create
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:@"20130101500000001" forHTTPHeaderField:@"userId"]; //make userID dynamic
    [postRequest setHTTPMethod:@"POST"];
    //[postRequest setHTTPBody:jsonData];
    [postRequest setHTTPBody:[NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]]]; //pass JSON as string
    NSLog(@"%@", postRequest);
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:postRequest
                                   delegate:self];
    
    [connection start];
    
    NSLog(@"createAsset - httpResponseCode: %d", httpResponseCode);
    if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
    {
      UIAlertView *createAssetAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Add Asset"
                                       message:@"Asset Created."
                                       delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
      [createAssetAlert show];
      //Transition to Assets Page - alertView clickedButtonAtIndex
    }
    else //(httpResponseCode >= 400)
    {
      UIAlertView *createAssetFailAlert = [[UIAlertView alloc]
                                           initWithTitle:@"Add Asset Failed"
                                           message:@"Asset not added. Please try again later"
                                           delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
      [createAssetFailAlert show];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Create Asset");
    
    /*
     //Core Data Save
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
     NSManagedObjectContext *context = [appDelegate  managedObjectContext];
     
     NSLog(@"moc-entities: %@", context.persistentStoreCoordinator.managedObjectModel.entities);
     Assets *assetsObject = [NSEntityDescription insertNewObjectForEntityForName:@"Assets" inManagedObjectContext:context];
     assetsObject.assetName = assetNameField.text;
     
     AssetTypes *assetTypesObject = [NSEntityDescription insertNewObjectForEntityForName:@"AssetTypes" inManagedObjectContext:context];
     assetTypesObject.assetTypeName = assetTypeField.text;
     
     NSError *error;
     if (![context save:&error])
     {
     NSLog(@"Couldn't save data: %@", [error localizedDescription]);
     }
     
     NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
     NSEntityDescription *entity = [NSEntityDescription entityForName:@"Assets"
     inManagedObjectContext:context];
     [fetchRequest setEntity:entity];
     NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
     for (Assets *assets in fetchedObjects)
     {
     NSLog(@"assetName: %@", assets.assetName);
     }
     */
  }
  else
  {
    NSLog(@"Unable to add Asset");
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
}


#pragma mark - Dismiss assetTypePicker action sheet
-(void)dismissActionSheet:(id) sender
{
  [sender dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark - Dismiss the onscreen keyboard when not in use
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  [self.view endEditing:YES];
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
  
  //Iterate over attribute unit fields and resignFirstResponder each
  for(NSString *key in [attribUnitFields allKeys])
  {
    [[attribUnitFields objectForKey:@"unit"] resignFirstResponder];
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
