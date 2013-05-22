//
//  CreateNoticePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/3/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "CreateNoticePageViewController.h"
#import "HomePageViewController.h"
#import "NoticesViewController.h"

@interface CreateNoticePageViewController ()

@end

@implementation CreateNoticePageViewController

@synthesize createNoticeScroller;

@synthesize messageLabel;
@synthesize messageTextArea;
@synthesize priorityLevelLabel;
@synthesize priorityLevelField;
@synthesize userGroupNameLabel;
@synthesize userGroupNameField;
@synthesize validityLabel;
@synthesize validityField;

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
  NSLog(@"Create Notice Page");
  
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelCreateNotice)];
  
  //[Create] navigation button
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(createNotice)];
  
  //Scroller size
  self.createNoticeScroller.contentSize = CGSizeMake(320.0, 1000.0);
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - [Cancel] button implementation
-(void) cancelCreateNotice
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Create Notice");
  
  //Go back to Home Page
  HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Create Notice
-(void) createNotice
{
  if([self validateCreateNoticeFields])
  {
    //Set JSON Request
    NSMutableDictionary *createNoticeJson = [[NSMutableDictionary alloc] init];
    
    //TODO : Construct JSON object for Create Notice
    //[createNoticeJson setObject:@"" forKey:@""];
    
    NSError *error   = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:createNoticeJson
                                   options:NSJSONWritingPrettyPrinted
                                     error:&error];
    
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                                encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonData Request: %@", jsonData);
    NSLog(@"jsonString Request: %@", jsonString);
    
    //Set URL for Create Notice
    //TODO : WS Endpoint for Create Notice
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
    
    NSLog(@"createNotice - httpResponseCode: %d", httpResponseCode);
  }
  else
  {
    NSLog(@"Unable to create notice");
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
  
  if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
  {
    UIAlertView *createNoticeAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Create Notice"
                                              message:@"Notice Created."
                                             delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [createNoticeAlert show];
  }
  else //(httpResponseCode >= 400)
  {
    UIAlertView *createNoticeAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Create Notice Failed"
                                              message:@"Notice not created. Please try again later"
                                             delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [createNoticeAlert show];
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Create Notice");
}


#pragma mark - Transition to Assets Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0)
  {
    NoticesViewController *controller = (NoticesViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"NotificationPage"];
    
    [self.navigationController pushViewController:controller animated:YES];
  }
}


#pragma mark - Login fields validation
-(BOOL) validateCreateNoticeFields
{
  UIAlertView *createNoticeValidateAlert = [[UIAlertView alloc]
                                              initWithTitle:@"Incomplete Information"
                                                    message:@"Please fill out the necessary fields."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
  
  if([messageTextArea.text isEqualToString:(@"")]
     || [priorityLevelField.text isEqualToString:(@"")]
     || [userGroupNameField.text isEqualToString:(@"")]
     || [validityField.text isEqualToString:(@"")])
  {
    [createNoticeValidateAlert show];
    
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
  [messageTextArea resignFirstResponder];
  [priorityLevelField resignFirstResponder];
  [userGroupNameField resignFirstResponder];
  [validityField resignFirstResponder];
}


@end
