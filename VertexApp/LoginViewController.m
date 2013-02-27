//
//  LoginViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize userNameField;
@synthesize passwordField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Dismiss the onscreen keyboard when not in use
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  [self.view endEditing:YES];
}

//Login button functions
- (IBAction)login:(id)sender
{
  if([self validateLoginFields])
  {
    //TESTING PURPOSES ONLY
    [self performSegueWithIdentifier: @"loginToHome" sender: self];
    
    /*
     NSString *username = userNameField.text;
     NSString *password = passwordField.text;
     
     NSMutableString *bodyData = [NSMutableString stringWithFormat:@"username=%@&password=%@", username, password];
     NSLog(@"%@", bodyData);
     
     NSString *urlString   = @"http://192.168.2.103:8080/vertex/user/login";
     NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
     
     // Set the request's content type to application/x-www-form-urlencoded
     [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
     
     // Designate the request a POST request and specify its body data
     [postRequest setHTTPMethod:@"POST"];
     [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:[bodyData length]]];
     
     NSLog(@"%@", postRequest);
     
     // Initialize the NSURLConnection and proceed as usual
     NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
     
     //start the connection
     [connection start];
     
     /* Get Response. Validation before proceeding to next page. Retrieve confirmation from the ws that user is valid
     
     NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
     NSError *error = [[NSError alloc] init];
     NSData *responseData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&urlResponse error:&error];
     NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
     NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
     //NSString *loginProceed = [[json objectForKey:@"message"] objectForKey:@"valid"];
     //NSString *loginProceed = [json objectForKey:@"valid"];
     //BOOL *loginFlag = (BOOL)loginProceed;
     NSString *loginProceed = [json objectForKey:@"valid"];
     
     NSLog(@"Response code- %ld",(long)[urlResponse statusCode]);
     NSLog(@"Login Response: %@", result);
     NSLog(@"Response JSON: %@", json);
     NSLog(@"Login Response JSON: %@", loginProceed);
     
     if(true)
     //if([loginProceed isEqualToString:@"1"])
     {
     //Segue to Home Page
     [self performSegueWithIdentifier: @"loginToHome" sender: self];
     }
     //else if([loginProceed isEqual: @"false"])
     else
     {
     UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Invalid User"
     message:@"Username and password is incorrect."
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [loginAlert show];
     }
     */
  }
  else
  {
    NSLog(@"Unable to login");
  }
}

//Login fields validation
-(BOOL) validateLoginFields
{
  UIAlertView *loginValidateAlert = [[UIAlertView alloc] initWithTitle:@"Incomplete Information"
                                               message:@"Please fill out all the fields."
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];

  if([userNameField.text isEqualToString:(@"")] || [passwordField.text isEqualToString:(@"")])
  {
    [loginValidateAlert show];
    return false;
  }
  else
  {
    return true;
  }
}

@end
