//
//  EditUserAccountDetailsPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/6/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "EditUserAccountDetailsPageViewController.h"
#import "HomePageViewController.h"
#import "UserAccountConfigurationPageViewController.h"

@interface EditUserAccountDetailsPageViewController ()

@end

@implementation EditUserAccountDetailsPageViewController

@synthesize editUserAccountDetailsScroller;

@synthesize usernameLabel;
@synthesize usernameField;

@synthesize contactInformationLabel;
@synthesize wirelineLabel;
@synthesize wirelineField;
@synthesize wirelessLabel;
@synthesize wirelessField;
@synthesize emailAddressLabel;
@synthesize emailAddressField;
@synthesize addressLabel;
@synthesize addressField;

@synthesize userAccountsPicker;
@synthesize userAccountsPickerArray;
@synthesize userInfoIdArray;
@synthesize actionSheet;
@synthesize users;
@synthesize selectedIndex;

@synthesize userInfoId;
@synthesize userInfo;

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
  NSLog(@"Edit User Account Details Page");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //Configure Scroller size
  self.editUserAccountDetailsScroller.contentSize = CGSizeMake(320, 720);
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEditUserAccountDetails)];
  
  //[Update] navigation button - Update Lifecycle
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(editUserAccountDetails)];
  
  //Populate User Accounts Picker
  [self getUsers];
  
  //userAccountsPicker in addUserAccountsField
  [usernameField setDelegate:self];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Get Users
- (void) getUsers
{
  //Set URL for retrieving Users
  //URL = @"http://192.168.2.13:8080/vertex-api/user/getUsers"; //113
  URL = @"http://192.168.2.113/vertex-api/user/getUsers";
  
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

    NSMutableDictionary *userContactInfo = [[NSMutableDictionary alloc] init];
    userContactInfo = [users valueForKey:@"info"];
    userInfoIdArray = [userContactInfo valueForKey:@"id"]; //array for retrieved userInfoId
    NSLog(@"userInfoIdArray: %@", userInfoIdArray);
  }
}


#pragma mark - Change usernameField to userAccountsPicker when clicked
- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
  if(usernameField.isEditing)
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
    
    usernameField.inputView = actionSheet;
    
    //Clear / init detail fields
    wirelineField.text = @"";
    wirelessField.text = @"";
    emailAddressField.text = @"";
    addressField.text = @"";
    
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
  NSString *username = [userAccountsPickerArray objectAtIndex:selectedIndex];
  usernameField.text = username;
  userInfoId = [userInfoIdArray objectAtIndex:selectedIndex];
  
  //Populate Account Detail Fields
  [self getUserInfo];
}


#pragma mark - [Cancel] button implementation
-(void) cancelEditUserAccountDetails
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Edit User Account Details");
  
  //Go back to Home Page
  HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - getUserInfo
-(void) getUserInfo
{
  //URL = @"http://192.168.2.113/vertex-api/user/getUserInfo/%@";
  
  NSMutableString *urlParams = [NSMutableString
                                stringWithFormat:@"http://192.168.2.113/vertex-api/user/getUserInfo/%@"
                                , userInfoId];
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
    wirelineField.text = @"Demo - 123-456";
    wirelessField.text = @"Demo - 0916-000-0000";
    emailAddressField.text = @"Demo - steve.jobs@apple.com";
    addressField.text = @"Apple Campus, 1 Infinite Loop, Cupertino, California, U.S.";
  }
  else
  {
    //JSON for retrieved userInfo
    userInfo = [NSJSONSerialization
                     JSONObjectWithData:responseData
                     options:kNilOptions
                     error:&error];
    NSLog(@"userInfo JSON: %@", userInfo);
    
    //Array for the contactInfo of the retrieved userInfo
    NSMutableArray *userContactInfo = [[NSMutableArray alloc] init];
    userContactInfo = [userInfo valueForKey:@"contactInfo"];
    NSLog(@"userContactInfo: %@", userContactInfo);
    
    if([userContactInfo count] == 0)
    {
      wirelineField.placeholder     = @"No Entry";
      wirelessField.placeholder     = @"No Entry";
      emailAddressField.placeholder = @"No Entry";
      addressField.placeholder      = @"No Entry";
    }
    else
    {
      for(int i = 0; i < [userContactInfo count]; i++)
      {
        //wireline
        if([[[[userContactInfo objectAtIndex:i] valueForKey:@"contactType"]valueForKey:@"type"] isEqual:@"wireline"])
        {
          wirelineField.text = [[userContactInfo objectAtIndex:i] valueForKey:@"value"];
        }
        //wireless
        else if([[[[userContactInfo objectAtIndex:i] valueForKey:@"contactType"]valueForKey:@"type"] isEqual:@"mobile"])
        {
          wirelessField.text = [[userContactInfo objectAtIndex:i] valueForKey:@"value"];
        }
        //email address
        else if([[[[userContactInfo objectAtIndex:i] valueForKey:@"contactType"]valueForKey:@"type"] isEqual:@"email"])
        {
          emailAddressField.text = [[userContactInfo objectAtIndex:i] valueForKey:@"value"];
        }
        //address
        else if([[[[userContactInfo objectAtIndex:i] valueForKey:@"contactType"]valueForKey:@"type"] isEqual:@"address"])
        {
          addressField.text = [[userContactInfo objectAtIndex:i] valueForKey:@"value"];
        }
      } //end if else [userContactInfo count]
    }//end - for [userContactInfo count]
  }//end - else if (responseData == nil)
}


#pragma mark - Edit User Account Details
-(void) editUserAccountDetails
{
  if([self validateEditUserAccountDetailFields])
  {
    //Set JSON Request
    NSMutableDictionary *editUserAccountDetailsJson = [[NSMutableDictionary alloc] init];
    //[editUserAccountDetailsJson setObject:@"" forKey:@"id"];
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:editUserAccountDetailsJson
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                            encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonData Request: %@", jsonData);
    NSLog(@"jsonString Request: %@", jsonString);
    
    //Set URL for Edit User Account Details
    //TODO
    URL = @"";
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
    
    NSLog(@"editUserAccountDetails - httpResponseCode: %d", httpResponseCode);
    if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
    {
      UIAlertView *editUserAccountDetailsAlert = [[UIAlertView alloc]
                                           initWithTitle:@"Edit User Account Details"
                                           message:@"User account details edited."
                                           delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
      [editUserAccountDetailsAlert show];
    }
    else //(httpResponseCode >= 400)
    {
      UIAlertView *editUserAccountDetailsFailAlert = [[UIAlertView alloc]
                                               initWithTitle:@"Edit User Account Failed"
                                               message:@"User account not edited. Please try again later"
                                               delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
      [editUserAccountDetailsFailAlert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
  }
  else
  {
    NSLog(@"Unable to update User Account Details");
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
-(BOOL) validateEditUserAccountDetailFields
{
  UIAlertView *editUserAccountDetailsValidateAlert = [[UIAlertView alloc]
                                              initWithTitle:@"Incomplete Information"
                                              message:@"Please fill out the necessary fields."
                                              delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
  
  if([usernameField.text isEqualToString:(@"")])
  {
    [editUserAccountDetailsValidateAlert show];
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
  [usernameField resignFirstResponder];
  [wirelineField resignFirstResponder];
  [wirelessField resignFirstResponder];
  [emailAddressField resignFirstResponder];
  [addressField resignFirstResponder];
}



@end
