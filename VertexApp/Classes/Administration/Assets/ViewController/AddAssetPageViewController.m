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

@synthesize assetNameField;
@synthesize assetTypeField;

/*
@synthesize modelField;
@synthesize brandField;
@synthesize powerConsumptionField;

@synthesize modelLabel;
@synthesize brandLabel;
@synthesize powerConsumptionLabel;
 
@synthesize remarksArea;
@synthesize remarksLabel;
*/

//@synthesize assetObject;
//@synthesize assetTypesObject;
//@synthesize assetAttributesObject;

@synthesize selectedIndex;
@synthesize attribTextFields;

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
  //selectedAssetTypeId = @111000; //TEST only
  
  [self setAttributesField];
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
        
      [addAssetScroller addSubview:attribField];
              
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
    //id depends on chosen AssetType
    //hardcoded id aircon - 20130101011100000
    //hardcoded id window - 20130101011300000
    
    //AssetAttributes Array of Objects - Store key and name in array first before consolidating in a dictionary
    //Use Core Data Model Objects
    
    //NSMutableArray *assetAttribKeyArray = [[NSMutableArray alloc] initWithObjects:@"Model", @"Brand", @"Power Consumption", @"Remark", nil];
    //NSMutableArray *assetAttribValueArray = [[NSMutableArray alloc] initWithObjects:modelField.text, brandField.text, powerConsumptionField.text, remarksArea.text , nil];
    
    //Getting and setting Asset Attributes
    NSMutableArray *assetAttribKeyArray = [[NSMutableArray alloc] init];
    NSMutableArray *assetAttribValueArray = [[NSMutableArray alloc] init];
    UITextField *fieldContent = [[UITextField alloc] init];
    //NSString *fieldContent = [[NSString alloc] init];
    for(NSString *key in [attribTextFields allKeys])
    {
      [assetAttribKeyArray addObject:key];
      NSLog(@"assetAttribKeyArray: %@", assetAttribKeyArray);
      
      fieldContent = [attribTextFields valueForKey:key];
      [assetAttribValueArray addObject:fieldContent.text];
      //[assetAttribValueArray addObject:[[attribTextFields valueForKey:key] description]];
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
    URL = @"http://192.168.2.13:8080/vertex-api/asset/addAsset";
    NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                       requestWithURL:[NSURL URLWithString:URL]];
    
    //POST method - Create
    [postRequest setValue:@"20130101005100000" forHTTPHeaderField:@"userId"]; //make userID dynamic
    [postRequest setHTTPMethod:@"POST"]; //POST
    [postRequest setHTTPBody:jsonData];
    //[postRequest setHTTPBody:[NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]]];
    NSLog(@"%@", postRequest);
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:postRequest
                                   delegate:self];
    
    [connection start];
    
    //POST
    if(httpResponseCode == 201) //add
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
