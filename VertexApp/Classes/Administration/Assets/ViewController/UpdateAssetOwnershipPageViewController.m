//
//  UpdateAssetOwnershipPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/3/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "UpdateAssetOwnershipPageViewController.h"
#import "HomePageViewController.h"
#import "AssetConfigurationPageViewController.h"

@interface UpdateAssetOwnershipPageViewController ()

@end

@implementation UpdateAssetOwnershipPageViewController

@synthesize updateAssetOwnershipScroller;

@synthesize assetNameLabel;
@synthesize assetNameField;
@synthesize esseInfoLabel;
@synthesize esseInfoField;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize cancelUpdateAssetOwnershipConfirmation;


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
  NSLog(@"Update Asset Ownership Page");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelUpdateAssetOwnership)];
  
  //[Update] navigation button - Update Asset Ownership
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(updateAssetOwnership)];
  
  //Configure Scroller size
  self.updateAssetOwnershipScroller.contentSize = CGSizeMake(320, 720);
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//!!! TODO : Endpoints to populate fields ???

#pragma mark - [Cancel] button implementation
-(void) cancelUpdateAssetOwnership
{
  NSLog(@"Cancel Update Asset Ownership");

  cancelUpdateAssetOwnershipConfirmation = [[UIAlertView alloc]
                                                initWithTitle:@"Update Asset Ownership"
                                                      message:@"Are you sure you want to cancel updating this asset ownership?"
                                                     delegate:self
                                            cancelButtonTitle:@"Yes"
                                            otherButtonTitles:@"No", nil];
  
  [cancelUpdateAssetOwnershipConfirmation show];
}


#pragma mark - [Update] button implementation
-(void) updateAssetOwnership
{
  if([self validateUpdateAssetOwnershipFields])
  {
    NSMutableDictionary *updateAssetOwnershipJson = [[NSMutableDictionary alloc] init];
    
    //TODO : Construct JSON Request
    //[updateAssetOwnershipJson setObject:@"" forKey:@""];
    
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:updateAssetOwnershipJson
                                   options:NSJSONWritingPrettyPrinted
                                     error:&error];
    
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                                encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonData Request: %@", jsonData);
    NSLog(@"jsonString Request: %@", jsonString);
    
    //Set URL for Update Asset Accountability
    //TODO : WS Endpoint for Update Asset Accountability
    URL = @"";
    NSMutableURLRequest *putRequest = [NSMutableURLRequest
                                       requestWithURL:[NSURL URLWithString:URL]];
    
    //PUT method - Update
    [putRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //IDs?
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
      UIAlertView *updateAssetOwnershipAlert = [[UIAlertView alloc]
                                                    initWithTitle:@"Update Asset Ownership"
                                                          message:@"Asset Ownership Updated."
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
      [updateAssetOwnershipAlert show];
      //Transition to Asset Config Page - alertView clickedButtonAtIndex
    }
    else //(httpResponseCode >= 400)
    {
      UIAlertView *updateAssetOwnershipFailAlert = [[UIAlertView alloc]
                                                        initWithTitle:@"Update Asset Ownership Failed"
                                                              message:@"Asset Ownership not updated. Please try again later"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
      [updateAssetOwnershipFailAlert show];
      
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Update Asset Ownership");
  }
  else
  {
    NSLog(@"Unable to update Asset Ownership");
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


#pragma mark - Transition to Assets Config Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if([alertView isEqual:cancelUpdateAssetOwnershipConfirmation])
  {
    NSLog(@"Cancel Update Asset Ownership Confirmation");
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
-(BOOL) validateUpdateAssetOwnershipFields
{
  UIAlertView *updateAssetOwnershipValidateAlert = [[UIAlertView alloc]
                                                        initWithTitle:@"Incomplete Information"
                                                              message:@"Please fill out the necessary fields."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
  
  if([assetNameField.text isEqualToString:(@"")] || [esseInfoField.text isEqualToString:(@"")])
  {
    [updateAssetOwnershipValidateAlert show];
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
  [esseInfoField resignFirstResponder];
}


@end
