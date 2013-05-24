//
//  UpdateAssetTypePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/4/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "UpdateAssetTypePageViewController.h"
#import "HomePageViewController.h"
#import "AssetConfigurationPageViewController.h"

@interface UpdateAssetTypePageViewController ()

@end

@implementation UpdateAssetTypePageViewController

@synthesize updateAssetTypeScroller;
@synthesize assetTypeNameLabel;
@synthesize assetTypeNameField;

@synthesize assetTypeId;
@synthesize assetTypeInfo;
@synthesize URL;
@synthesize httpResponseCode;

@synthesize cancelUpdateAssetTypeConfirmation;


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
                                                                        action:@selector(dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //Configure Scroller size
  self.updateAssetTypeScroller.contentSize = CGSizeMake(320, 720);
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelUpdateAssetType)];
  
  //[Update] navigation button - Update AssetType
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(updateAssetType)];
  
  //Get info for the selected Asset Type
  [self getAssetTypeInfo];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setAssetTypeId:(NSNumber *) assetTypeIdFromPrev
{
  assetTypeId = assetTypeIdFromPrev;
  NSLog(@"assetTypeId: %@", assetTypeId);
}


#pragma mark - [Cancel] button implementation
-(void) cancelUpdateAssetType
{
  NSLog(@"Cancel Update Asset Type");
  
  cancelUpdateAssetTypeConfirmation = [[UIAlertView alloc]
                                           initWithTitle:@"Cancel Update Asset Type"
                                                 message:@"Are you sure you want to cancel updating this asset type?"
                                                delegate:self
                                       cancelButtonTitle:@"Yes"
                                       otherButtonTitles:@"No", nil];
  
  [cancelUpdateAssetTypeConfirmation show];
}


#pragma mark - Get chosen asset type info
-(void) getAssetTypeInfo
{
  //URL for retrieving particular asset type info
  //URL = @"http://192.168.2.113/vertex-api/asset/getAssetType/";
  URL = @"http://192.168.2.107/vertex-api/asset/getAssetType/";
  
  //! TEST
  NSMutableString *urlParams = [NSMutableString
                                stringWithFormat:@"http://192.168.2.107/vertex-api/asset/getAssetType/%@"
                                , assetTypeId];
  
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
    //TEST DATA ONLY
    /*
    lifecycleNameField.text = @"Demo - repair";
    lifecycleDescriptionField.text = @"Demo - repair";
    lifecyclePreviousField.text = @"Demo - 1";
    */
  }
  else
  {
    //JSON
    assetTypeInfo = [NSJSONSerialization
                     JSONObjectWithData:responseData
                     options:kNilOptions
                     error:&error];
    NSLog(@"assetTypeInfo JSON: %@", assetTypeInfo);
    
    assetTypeNameField.text = [assetTypeInfo objectForKey:@"name"];
    /*
    lifecycleNameField.text = [lifecycleInfo objectForKey:@"name"];
    lifecycleDescriptionField.text = [lifecycleInfo objectForKey:@"description"];
    lifecyclePreviousField.text = [lifecycleInfo objectForKey:@"prev"];
    */
    
  }//end - else if (responseData == nil)
}


#pragma mark - Update Asset Type
-(void) updateAssetType
{
  if([self validateUpdateAssetTypeFields])
  {
    //Set JSON Request
    NSMutableDictionary *updateAssetTypeJson = [[NSMutableDictionary alloc] init];
    [updateAssetTypeJson setObject:assetTypeId forKey:@"id"];
    /*
    [updateAssetTypeJson setObject:@"" forKey:@""];
    [updateAssetTypeJson setObject: forKey:@""];
    [updateAssetTypeJson setObject: forKey:@""];
    */
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:updateAssetTypeJson
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                            encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonData Request: %@", jsonData);
    NSLog(@"jsonString Request: %@", jsonString);
    
    //Set URL for Update Asset Type
    //TODO : WS Endpoint for Update Asset Type
    URL = @"";
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
    
    NSLog(@"updateAssetType - httpResponseCode: %d", httpResponseCode);
    if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
    {
      UIAlertView *updateAssetTypeAlert = [[UIAlertView alloc]
                                            initWithTitle:@"Update Asset Type"
                                                  message:@"Asset Type Updated."
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
      [updateAssetTypeAlert show];
    }
    else //(httpResponseCode >= 400)
    {
      UIAlertView *updateAssetTypeFailAlert = [[UIAlertView alloc]
                                                initWithTitle:@"Update Asset Type Failed"
                                                      message:@"Asset Type not updated. Please try again later"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
      [updateAssetTypeFailAlert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Updated Asset Type");
  }
  else
  {
    NSLog(@"Unable to update Asset Type");
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
  if([alertView isEqual:cancelUpdateAssetTypeConfirmation])
  {
    NSLog(@"Cancel Update Asset Type Confirmation");
    if(buttonIndex == 0) //Yes - Cancel
    {
      //Go back to Asset Config Page
      AssetConfigurationPageViewController *controller = (AssetConfigurationPageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AssetConfigPage"];
      
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
-(BOOL) validateUpdateAssetTypeFields
{
  UIAlertView *updateAssetTypeValidateAlert = [[UIAlertView alloc]
                                                  initWithTitle:@"Incomplete Information"
                                                        message:@"Please fill out the necessary fields."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
  [updateAssetTypeValidateAlert show];
  return true;
  /*
  if([lifecycleNameField.text isEqualToString:(@"")]
     || [lifecycleDescriptionField.text isEqualToString:(@"")]
     || [lifecyclePreviousField.text isEqualToString:(@"")])
  {
    [updateAssetTypeValidateAlert show];
    return false;
  }
  else
  {
    return true;
  }
   */
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
  /*
  [lifecycleNameField resignFirstResponder];
  [lifecycleDescriptionField resignFirstResponder];
  [lifecyclePreviousField resignFirstResponder];
  */
}


@end
