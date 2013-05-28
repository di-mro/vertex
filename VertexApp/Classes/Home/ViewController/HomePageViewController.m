//
//  HomePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/13/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "HomePageViewController.h"
#import "LoginViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

@synthesize homePageEntries;
@synthesize homePageIcons;

@synthesize userProfileId;

@synthesize systemFunctionsInfo;

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
  NSLog(@"Home Page View");

  //[Logout] button initialization
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(logout)];
  
  //Get userProfileId from SQLite
  [self retrieveInfoFromDB];

  //System Function Hierarchies
  [self getSystemFunctions];

  //Manual setting of System Functions - Backup only
  //[self displayHomePageEntries];

  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Set Profile ID to the logged userProfileId
- (void) setUserProfileId:(NSNumber *) idFromLogin
{
  if (idFromLogin == NULL)
  {
    [self displayHomePageEntries];
  }
  else
  {
    userProfileId = idFromLogin;
    NSLog(@"HomePage - userProfileId: %@", userProfileId);
  }
}


#pragma mark - System Function Hierarchies
- (void) getSystemFunctions
{
  NSMutableString *urlParams = [NSMutableString stringWithFormat:@"http://192.168.2.113/vertex-api/user/system-function/getSystemFunctionsByProfile/%@", userProfileId];
  
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
    UIAlertView *systemFunctionAlert = [[UIAlertView alloc]
                               initWithTitle:@"No Connection Detected"
                               message:@"Displaying data from phone cache"
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [systemFunctionAlert show];
    
    [self performSegueWithIdentifier: @"loginToHome" sender: self];
  }
  else
  {
    systemFunctionsInfo = [NSJSONSerialization
                           JSONObjectWithData:responseData
                           options:kNilOptions
                           error:&error];
    
    NSLog(@"systemFunctionsInfo JSON Result: %@", systemFunctionsInfo);
    
    //!!! TODO - How to determine if submenu ???
    homePageEntries = [[NSMutableArray alloc] init];
    
    //!!! TODO - For admin view only
    for (int i = 0; i < 8; i++)
    {
      [homePageEntries addObject:[[systemFunctionsInfo valueForKey:@"name"] objectAtIndex:i]];
    }
  }
  
  NSLog(@"homePageEntries: %@", homePageEntries);
  
  homePageIcons = [[NSMutableArray alloc] initWithObjects: @"notification_icon.png"
                   , @"service_request_icon.png"
                   , @"asset_icon.png"
                   , @"billing_icon.png"
                   , @"reports_icon.png"
                   , @"administration_icon.png"
                   , @"schedule_icon.png"
                   , @"settings_icon.png"
                   , nil];
  
}


# pragma mark - Display entries in Home Page
- (void) displayHomePageEntries
{
  homePageEntries = [[NSMutableArray alloc] init];

  NSString *entry1 = @" Notification";
  NSString *entry2 = @" Service Request";
  NSString *entry3 = @" Asset";
  NSString *entry4 = @" Billing";
  NSString *entry5 = @" Reports";
  NSString *entry6 = @" Administration";
  NSString *entry7 = @" Schedule";
  NSString *entry8 = @" Settings";
  
  [homePageEntries addObject:entry1];
  [homePageEntries addObject:entry2];
  [homePageEntries addObject:entry3];
  [homePageEntries addObject:entry4];
  [homePageEntries addObject:entry5];
  [homePageEntries addObject:entry6];
  [homePageEntries addObject:entry7];
  [homePageEntries addObject:entry8];
  
  
  homePageIcons = [[NSMutableArray alloc] initWithObjects: @"notification_icon.png"
                                                         , @"service_request_icon.png"
                                                         , @"asset_icon.png"
                                                         , @"billing_icon.png"
                                                         , @"reports_icon.png"
                                                         , @"administration_icon.png"
                                                         , @"schedule_icon.png"
                                                         , @"settings_icon.png"
                                                         , nil];
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Menu"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [homePageEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"homePageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  
  cell.textLabel.text          = [self.homePageEntries objectAtIndex:indexPath.row];
  cell.imageView.image         = [UIImage imageNamed:(NSString*)[self.homePageIcons objectAtIndex:indexPath.row]];
  cell.textLabel.numberOfLines = 0;
  
  return cell;
}

//Change the Height of the Cell [Default is 45]:
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  return 50;
}


