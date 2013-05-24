//
//  AddLifecyclePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 3/30/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AddLifecyclePageViewController.h"
#import "HomePageViewController.h"
#import "LifecycleConfigurationPageViewController.h"

@interface AddLifecyclePageViewController ()

@end

@implementation AddLifecyclePageViewController

@synthesize addLifecycleScroller;
@synthesize lifecycleNameLabel;
@synthesize lifecycleNameField;
@synthesize lifecycleDescriptionLabel;
@synthesize lifecycleDescriptionField;
@synthesize lifecyclePreviousLabel;
@synthesize lifecyclePreviousField;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize cancelAddLifecycleConfirmation;


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
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //Configure Scroller size
  self.addLifecycleScroller.contentSize = CGSizeMake(320, 720);
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelAddLifecycle)];
  
  //[Add] navigation button - Add Lifecycle
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(addLifecycle)];
    
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - [Cancel] button implementation
-(void) cancelAddLifecycle
{
  NSLog(@"Cancel Add Lifecycle");
  
  cancelAddLifecycleConfirmation = [[UIAlertView alloc]
                                    initWithTitle:@"Cancel Add Lifecycle"
                                    message:@"Are you sure you want to cancel adding this lifecycle?"
                                    delegate:self
                                    cancelButtonTitle:@"Yes"
                                    otherButtonTitles:@"No", nil];
  
  [cancelAddLifecycleConfirmation show];
}


#pragma mark - Add Lifecycle
-(void) addLifecycle
{
  if([self validateAddLifecycleFields])
  {
    //Set JSON Request
    NSMutableDictionary *addLifecycleJson = [[NSMutableDictionary alloc] init];
    [addLifecycleJson setObject:lifecycleNameField.text forKey:@"name"];
    [addLifecycleJson setObject:lifecycleDescriptionField.text forKey:@"description"];
    [addLifecycleJson setObject:lifecyclePreviousField.text forKey:@"prev"];
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:addLifecycleJson
                                   options:NSJSONWritingPrettyPrinted
                                     error:&error];
    
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                                encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonData Request: %@", jsonData);
    NSLog(@"jsonString Request: %@", jsonString);
    
    //Set URL for Add Lifecycle
    //URL = @"http://192.168.2.113/vertex-api/lifecycle/addLifecycle";
    URL = @"http://192.168.2.107/vertex-api/lifecycle/addLifecycle";
    
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
    
    NSLog(@"addLifecycle - httpResponseCode: %d", httpResponseCode);
  }
  else
  {
    NSLog(@"Unable to add lifecycle");
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
  
  if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
  {
    UIAlertView *addLifecycleAlert = [[UIAlertView alloc]
                                          initWithTitle:@"Add Lifecycle"
                                                message:@"Lifecycle Added."
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    [addLifecycleAlert show];
  }
  else //(httpResponseCode >= 400)
  {
    UIAlertView *addLifecycleFailAlert = [[UIAlertView alloc]
                                              initWithTitle:@"Add Lifecycle Failed"
                                                    message:@"Lifecycle not added. Please try again later"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [addLifecycleFailAlert show];
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Add Lifecycle");
}


#pragma mark - Transition to Lifecycle Configuration Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if([alertView isEqual:cancelAddLifecycleConfirmation])
  {
    NSLog(@"Cancel Add Lifecycle Confirmation");
    if(buttonIndex == 0) //Yes - Cancel
    {
      //Go back to SR Page
      LifecycleConfigurationPageViewController *controller = (LifecycleConfigurationPageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"LifecycleConfigPage"];
      
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
-(BOOL) validateAddLifecycleFields
{
  UIAlertView *addLifeycleValidateAlert = [[UIAlertView alloc]
                                               initWithTitle:@"Incomplete Information"
                                                     message:@"Please fill out the necessary fields."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
  
  if([lifecycleNameField.text isEqualToString:(@"")]
     || [lifecycleDescriptionField.text isEqualToString:(@"")]
     || [lifecyclePreviousField.text isEqualToString:(@"")])
  {
    [addLifeycleValidateAlert show];
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
  [lifecycleNameField resignFirstResponder];
  [lifecycleDescriptionField resignFirstResponder];
  [lifecyclePreviousField resignFirstResponder];
}


@end
