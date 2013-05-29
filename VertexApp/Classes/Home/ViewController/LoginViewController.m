//
//  LoginViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "LoginViewController.h"
#import "Reachability.h"
#import "RestKit/RestKit.h"
#import "HomePageViewController.h"
#import "UserAccountInfoManager.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize usernameField;
@synthesize passwordField;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize userInfo;

@synthesize userId;
@synthesize username;
@synthesize password;
@synthesize userProfileId;
@synthesize userInfoId;
@synthesize token;


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
  //Initialize userAccountInfoSQLManager
  userAccountInfoSQLManager = [UserAccountInfoManager alloc];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Dismiss the onscreen keyboard when not in use
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.view endEditing:YES];
}


#pragma mark - [Login] button functions
- (IBAction)login:(id)sender
{
  //Set URL for Login
  URL = @"http://192.168.2.113/vertex-api/auth/login"; //107
  
  if([self validateLoginFields])
  {
    username = usernameField.text;
    password = passwordField.text;
    
    NSMutableString *bodyData = [NSMutableString
                                 stringWithFormat:@"username=%@&password=%@"
                                 , username
                                 , password];
    NSLog(@"%@", bodyData);
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:URL]];
    
    // Set the request's content type to application/x-www-form-urlencoded
    //POST method
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String]
                                            length:[bodyData length]]];
    NSLog(@"%@", postRequest);
    // Initialize the NSURLConnection and proceed as usual
    NSURLConnection *connection = [[NSURLConnection alloc]
                                     initWithRequest:postRequest
                                            delegate:self];
    //start the connection
    [connection start];
      
    // Get Response. Validation before proceeding to next page. Retrieve confirmation from the ws that user is valid.
    NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
      
    NSData *responseData = [NSURLConnection
                            sendSynchronousRequest:postRequest
                                 returningResponse:&urlResponse
                                             error:&error];
    
    if(responseData == nil)
    {
      UIAlertView *loginAlert = [[UIAlertView alloc]
                                     initWithTitle:@"No Connection Detected"
                                           message:@"Displaying data from phone cache"
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
      [loginAlert show];
      
      //[self performSegueWithIdentifier: @"loginToHome" sender: self];
    }
    else
    {
      NSDictionary *loginHeaderResponse = [[NSDictionary alloc] init];
      loginHeaderResponse               = [(NSHTTPURLResponse *)urlResponse allHeaderFields];
      NSLog(@"loginHeaderResponse: %@", loginHeaderResponse);
      
      token = [loginHeaderResponse valueForKey:@"token"];
      NSLog(@"token: %@", token);
      
      NSMutableDictionary *json = [NSJSONSerialization
                                   JSONObjectWithData:responseData
                                              options:kNilOptions
                                                error:&error];
      
      NSLog(@"Response JSON: %@", json);
    }
  }
  else
  {
    NSLog(@"Unable to login");
  }
  
  //Connect to endpoint /getUserByName and get logged user's account info
  [self getUserInfo];
}


#pragma mark - getUserByName
-(void) getUserInfo
{
  username = usernameField.text;
  NSLog(@"username: %@", username);
  NSMutableString *urlParams = [NSMutableString stringWithFormat:@"http://192.168.2.113/vertex-api/user/getUserByName/%@", username];
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                      requestWithURL:[NSURL URLWithString:urlParams]];
  
  //GET method
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [getRequest setHTTPMethod:@"GET"];
  NSLog(@"%@", getRequest);
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:getRequest
                                        delegate:self];
  //start the connection
  [connection start];
  
  // Get Response. Validation before proceeding to next page. Retrieve confirmation from the ws that user is valid.
  NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
  NSError *error = [[NSError alloc] init];
  
  NSData *responseData = [NSURLConnection
                          sendSynchronousRequest:getRequest
                               returningResponse:&urlResponse
                                           error:&error];
  
  if(responseData == nil)
  {
    UIAlertView *loginAlert = [[UIAlertView alloc]
                                   initWithTitle:@"No Connection Detected"
                                         message:@"Displaying data from phone cache"
                                        delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [loginAlert show];
  }
  else
  {
    userInfo = [NSJSONSerialization
                JSONObjectWithData:responseData
                           options:kNilOptions
                             error:&error];
    
    NSLog(@"getUserInfo JSON Result: %@", userInfo);
    
    //Get userInfo to be stored in SQLite table
    userId        = [userInfo valueForKey:@"id"];
    username      = [userInfo valueForKey:@"username"];
    password      = passwordField.text;
    userProfileId = [[userInfo valueForKey:@"profile"] valueForKey:@"id"];
    userInfoId    = [[userInfo valueForKey:@"info"] valueForKey:@"id"];
    //token - assigned in login()
    
    //SQLite operations - save user account information of logged user
    [userAccountInfoSQLManager createTable:@"user_accounts"
                               withField1:@"userId"
                               withField2:@"username"
                               withField3:@"password"
                               withField4:@"profileId"
                               withField5:@"userInfoId"
                               withField6:@"token"];

    [userAccountInfoSQLManager saveUserInfo:userId
                                          :username
                                          :password
                                          :userProfileId
                                          :userInfoId
                                          :token];
  }
  
  //Segue to Home Page
  [self performSegueWithIdentifier: @"loginToHome" sender: self];
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
  NSLog(@"connection-httpResponse status code: %d", httpResponseCode);
}


#pragma mark - Login fields validation
-(BOOL) validateLoginFields
{
  UIAlertView *loginValidateAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Incomplete Information"
                                           message:@"Please fill out all the fields."
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];

  if([usernameField.text isEqualToString:(@"")]
     || [passwordField.text isEqualToString:(@"")])
  {
    [loginValidateAlert show];
    
    return false;
  }
  else
  {
    return true;
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
