//
//  UpdateEssePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/12/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "UpdateEssePageViewController.h"
#import "HomePageViewController.h"
#import "EsseInfoConfigurationPageViewController.h"


@interface UpdateEssePageViewController ()

@end

@implementation UpdateEssePageViewController

@synthesize updateEsseScroller;

@synthesize lastNameLabel;
@synthesize lastNameField;
@synthesize firstNameLabel;
@synthesize firstNameField;
@synthesize middleNameLabel;
@synthesize middleNameField;

@synthesize contactInformationLabel;
@synthesize wirelineLabel;
@synthesize wirelineField;
@synthesize wirelessLabel;
@synthesize wirelessField;
@synthesize emailAddressLabel;
@synthesize emailAddressField;
@synthesize addressLabel;
@synthesize addressField;

@synthesize esseId;
@synthesize esseInfo;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize cancelUpdateEsseConfirmation;


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
  NSLog(@"Update Esse Page View");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //Configure Scroller size
  self.updateEsseScroller.contentSize = CGSizeMake(320, 720);
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelUpdateEsse)];
  
  //[Update] navigation button - Update Esse
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(updateEsse)];
  
  //Get info for the selected Esse
  [self getEsseInfo];

  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Set Esse ID to the selected esseId from previous page
- (void) setEsseId:(NSNumber *) esseIdFromPrev
{
  esseId = esseIdFromPrev;
  NSLog(@"Update Esse Page View Controller - esseId: %@", esseId);
}


#pragma mark - [Cancel] button implementation
-(void) cancelUpdateEsse
{
  NSLog(@"Cancel Update Esse");
  
  cancelUpdateEsseConfirmation = [[UIAlertView alloc]
                                      initWithTitle:@"Cancel Esse Update"
                                            message:@"Are you sure you want to cancel updating this esse?"
                                           delegate:self
                                  cancelButtonTitle:@"Yes"
                                  otherButtonTitles:@"No", nil];
  
  [cancelUpdateEsseConfirmation show];
}


#pragma mark - Get chosen esse info
-(void) getEsseInfo
{
  //TODO : WS Endpoint for getEsseInfo
  URL = @"";
  //@"http://192.168.2.113/vertex-api/user/esse/getEsseInfo/%@
  //@"http://192.168.2.107/vertex-api/user/esse/getEsseInfo/%@
  
  //! TEST
  NSMutableString *urlParams = [NSMutableString
                                stringWithFormat:@"%@"
                                , esseId];
  
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
                                             delegate:nil //TEST ~ ~ ~
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [connectionAlert show];
    
    //TODO: Retrieve local records from CoreData
    //TEST DATA ONLY
    lastNameField.text     = @"Demo - Jobs";
    firstNameField.text    = @"Demo - Steven";
    middleNameField.text   = @"Demo - Paul";
    wirelineField.text     = @"Demo - 123 456";
    wirelessField.text     = @"Demo - 09110000000";
    emailAddressField.text = @"Demo - steve.jobs@apple.com";
    addressField.text      = @"Demo - Apple Campus, Infinite Loop, California";

  }
  else
  {
    //JSON
    esseInfo = [NSJSONSerialization
                JSONObjectWithData:responseData
                           options:kNilOptions
                             error:&error];
    
    NSLog(@"esseInfo JSON: %@", esseInfo);
    
    //TODO : JSON members key
    lastNameField.text     = [esseInfo objectForKey:@"lastName"];
    firstNameField.text    = [esseInfo objectForKey:@"firstName"];
    middleNameField.text   = [esseInfo objectForKey:@"middleName"];
    wirelineField.text     = [esseInfo objectForKey:@""];
    wirelessField.text     = [esseInfo objectForKey:@""];
    emailAddressField.text = [esseInfo objectForKey:@""];
    addressField.text      = [esseInfo objectForKey:@""];
    
  }//end - else if (responseData == nil)
}


#pragma mark - Update Esse
-(void) updateEsse
{
  if([self validateUpdateEsseFields])
  {
    //Set JSON Request
    NSMutableDictionary *updateEsseJson = [[NSMutableDictionary alloc] init];
    //TODO : Construct JSON request for Update Esse
    //[updateEsseJson setObject:@"" forKey:@""];
    
    NSError *error   = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:updateEsseJson
                                   options:NSJSONWritingPrettyPrinted
                                     error:&error];
    
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                                encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonData Request: %@", jsonData);
    NSLog(@"jsonString Request: %@", jsonString);
    
    //Set URL for Update Esse
    //TODO : WS Endpoint for Update Esse
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
    
    NSLog(@"updateEsse - httpResponseCode: %d", httpResponseCode);
    if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
    {
      UIAlertView *updateEsseAlert = [[UIAlertView alloc]
                                          initWithTitle:@"Update Esse"
                                                message:@"Esse Updated."
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
      [updateEsseAlert show];
    }
    else //(httpResponseCode >= 400)
    {
      UIAlertView *updateEsseFailAlert = [[UIAlertView alloc]
                                              initWithTitle:@"Update Esse Failed"
                                                    message:@"Esse not updated. Please try again later"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
      [updateEsseFailAlert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
  }
  else
  {
    NSLog(@"Unable to update esse");
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
  if([alertView isEqual:cancelUpdateEsseConfirmation])
  {
    NSLog(@"Cancel Update Esse Confirmation");
    if(buttonIndex == 0) //Yes - Cancel
    {
      //Go back to Esse Config Page
      EsseInfoConfigurationPageViewController *controller = (EsseInfoConfigurationPageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"EsseInfoConfigPage"];
      
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


#pragma mark - Esse fields validation
-(BOOL) validateUpdateEsseFields
{
  UIAlertView *updateEsseValidateAlert = [[UIAlertView alloc]
                                              initWithTitle:@"Incomplete Information"
                                                    message:@"Please fill out the necessary fields."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
  
  if([lastNameField.text isEqualToString:@""]
       || [firstNameField.text isEqualToString:@""]
       || [middleNameField.text isEqualToString:@""])
  {
    [updateEsseValidateAlert show];
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
  [lastNameField resignFirstResponder];
  [firstNameField resignFirstResponder];
  [middleNameField resignFirstResponder];
  [wirelineField resignFirstResponder];
  [wirelessField resignFirstResponder];
  [emailAddressField resignFirstResponder];
  [addressField resignFirstResponder];
}



@end
