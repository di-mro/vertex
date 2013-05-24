//
//  UpdateLifecyclePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/2/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "UpdateLifecyclePageViewController.h"
#import "HomePageViewController.h"
#import "LifecycleConfigurationPageViewController.h"

@interface UpdateLifecyclePageViewController ()

@end

@implementation UpdateLifecyclePageViewController

@synthesize updateLifecycleScroller;

@synthesize lifecycleNameLabel;
@synthesize lifecycleNameField;
@synthesize lifecycleDescriptionLabel;
@synthesize lifecycleDescriptionField;
@synthesize lifecyclePreviousLabel;
@synthesize lifecyclePreviousField;

@synthesize lifecycleId;
@synthesize lifecycleInfo;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize cancelUpdateLifecycleConfirmation;


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
  NSLog(@"Update Lifecycle Page View");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //Configure Scroller size
  self.updateLifecycleScroller.contentSize = CGSizeMake(320, 720);
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelUpdateLifecycle)];
  
  //[Update] navigation button - Update Lifecycle
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(updateLifecycle)];
  
  //Get info for the selected Lifecycle
  [self getLifecycleInfo];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - Set Lifecycle ID to the selected lifecycleID from previous page
- (void) setLifecycleId:(NSNumber *) lifecycleIdFromPrev
{
  lifecycleId = lifecycleIdFromPrev;
  NSLog(@"LifeCycleDetailPage - lifecycleId: %@", lifecycleId);
}


#pragma mark - [Cancel] button implementation
-(void) cancelUpdateLifecycle
{
  NSLog(@"Cancel Update Lifecycle");
  
  cancelUpdateLifecycleConfirmation = [[UIAlertView alloc]
                                           initWithTitle:@"Cancel Update Lifecycle"
                                                 message:@"Are you sure you want to cancel lifecycle update?"
                                                delegate:self
                                       cancelButtonTitle:@"Yes"
                                       otherButtonTitles:@"No", nil];
  
  [cancelUpdateLifecycleConfirmation show];
}


#pragma mark - Get chosen lifecycle info
-(void) getLifecycleInfo
{
  //URL = @"http://192.168.2.113/vertex-api/lifecycle/getLifecycle/";
  URL = @"http://192.168.2.107/vertex-api/lifecycle/getLifecycle/";
  
  //! TEST
  NSMutableString *urlParams = [NSMutableString
                                stringWithFormat:@"http://192.168.2.107/vertex-api/lifecycle/getLifecycle/%@"
                                , lifecycleId];
  
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
    lifecycleNameField.text        = @"Demo - repair";
    lifecycleDescriptionField.text = @"Demo - repair";
    lifecyclePreviousField.text    = @"Demo - 1";
  }
  else
  {
    //JSON
    lifecycleInfo = [NSJSONSerialization
                     JSONObjectWithData:responseData
                                options:kNilOptions
                                  error:&error];
    
    NSLog(@"lifecycleInfo JSON: %@", lifecycleInfo);
    
    lifecycleNameField.text        = [lifecycleInfo objectForKey:@"name"];
    lifecycleDescriptionField.text = [lifecycleInfo objectForKey:@"description"];
    lifecyclePreviousField.text    = [lifecycleInfo objectForKey:@"prev"];
  
  }//end - else if (responseData == nil)
}


#pragma mark - Update Lifecycle
-(void) updateLifecycle
{
  if([self validateUpdateLifecycleFields])
  {
    //Set JSON Request
    NSMutableDictionary *updateLifecycleJson = [[NSMutableDictionary alloc] init];
    [updateLifecycleJson setObject:lifecycleId forKey:@"id"];
    [updateLifecycleJson setObject:lifecycleNameField.text forKey:@"name"];
    [updateLifecycleJson setObject:lifecycleDescriptionField.text forKey:@"description"];
    [updateLifecycleJson setObject:lifecyclePreviousField.text forKey:@"prev"];
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:updateLifecycleJson
                                   options:NSJSONWritingPrettyPrinted
                                     error:&error];
    
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                                encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonData Request: %@", jsonData);
    NSLog(@"jsonString Request: %@", jsonString);
    
    //Set URL for Update Lifecycle
    //URL = @"http://192.168.2.113/vertex-api/lifecycle/updateLifecycle";
    URL = @"http://192.168.2.107/vertex-api/lifecycle/updateLifecycle";
    
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
    
    NSLog(@"updateLifecycle - httpResponseCode: %d", httpResponseCode);
    if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
    {
      UIAlertView *updateLifecycleAlert = [[UIAlertView alloc]
                                            initWithTitle:@"Update Lifecycle"
                                                  message:@"Lifecycle Updated."
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
      [updateLifecycleAlert show];
    }
    else //(httpResponseCode >= 400)
    {
      UIAlertView *updateLifecycleFailAlert = [[UIAlertView alloc]
                                                initWithTitle:@"Update Lifecycle Failed"
                                                      message:@"Lifecycle not updated. Please try again later"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
      [updateLifecycleFailAlert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Updated Lifecycle");
  }
  else
  {
    NSLog(@"Unable to update lifecycle");
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


#pragma mark - Transition to Lifecycle Configuration Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if([alertView isEqual:cancelUpdateLifecycleConfirmation])
  {
    NSLog(@"Cancel Update Lifecycle Confirmation");
    if(buttonIndex == 0) //Yes - Cancel
    {
      //Go back to SR Page
      LifecycleConfigurationPageViewController *controller = (LifecycleConfigurationPageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"LifecycleConfigPage"];
      
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
-(BOOL) validateUpdateLifecycleFields
{
  UIAlertView *updateLifeycleValidateAlert = [[UIAlertView alloc]
                                               initWithTitle:@"Incomplete Information"
                                                     message:@"Please fill out the necessary fields."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
  
  if([lifecycleNameField.text isEqualToString:(@"")]
     || [lifecycleDescriptionField.text isEqualToString:(@"")]
     || [lifecyclePreviousField.text isEqualToString:(@"")])
  {
    [updateLifeycleValidateAlert show];
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


#pragma mark - Dismiss the onscreen keyboard when not in use
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  [self.view endEditing:YES];
}


#pragma mark - Dismiss onscreen keyboard
-(void)dismissKeyboard
{
  [lifecycleNameField resignFirstResponder];
  [lifecycleDescriptionField resignFirstResponder];
  [lifecyclePreviousField resignFirstResponder];
}


@end
