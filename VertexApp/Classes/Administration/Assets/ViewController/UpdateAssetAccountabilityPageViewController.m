//
//  UpdateAssetAccountabilityPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/3/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "UpdateAssetAccountabilityPageViewController.h"
#import "HomePageViewController.h"
#import "AssetConfigurationPageViewController.h"

@interface UpdateAssetAccountabilityPageViewController ()

@end

@implementation UpdateAssetAccountabilityPageViewController

@synthesize updateAssetAccountabilityScroller;

@synthesize assetNameLabel;
@synthesize assetNameField;
@synthesize userAccountLabel;
@synthesize userAccountField;

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
  NSLog(@"Update Asset Accountability Page");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelUpdateAssetAccountability)];
  
  //[Update] navigation button - Update Asset Accountability
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(updateAssetAccountability)];
  
  //Configure Scroller size
  self.updateAssetAccountabilityScroller.contentSize = CGSizeMake(320, 720);
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//TODO : Endpoints to populate fields ???

#pragma mark - [Cancel] button implementation
-(void) cancelUpdateAssetAccountability
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Update Asset Accountability");
  
  //Go back to Home Page
  HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - [Update] button implementation
-(void) updateAssetAccountability
{
  if([self validateUpdateAssetAccountabilityFields])
  {
    NSMutableDictionary *updateAssetAccountabilityJson = [[NSMutableDictionary alloc] init];
    
    //TODO : Construct JSON Request
    //[updateAssetAccountabilityJson setObject:@"" forKey:@""];
    
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:updateAssetAccountabilityJson
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
      UIAlertView *updateAssetAccountabilityAlert = [[UIAlertView alloc]
                                                         initWithTitle:@"Update Asset Accountability"
                                                               message:@"Asset Accountability Updated."
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
      [updateAssetAccountabilityAlert show];
      //Transition to Assets Page - alertView clickedButtonAtIndex
    }
    else //(httpResponseCode >= 400)
    {
      UIAlertView *updateAssetAccountabilityFailAlert = [[UIAlertView alloc]
                                                             initWithTitle:@"Update Asset Accountability Failed"
                                                                   message:@"Asset Accountability not updated. Please try again later"
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
      [updateAssetAccountabilityFailAlert show];
      
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Update Asset Accountability");
  }
  else
  {
    NSLog(@"Unable to update Asset Accountability");
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
    AssetConfigurationPageViewController *controller = (AssetConfigurationPageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AssetConfigPage"];
    
    [self.navigationController pushViewController:controller animated:YES];
  }
}


#pragma mark - Login fields validation
-(BOOL) validateUpdateAssetAccountabilityFields
{
  UIAlertView *updateAssetAccountabilityValidateAlert = [[UIAlertView alloc]
                                                             initWithTitle:@"Incomplete Information"
                                                                   message:@"Please fill out the necessary fields."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
  
  if([assetNameField.text isEqualToString:(@"")] || [userAccountField.text isEqualToString:(@"")])
  {
    [updateAssetAccountabilityValidateAlert show];
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
  [userAccountField resignFirstResponder];  
}


@end
