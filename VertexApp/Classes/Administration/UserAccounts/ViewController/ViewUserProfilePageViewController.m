//
//  ViewUserProfilePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ViewUserProfilePageViewController.h"
#import "HomePageViewController.h"
#import "UserAccountConfigurationPageViewController.h"


@interface ViewUserProfilePageViewController ()

@end

@implementation ViewUserProfilePageViewController

@synthesize viewUserProfileScroller;
@synthesize userProfileNameLabel;
@synthesize userProfileNameField;
@synthesize userProfileUserAccountsLabel;

@synthesize userProfileUserAccountsTableView;
@synthesize userProfileNamePicker;
@synthesize userProfilePickerArray;
@synthesize actionSheet;
@synthesize userProfileUserAccountsArray;

@synthesize userProfiles;
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
  NSLog(@"View User Profile Page");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelViewUserProfile)];
  
  //Configure Scroller size
  self.viewUserProfileScroller.contentSize = CGSizeMake(320, 720);
  
  //Populate User Profile Picker
  [self getUserProfiles];
  
  //userProfilePicker in userProfileNameField
  [userProfileNameField setDelegate:self];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Get User Profiles
- (void) getUserProfiles
{
  //Set URL for retrieving userProfiles
  URL = @"";
  
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
    self.userProfilePickerArray = [[NSMutableArray alloc] initWithObjects:@"Demo - admin",@"Demo - engineering", @"Demo - maintenance", @"Demo - dwellers_38", nil];
  }
  else
  {
    userProfiles = [NSJSONSerialization
             JSONObjectWithData:responseData
             options:kNilOptions
             error:&error];
    NSLog(@"get JSON Result: %@", userProfiles);
    
    userProfilePickerArray = [userProfiles valueForKey:@"username"]; //store usernames only in PickerArray
    NSLog(@"userProfilePickerArray: %@", userProfilePickerArray);
  }
}


#pragma mark - Change addUserAccountsField to userAccountsPicker when clicked
- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
  if(userProfileNameField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - function call");
    [textField resignFirstResponder];
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    userProfileNamePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
    userProfileNamePicker.showsSelectionIndicator = YES;
    userProfileNamePicker.dataSource = self;
    userProfileNamePicker.delegate = self;
    
    [actionSheet addSubview:userProfileNamePicker];
    
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObject:@"Done"]];
    doneButton.momentary = YES;
    doneButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blackColor];
    [doneButton addTarget:self action:@selector(selectedRow) forControlEvents:UIControlEventValueChanged];
    
    [actionSheet addSubview:doneButton];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    userProfileNameField.inputView = actionSheet;
    
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
  return [userProfilePickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [self.userProfilePickerArray objectAtIndex:row];
}


#pragma mark - Get the selected row in userAccountsPicker
-(void)selectedRow
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  selectedIndex = [userProfileNamePicker selectedRowInComponent:0];
  NSString *username = [userProfilePickerArray objectAtIndex:selectedIndex];
  userProfileNameField.text = username;
  
  //pass id of selected profile ???
  [self getUserProfileUserAccounts];
}


#pragma mark - Get UserAccounts associated with the chosen UserProfile
-(void) getUserProfileUserAccounts //: (NSNumber *) userProfileId // >>???
{
  //TEST ONLY
  //Replace with getting userAccounts associated with the userProfile
  userProfileUserAccountsArray = [[NSMutableArray alloc] initWithObjects:@"DEMO-elan-38-01-1", @"DEMO-elan-38-02-2", @"DEMO-elan-38-03-3", nil];
  [userProfileUserAccountsTableView reloadData];
}


#pragma mark - [Cancel] button implementation
-(void) cancelViewUserProfile
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel View User Profile");
  
  //Go back to Home Page
  HomePageViewController *controller = (HomePageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
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
  return [userProfileUserAccountsArray count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"viewUserProfileUserAccountsPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.userProfileUserAccountsArray objectAtIndex:indexPath.row];
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
}




@end
