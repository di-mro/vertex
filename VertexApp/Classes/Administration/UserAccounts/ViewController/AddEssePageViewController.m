//
//  AddEssePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AddEssePageViewController.h"
#import "HomePageViewController.h"
#import "EsseInfoConfigurationPageViewController.h"

@interface AddEssePageViewController ()

@end

@implementation AddEssePageViewController

@synthesize addEsseScroller;

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

@synthesize addEsseJson;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize cancelAddEsseConfirmation;


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
  NSLog(@"Add Esse Page");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                           action:@selector(cancelAddEsse)];
  
  //[Add] navigation button - Add Esse
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(addEsse)];
  
  //Configure Scroller size
  self.addEsseScroller.contentSize = CGSizeMake(320, 720);
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - [Cancel] button implementation
-(void) cancelAddEsse
{
  NSLog(@"Cancel Add Esse");
  
  cancelAddEsseConfirmation = [[UIAlertView alloc]
                                   initWithTitle:@"Cancel Add Esse"
                                         message:@"Are you sure you want to cancel adding this esse?"
                                        delegate:self
                               cancelButtonTitle:@"Yes"
                               otherButtonTitles:@"No", nil];
  
  [cancelAddEsseConfirmation show];
}


#pragma mark - [Add] button implementation - Add Esse
-(void) addEsse
{
  if([self validateAddEsseFields])
  {
    //Set JSON Request
    addEsseJson = [[NSMutableDictionary alloc] init];
    
    //TODO : Construct JSON request body Add Esse
    //[addEsseJson setObject:@"" forKey:@"name"];
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:addEsseJson
                                   options:NSJSONWritingPrettyPrinted
                                     error:&error];
    
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                                encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonData Request: %@", jsonData);
    NSLog(@"jsonString Request: %@", jsonString);
    
    //Set URL for Add Esse
    //TODO : WS Endpoint for add esse
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
    
    NSLog(@"addEsse - httpResponseCode: %d", httpResponseCode);
    if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
    {
      UIAlertView *addEsseAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Add Esse"
                                              message:@"Esse added."
                                             delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
      [addEsseAlert show];
    }
    else //(httpResponseCode >= 400)
    {
      UIAlertView *addEsseFailAlert = [[UIAlertView alloc]
                                            initWithTitle:@"Add Esse Failed"
                                                  message:@"Esse not added. Please try again later"
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
      [addEsseFailAlert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
  }
  else
  {
    NSLog(@"Unable to add esse");
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


#pragma mark - Transition to Esse Info Configuration Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if([alertView isEqual:cancelAddEsseConfirmation])
  {
    NSLog(@"Cancel Add Esse Confirmation");
    if(buttonIndex == 0) //Yes - Cancel
    {
      //Go back to Esse Info Config Page
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


#pragma mark - Login fields validation
-(BOOL) validateAddEsseFields
{
  UIAlertView *addEsseValidateAlert = [[UIAlertView alloc]
                                            initWithTitle:@"Incomplete Information"
                                                  message:@"Please fill out the necessary fields."
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  
  if([lastNameField.text isEqualToString:@""]
     || [firstNameField.text isEqualToString:@""]
     || [middleNameField.text isEqualToString:@""])
  {
    [addEsseValidateAlert show];
    
    return false;
  }
  else
  {
    return true;
  }
}


#pragma mark - Dismiss the onscreen keyboard when not in use
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
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
