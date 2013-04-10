//
//  UserGroupConfigurationPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/5/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "UserGroupConfigurationPageViewController.h"
#import "HomePageViewController.h"
#import "UserAccountConfigurationPageViewController.h"


@interface UserGroupConfigurationPageViewController ()

@end

@implementation UserGroupConfigurationPageViewController

@synthesize userGroupConfigScroller;
@synthesize userGroupNameLabel;
@synthesize userGroupNameField;
@synthesize addUserAccountsLabel;
@synthesize addUserAccountsField;
@synthesize addUserAccountsTableView;
@synthesize userAccountsArray;

@synthesize userAccountsPicker;
@synthesize userAccountsPickerArray;
@synthesize actionSheet;

@synthesize users;
@synthesize selectedIndex;

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
  NSLog(@"User Group Configuration Page");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelUserGroupConfig)];
  
  //[Add] navigation button - Add Asset Type
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(configureUserGroup)];
  
  //Configure Scroller size
  self.userGroupConfigScroller.contentSize = CGSizeMake(320, 720);
  
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

- (IBAction)addUserAccounts:(id)sender
{
  [userAccountsArray addObject:addUserAccountsField.text];
  NSLog(@"userAccountsArray: %@", userAccountsArray);
  
  [addUserAccountsTableView reloadData];
  addUserAccountsField.text = @"";
  [addUserAccountsField resignFirstResponder];
}


#pragma mark - Get Users
- (void) getUsers
{
  //Set URL for retrieving AssetTypes
  URL = @"http://192.168.2.13:8080/vertex-api/user/getUsers"; //113
  
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
    self.userAccountsPickerArray = [[NSMutableArray alloc] initWithObjects:@"Demo - elan-0001",@"Demo - elan-0002", @"Demo - elan-0003", @"Demo - elan-0004", @"Demo - elan-0005", nil];
  }
  else
  {
    users = [NSJSONSerialization
                  JSONObjectWithData:responseData
                  options:kNilOptions
                  error:&error];
    NSLog(@"getUsers JSON Result: %@", users);
    
    userAccountsPickerArray = [users valueForKey:@"username"]; //store usernames only in PickerArray
    NSLog(@"userAccountsPickerArray: %@", userAccountsPickerArray);
  }
}


#pragma mark - Change assetTypeField to assetTypePicker when clicked
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
    userAccountsPicker.delegate = self;
    
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


#pragma mark - Get the selected row in assetTypePicker
-(void)selectedRow
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  selectedIndex = [userAccountsPicker selectedRowInComponent:0];
  NSString *username = [userAccountsPickerArray objectAtIndex:selectedIndex];
  addUserAccountsField.text = username;
  
  /*
  NSMutableArray *userIdArray = [[NSMutableArray alloc] init];
  userIdArray = [users valueForKey:@"id"];
  
  selectedAssetTypeId = [assetTypeIdArray objectAtIndex:selectedIndex];
  NSLog(@"selectedRow-selectedAssetTypeId: %@", selectedAssetTypeId);
  //selectedAssetTypeId = @111000; //TEST only
  [self setAttributesField];
   */
}



#pragma mark - [Cancel] button implementation
-(void) cancelUserGroupConfig
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel User Group Configuration");
  
  //Go back to Home Page
  HomePageViewController *controller = (HomePageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - User Group Configuration
-(void) configureUserGroup
{
  if([self validateUserGroupConfigFields])
  {
    //Set JSON Request
    NSMutableDictionary *userGroupConfigJson = [[NSMutableDictionary alloc] init];
    //TODO : Construct JSON request body User Group Configuration
    //[userGroupConfigJson setObject:@"" forKey:@"name"];
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:userGroupConfigJson
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
    
    NSLog(@"configureUserGroup - httpResponseCode: %d", httpResponseCode);
    if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
    {
      UIAlertView *userGroupConfigAlert = [[UIAlertView alloc]
                                           initWithTitle:@"User Group Configuration"
                                           message:@"User group configured."
                                           delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
      [userGroupConfigAlert show];
    }
    else //(httpResponseCode >= 400)
    {
      UIAlertView *userGroupConfigFailAlert = [[UIAlertView alloc]
                                               initWithTitle:@"User Group Configuration Failed"
                                               message:@"User group not configured. Please try again later"
                                               delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
      [userGroupConfigFailAlert show];
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
  httpResponse = (NSHTTPURLResponse *)response;
  httpResponseCode = [httpResponse statusCode];
  NSLog(@"httpResponse status code: %d", httpResponseCode);
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
-(BOOL) validateUserGroupConfigFields
{
  UIAlertView *userGroupConfigValidateAlert = [[UIAlertView alloc]
                                            initWithTitle:@"Incomplete Information"
                                            message:@"Please fill out the necessary fields."
                                            delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
  
  if([userGroupNameField.text isEqualToString:(@"")])
  {
    [userGroupConfigValidateAlert show];
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
  NSLog(@"%d", [userAccountsArray count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"userAccountsPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.userAccountsArray objectAtIndex:indexPath.row];
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
  [userGroupNameField resignFirstResponder];
  [addUserAccountsField resignFirstResponder];
}


@end
