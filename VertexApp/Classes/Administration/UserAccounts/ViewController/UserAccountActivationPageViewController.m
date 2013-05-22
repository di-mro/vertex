//
//  UserAccountActivationPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/5/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "UserAccountActivationPageViewController.h"
#import "HomePageViewController.h"
#import "UserAccountConfigurationPageViewController.h"

@interface UserAccountActivationPageViewController ()

@end

@implementation UserAccountActivationPageViewController

@synthesize userAccountActivationScroller;

@synthesize usernameLabel;
@synthesize usernameField;
@synthesize esseNameLabel;
@synthesize esseNameField;
@synthesize userGroupNameLabel;
@synthesize userGroupNameField;

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
  NSLog(@"User Account Activation Page");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //Configure Scroller size
  self.userAccountActivationScroller.contentSize = CGSizeMake(320, 720);
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelUserAccountActivation)];
  
  //[Activate] navigation button - User Account Activation
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Activate"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(activateUserAccount)];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - [Cancel] button implementation
-(void) cancelUserAccountActivation
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel User Account Activation");
  
  //Go back to Home Page
  HomePageViewController *controller = (HomePageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - [Activate] button implementation
-(void) activateUserAccount
{
  if([self validateActivateUserAccountFields])
  {
    //Set JSON Request
    NSMutableDictionary *userAccountActivationJson = [[NSMutableDictionary alloc] init];
    
    //TODO : Set JSON request body
    //[userAccountActivationJson setObject:@"" forKey:@""];
    
    NSError *error   = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:userAccountActivationJson
                                   options:NSJSONWritingPrettyPrinted
                                     error:&error];
    
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                                encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonData Request: %@", jsonData);
    NSLog(@"jsonString Request: %@", jsonString);
    
    //TODO : URL for User Account Activation
    URL = @"";
    NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:URL]];
    
    //POST method - Create
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //TODO : Update httpMethod
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]]];
    NSLog(@"%@", postRequest);
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:postRequest
                                          delegate:self];
    
    [connection start];
    
    NSLog(@"activateUserAccount - httpResponseCode: %d", httpResponseCode);
  }
  else
  {
    NSLog(@"Unable to activate user account");
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
  
  if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
  {
    UIAlertView *activateUserAccountAlert = [[UIAlertView alloc]
                                                 initWithTitle:@"Activate User Account"
                                                       message:@"User account activated."
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [activateUserAccountAlert show];
  }
  else //(httpResponseCode >= 400)
  {
    UIAlertView *activateUserAccountFailAlert = [[UIAlertView alloc]
                                                     initWithTitle:@"Activate User Account Failed"
                                                           message:@"User account not activated. Please try again later"
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
    [activateUserAccountFailAlert show];
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"User Account Activated");
}


#pragma mark - Transition to Assets Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0)
  {
    UserAccountConfigurationPageViewController *controller = (UserAccountConfigurationPageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"UserAccountConfigPage"];
    
    [self.navigationController pushViewController:controller animated:YES];
  }
}


#pragma mark - Login fields validation
-(BOOL) validateActivateUserAccountFields
{
  UIAlertView *activateUserAccountValidateAlert = [[UIAlertView alloc]
                                                       initWithTitle:@"Incomplete Information"
                                                             message:@"Please fill out the necessary fields."
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
  
  if([usernameField.text isEqualToString:(@"")]
     || [esseNameField.text isEqualToString:(@"")]
     || [userGroupNameField.text isEqualToString:(@"")])
  {
    [activateUserAccountValidateAlert show];
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.view endEditing:YES];
}


#pragma mark - Dismiss onscreen keyboard
-(void)dismissKeyboard
{
  [usernameField resignFirstResponder];
  [esseNameField resignFirstResponder];
  [userGroupNameField resignFirstResponder];
}



@end