#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row)
  {
    //Notifications
    case 0: [self performSegueWithIdentifier:@"homeToNotices" sender:self];
      break;
    //Service Request
    case 1: [self performSegueWithIdentifier:@"homeToServiceRequest" sender:self];
      break;
    //Asset
    case 2: [self performSegueWithIdentifier:@"homeToAssets" sender:self];
      break;
    //Billing
    case 3: [self performSegueWithIdentifier:@"homeToBilling" sender:self];
      break;
    //Reports
    case 4: [self performSegueWithIdentifier:@"homeToReports" sender:self];
      break;
    //Administration
    case 5: [self performSegueWithIdentifier:@"homeToAdmin" sender:self];
      break;
    //Schedule
    case 6: [self performSegueWithIdentifier:@"homeToSchedule" sender:self];
      break;
    //Settings
    case 7: [self performSegueWithIdentifier:@"homeToSettings" sender:self];
      break;
    default: break;
  }
}


#pragma mark - [Logout] button logic implementation
-(void) logout
{
  NSLog(@"Logout");
  
  //Go back to Login Page
  LoginViewController* controller = (LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
   
  controller.navigationItem.hidesBackButton = YES;
  [self.navigationController pushViewController:controller animated:YES];
   
  /* !- TODO -!
   Clear user tokens/objects when [Logout] is pressed
   */
  
  /*
  URL = @"http://192.168.2.113/vertex-api/auth/logout";
  
  NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                      requestWithURL:[NSURL URLWithString:URL]];
  
  //POST method
  //!!! TODO - Pass tokens
  [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [postRequest setHTTPMethod:@"POST"];
  NSLog(@"%@", postRequest);
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:postRequest
                                 delegate:self];
  [connection start];
  
  NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
  NSError *error = [[NSError alloc] init];
  
  NSData *responseData = [NSURLConnection
                          sendSynchronousRequest:postRequest
                          returningResponse:&urlResponse
                          error:&error];
  
  NSLog(@"logout - httpResponseCode: %d", httpResponseCode);
  if((httpResponseCode == 201) || (httpResponseCode == 200)) //Logout successful
  {
    //Go back to Login Page
    LoginViewController* controller = (LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
    
    controller.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:controller animated:YES];
  }
  else //(httpResponseCode >= 400)
  {
    UIAlertView *logoutAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Logout Unsuccessful"
                                         message:@"Could not logout user. Please try again later."
                                         delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [logoutAlert show];
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
   */
  
  //Truncate SQLite tables
  [self truncateUserAccounts];
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


#pragma mark - SQLite operations
#pragma mark - Retrieve logged user account information
-(void) retrieveInfoFromDB
{
  [self openDB];
  
  //user_accounts table only stores the information for the current logged user
  //NSString *sql = [NSString stringWithFormat:@"SELECT * FROM user_accounts WHERE userProfileId=%@", userProfileId];
  NSString *sql = [NSString stringWithFormat:@"SELECT * FROM user_accounts"];
  sqlite3_stmt *statement;
  
  if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
  {
    //NSLog(@"statement: %@", statement);
    while(sqlite3_step(statement) == SQLITE_ROW)
    {
      //userId
      char *field1 = (char *) sqlite3_column_text(statement, 0);
      NSString *userId = [[NSString alloc] initWithUTF8String:field1];
      NSLog(@"userId: %@", userId);
      
      //username
      char *field2 = (char *) sqlite3_column_text(statement, 1);
      NSString *username = [[NSString alloc] initWithUTF8String:field2];
      NSLog(@"username: %@", username);
      
      //password
      char *field3 = (char *) sqlite3_column_text(statement, 2);
      NSString *password = [[NSString alloc] initWithUTF8String:field3];
      NSLog(@"password: %@", password);
      
      //profileId
      char *field4 = (char *) sqlite3_column_text(statement, 3);
      NSString *profileIdString = [[NSString alloc] initWithUTF8String:field4];
      userProfileId = profileIdString;
      NSLog(@"userProfileId: %@", userProfileId);
      
      //userInfoId
      char *field5 = (char *) sqlite3_column_text(statement, 4);
      NSString *userInfoId = [[NSString alloc] initWithUTF8String:field5];
      NSLog(@"userInfoId: %@", userInfoId);
      
      //token
      char *field6 = (char *) sqlite3_column_text(statement, 5);
      NSString *token = [[NSString alloc] initWithUTF8String:field6];
      NSLog(@"token: %@", token);
    }
  }
}

#pragma mark - Truncate user_accounts table upon logout
-(void) truncateUserAccounts
{
  char *err;
  NSString *sql = [NSString stringWithFormat:@"DELETE FROM user_accounts"];
  
  if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSLog(@"user_accounts table failed to truncate");
  }
  else
  {
    NSLog(@"user_accounts table truncated");
  }
}

#pragma mark - Get file path to db
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



@end
