//
//  AddUserProfileViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/6/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AddUserProfilePageViewController.h"
#import "HomePageViewController.h"
#import "UserAccountConfigurationPageViewController.h"

@interface AddUserProfilePageViewController ()

@end

@implementation AddUserProfilePageViewController

@synthesize addUserProfileScroller;
@synthesize userProfileNameLabel;
@synthesize userProfileNameField;
@synthesize addUserAccountsLabel;
@synthesize addUserAccountsField;
@synthesize userAccountsTableView;

@synthesize userAccountsArray;
@synthesize userAccountsPicker;
@synthesize userAccountsPickerArray;
@synthesize actionSheet;

@synthesize users;
@synthesize selectedIndex;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize cancelAddUserProfileConfirmation;


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
  NSLog(@"Add User Profile Page");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelAddUserProfile)];
  
  //[Add] navigation button - Add Asset Type
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(addUserProfile)];
  
  //Configure Scroller size
  self.addUserProfileScroller.contentSize = CGSizeMake(320, 720);
  
  //Initialize userAccounts array
  userAccountsArray = [[NSMutableArray alloc] init];
  
  //Populate User Accounts Picker
  [self getUsers];
  
  //userAccountsPicker in addUserAccountsField
  [addUserAccountsField setDelegate:self];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addUserAccount:(id)sender
{
  [userAccountsArray addObject:addUserAccountsField.text];
  
  //To refresh the table view entries
  [userAccountsTableView reloadData];
  
  addUserAccountsField.text = @"";
  
  [addUserAccountsField resignFirstResponder];
}


#pragma mark - Get Users
- (void) getUsers
{
  //Set URL for retrieving AssetTypes
  //URL = @"http://192.168.2.113/vertex-api/user/getUsers";
  URL = @"http://192.168.2.107/vertex-api/user/getUsers";
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:URL]];
  
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [getRequest setHTTPMethod:@"GET"];
  NSLog(@"%@", getRequest);
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:getRequest
                                        delegate:self];
  [connection start];
  
  NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
  NSError *error = [[NSError alloc] init];
  
  //GET
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
                                             delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [connectionAlert show];
    
    //TODO: Connect to CoreData for local data
    //!- FOR TESTING ONLY -!
    self.userAccountsPickerArray = [[NSMutableArray alloc] initWithObjects:
                                      @"Demo - elan-0001"
                                    , @"Demo - elan-0002"
                                    , @"Demo - elan-0003"
                                    , @"Demo - elan-0004"
                                    , @"Demo - elan-0005"
                                    , nil];
  }
  else
  {
    users = [NSJSONSerialization
             JSONObjectWithData:responseData
                        options:kNilOptions
                          error:&error];
    
    NSLog(@"getUsers JSON Result: %@", users);
    
    userAccountsPickerArray = [users valueForKey:@"username"]; //store usernames only in PickerArray
  }
}


#pragma mark - Change addUserAccountsField to userAccountsPicker when clicked
- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
  if(addUserAccountsField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - function call");
    [textField resignFirstResponder];
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    userAccountsPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
    userAccountsPicker.showsSelectionIndicator = YES;
    userAccountsPicker.dataSource = self;
    userAccountsPicker.delegate   = self;
    
    [actionSheet addSubview:userAccountsPicker];
    
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObject:@"Done"]];
    doneButton.momentary = YES;
    doneButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blackColor];
    [doneButton addTarget:self action:@selector(selectedRow) forControlEvents:UIControlEventValueChanged];
    
    [actionSheet addSubview:doneButton];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    addUserAccountsField.inputView = actionSheet;
    
    return YES;
  }
  else
  {
    return NO;
  }
}


#pragma mark - Implementing the Picker View
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return [userAccountsPickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [self.userAccountsPickerArray objectAtIndex:row];
}


#pragma mark - Get the selected row in userAccountsPicker
-(void)selectedRow
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  selectedIndex = [userAccountsPicker selectedRowInComponent:0];
  
  NSString *username        = [userAccountsPickerArray objectAtIndex:selectedIndex];
  addUserAccountsField.text = username;  
}


#pragma mark - [Cancel] button implementation
-(void) cancelAddUserProfile
{
  NSLog(@"Cancel Add User Profile");
  
  cancelAddUserProfileConfirmation = [[UIAlertView alloc]
                                          initWithTitle:@"Cancel Add User Profile"
                                                message:@"Are you sure you want to cancel adding this user profile?"
                                               delegate:self
                                      cancelButtonTitle:@"Yes"
                                      otherButtonTitles:@"No", nil];
  
  [cancelAddUserProfileConfirmation show];
}


#pragma mark - [Add] button implementation - Add User Profile
-(void) addUserProfile
{
  if([self validateAddUserProfileFields])
  {
    //Set JSON Request
    NSMutableDictionary *addUserProfileJson = [[NSMutableDictionary alloc] init];
    
    //TODO : Construct JSON request body User Group Configuration
    //[addUserProfileJson setObject:@"" forKey:@"name"];
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:addUserProfileJson
                                   options:NSJSONWritingPrettyPrinted
                                     error:&error];
    
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                                encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonData Request: %@", jsonData);
    NSLog(@"jsonString Request: %@", jsonString);
    
    //Set URL for User Group Configuration
    //TODO : WS Endpoint for user group config
    URL = @"";
    NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:URL]];
    
    //POST method - Create
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]]];
    NSLog(@"%@", postRequest);
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:postRequest
                                          delegate:self];
    
    [connection start];
    
    NSLog(@"addUserProfile - httpResponseCode: %d", httpResponseCode);
    if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
    {
      UIAlertView *addUserProfileAlert = [[UIAlertView alloc]
                                               initWithTitle:@"Add User Profile"
                                                     message:@"User profile added."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
      [addUserProfileAlert show];
    }
    else //(httpResponseCode >= 400)
    {
      UIAlertView *addUserProfileFailAlert = [[UIAlertView alloc]
                                                   initWithTitle:@"Add User Profile Failed"
                                                         message:@"User profile not added. Please try again later"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
      [addUserProfileFailAlert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
  }
  else
  {
    NSLog(@"Unable to configure user group");
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
  if([alertView isEqual:cancelAddUserProfileConfirmation])
  {
    NSLog(@"Cancel Add User Profile Confirmation");
    if(buttonIndex == 0) //Yes - Cancel
    {
      //Go back to User Account Config Page
      UserAccountConfigurationPageViewController *controller = (UserAccountConfigurationPageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"UserAccountConfigPage"];
      
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
-(BOOL) validateAddUserProfileFields
{
  UIAlertView *addUserProfileValidateAlert = [[UIAlertView alloc]
                                                   initWithTitle:@"Incomplete Information"
                                                         message:@"Please fill out the necessary fields."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
  
  if([userProfileNameField.text isEqualToString:(@"")])
  {
    [addUserProfileValidateAlert show];
    
    return false;
  }
  else
  {
    return true;
  }
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"User Accounts"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [userAccountsArray count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"userAccountsPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text          = [self.userAccountsArray objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  
  return cell;
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
  [userProfileNameField resignFirstResponder];
  [addUserAccountsField resignFirstResponder];
}


@end
