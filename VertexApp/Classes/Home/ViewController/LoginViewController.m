//
//  LoginViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginCredentials.h"
#import "Reachability.h"
#import "RestKit/RestKit.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize userNameField;
@synthesize passwordField;
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
  //Set URL for Login
  URL = @"http://192.168.2.102:8080/vertex/ws/user/loginform";
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Dismiss the onscreen keyboard when not in use
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  [self.view endEditing:YES];
}

#pragma mark - [Login] button functions
- (IBAction)login:(id)sender
{
  if([self validateLoginFields])
  {
    NSString *username = userNameField.text;
    NSString *password = passwordField.text;
    
    NSMutableString *bodyData = [NSMutableString
                                 stringWithFormat:@"username=%@&password=%@"
                                 , username
                                 , password];
    NSLog(@"%@", bodyData);
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:URL]];
    
    // Set the request's content type to application/x-www-form-urlencoded
    [postRequest setValue:@"application/x-www-form-urlencoded"
       forHTTPHeaderField:@"Content-Type"];
    // Designate the request a POST request and specify its body data
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String]
                                            length:[bodyData length]]];
    NSLog(@"%@", postRequest);
    
    if([self reachable])
    {
      NSLog(@"Reachable");
      
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
      
      NSString *result = [[NSString alloc] initWithData:responseData
                                               encoding:NSUTF8StringEncoding];
      NSMutableDictionary *json = [NSJSONSerialization
                                   JSONObjectWithData:responseData
                                   options:kNilOptions
                                   error:&error];
      NSString *loginProceed = [json objectForKey:@"valid"];
      
      NSLog(@"Response code- %ld",(long)[urlResponse statusCode]);
      NSLog(@"Login Response: %@", result);
      NSLog(@"Response JSON: %@", json);
      NSLog(@"Login Response JSON: %@", loginProceed);
      
      if([loginProceed boolValue])
      {
        [self performSegueWithIdentifier: @"loginToHome" sender: self];
      }
      else
      {
        UIAlertView *loginAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Invalid User"
                                   message:@"Username and password is incorrect."
                                   delegate:self
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [loginAlert show];
      }
    }
    else
    {
      NSLog(@"Non Reachable");
      
      //Show an alert if connection is not available
      UIAlertView *connectionAlert = [[UIAlertView alloc]
                                      initWithTitle:@"Warning"
                                      message:@"No network connection detected. Some functions may be unavailable."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
      [connectionAlert show];
      
      //If OK is pressed, go to Home Page
      //Connect to CoreData for local data
    }
  }
  else
  {
    NSLog(@"Unable to login");
  }
  
  //TESTING PURPOSES ONLY
  //[self performSegueWithIdentifier: @"loginToHome" sender: self];
  
  /*
   //RestKit
   NSString *username = userNameField.text;
   NSString *password = passwordField.text;
   
   RKObjectMapping* loginMapping = [RKObjectMapping requestMapping ];
   // Shortcut for [RKObjectMapping mappingForClass:[NSMutableDictionary class] ]
   [loginMapping addAttributeMappingsFromArray:@[@"username", @"password"]];
   NSLog(@"loginMapping: %@", loginMapping);
   
   // Now configure the request descriptor
   RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:loginMapping
   objectClass:[LoginCredentials class]
   rootKeyPath:@"user"];
   NSLog(@"requestDescriptor: %@", requestDescriptor);
   
   // Create a new LoginCredential object and POST it to the server
   LoginCredentials *loginCredentials = [[LoginCredentials alloc] init];
   loginCredentials.username = username;
   loginCredentials.password = password;
   NSLog(@"loginCredentials: %@", loginCredentials);
   [[RKObjectManager sharedManager] postObject:loginCredentials path:@"http://192.168.2.103:8080/vertex/ws/user/login" parameters:nil success:nil failure:nil];
   */
}

/*
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
*/

#pragma mark - Present warning that there is no network connection before proceeding to Home Page
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0)
  {
    [self performSegueWithIdentifier: @"loginToHome" sender: self];
  }
}


#pragma mark - Login fields validation
-(BOOL) validateLoginFields
{
  UIAlertView *loginValidateAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Incomplete Information"
                                           message:@"Please fill out all the fields."
                                          delegate:nil //set to 'nil' to not activate clickedAtButtonAtIndex
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];

  if([userNameField.text isEqualToString:(@"")]
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
