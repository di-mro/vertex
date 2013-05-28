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
  //URL = @"http://192.168.2.113/vertex-api/user/login";
  //URL = @"http://192.168.2.107/vertex-api/user/login";
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
  
  //Get User Profile Id and other details
  [self getUserInfo];

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
  
  //~ Write responseDate to file
  NSLog(@"Login - userInfo Response data: %@", responseData);
  
  NSString *loggedUserInfo = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
  NSLog(@"loggedUserInfo: %@", loggedUserInfo);
  
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
    
    //Get info for SQLite storage
    userId        = [userInfo valueForKey:@"id"];
    username      = [userInfo valueForKey:@"username"];
    password      = passwordField.text;
    userProfileId = [[userInfo valueForKey:@"profile"] valueForKey:@"id"];
    userInfoId    = [[userInfo valueForKey:@"info"] valueForKey:@"id"];
    //token - assigned in login()
    
    //Create SQLite db
    [self openDB];
    
    [self createTable:@"user_accounts"
           withField1:@"userId"
           withField2:@"username"
           withField3:@"password"
           withField4:@"profileId"
           withField5:@"userInfoId"
           withField6:@"token"];
    
    //Save info in SQLite
    [self saveUserInfo];
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
  
  /*
  //POST
  if(httpResponseCode == 200) //ok
  {
    [self performSegueWithIdentifier: @"loginToHome" sender: self];
  }
  else //(httpResponseCode >= 400)
  {
    UIAlertView *loginAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Invalid User"
                                         message:@"Username and password is incorrect."
                                        delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [loginAlert show];
  }
   */
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

#pragma mark - SQLite Operations
#pragma mark - Create user_accounts table
-(void) createTable: (NSString *) tableName //user_accounts
         withField1: (NSString *) field1 //userId
         withField2: (NSString *) field2 //username
         withField3: (NSString *) field3 //password
         withField4: (NSString *) field4 //profileId
         withField5: (NSString *) field5 //userInfoId
         withField6: (NSString *) field6 //token
{
  char *err;
  NSString *sql = [NSString stringWithFormat:
                   @"CREATE TABLE IF NOT EXISTS '%@' ('%@' " "NUM PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' NUM, '%@' NUM, '%@' TEXT);"
                   , tableName
                   , field1
                   , field2
                   , field3
                   , field4
                   , field5
                   , field6];
  
  if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSLog(@"Could not create table");
  }
  else
  {
    NSLog(@"Table Created");
  }
}

#pragma mark - Set file path to db
-(NSString *) getFilePath
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
  return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"di_vertex.sql"];
}

#pragma mark - Open the db
-(void) openDB
{
  if(sqlite3_open([[self getFilePath] UTF8String], &db) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSLog(@"Database failed to open");
  }
  else
  {
    NSLog(@"Database opened");
  }
}

#pragma mark - Collect User Accounts data from response parameter and save to db
-(void) saveUserInfo
{
  //Truncate user_accounts first to remove unecessary info, only save info for the logged user
  //[self truncateUserAccounts];
  
  NSString *sql = [NSString stringWithFormat:@"INSERT INTO user_accounts ('userId', 'username', 'password', 'profileId', 'userInfoId', 'token') VALUES ('%@', '%@', '%@', '%@', '%@', '%@')"
                   , userId
                   , username
                   , password
                   , userProfileId
                   , userInfoId
                   , token];
  
  char *err;
  if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSLog(@"Could not update the table");
  }
  else
  {
    NSLog(@"Table Updated");
  }
}

#pragma mark - Truncate user_accounts table
-(void) truncateUserAccounts
{
  char *err;
  NSString *sql = [NSString stringWithFormat:@"DELETE FROM user_accounts"];
  
  if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSLog(@"Could not truncate user_accounts table");
  }
  else
  {
    NSLog(@"user_accounts table truncated");
  }
}



#pragma mark - Prepare for segue, passing the userProfileId to Home Page
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"loginToHome"])
  {
    [segue.destinationViewController setUserProfileId:userProfileId];
  }
}


@end
