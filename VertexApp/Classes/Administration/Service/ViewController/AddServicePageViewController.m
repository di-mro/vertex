//
//  AddServicePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/2/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AddServicePageViewController.h"
#import "HomePageViewController.h"
#import "ServiceConfigurationPageViewController.h"

@interface AddServicePageViewController ()

@end

@implementation AddServicePageViewController

@synthesize addServiceScroller;
@synthesize assetTypeLabel;
@synthesize assetTypeField;
@synthesize lifecycleLabel;
@synthesize lifecycleField;
@synthesize serviceLabel;
@synthesize serviceField;

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
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //Configure Scroller size
  self.addServiceScroller.contentSize = CGSizeMake(320, 720);
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAddService)];
  
  //[Add] navigation button - Add Lifecycle
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addService)];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - [Cancel] button implementation
-(void) cancelAddService
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Add Service");
  
  //Go back to Home Page
  HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Add Service
-(void) addService
{
  if([self validateAddServiceFields])
  {
    //Set JSON Request
    NSMutableDictionary *addServiceJson = [[NSMutableDictionary alloc] init];
    [addServiceJson setObject:assetTypeField.text forKey:@""];
    [addServiceJson setObject:lifecycleField.text forKey:@""];
    [addServiceJson setObject:serviceField.text forKey:@""];
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:addServiceJson
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                            encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonData Request: %@", jsonData);
    NSLog(@"jsonString Request: %@", jsonString);
    
    //Set URL for Add Service
    //URL = @"http://192.168.2.113:8080/vertex-api/service/addServices";
    URL = @"http://192.168.2.113/vertex-api/service/addServices";
    
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
    
    NSLog(@"addService - httpResponseCode: %d", httpResponseCode);
    //***
  }
  else
  {
    NSLog(@"Unable to add service");
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
    UIAlertView *addServiceAlert = [[UIAlertView alloc]
                                      initWithTitle:@"Add Service"
                                      message:@"Service Added."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    [addServiceAlert show];
  }
  else //(httpResponseCode >= 400)
  {
    UIAlertView *addServiceAlert = [[UIAlertView alloc]
                                          initWithTitle:@"Add Service Failed"
                                          message:@"Service not added. Please try again later"
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [addServiceAlert show];
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Add Service");
}


#pragma mark - Transition to Assets Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0)
  {
    ServiceConfigurationPageViewController *controller = (ServiceConfigurationPageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ServiceConfigPage"];
    
    [self.navigationController pushViewController:controller animated:YES];
  }
}


#pragma mark - Login fields validation
-(BOOL) validateAddServiceFields
{
  UIAlertView *addServiceValidateAlert = [[UIAlertView alloc]
                                           initWithTitle:@"Incomplete Information"
                                           message:@"Please fill out the necessary fields."
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
  
  if([assetTypeField.text isEqualToString:(@"")]
     || [lifecycleField.text isEqualToString:(@"")]
     || [serviceField.text isEqualToString:(@"")])
  {
    [addServiceValidateAlert show];
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
  [assetTypeField resignFirstResponder];
  [lifecycleField resignFirstResponder];
  [serviceField resignFirstResponder];
}

@end
