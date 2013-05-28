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

@synthesize actionSheet;
@synthesize lifecyclePreviousPicker;

@synthesize lifecyclePreviousPickerArray;
@synthesize lifecyclePreviousIdArray;

@synthesize lifecycles;

@synthesize selectedLifecycleId;
@synthesize addLifecycleJson;

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
    
  //For lifecyclePrevious picker
  lifecyclePreviousPickerArray    = [[NSMutableArray alloc] init];
  lifecyclePreviousIdArray        = [[NSMutableArray alloc] init];
  [lifecyclePreviousField setDelegate:self];
  [self getLifecycles];
  
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


#pragma mark - getLifecycles endpoint connection for lifecyclePrevious field
-(void) getLifecycles
{
  URL = @"http://192.168.2.107/vertex-api/lifecycle/getLifecycles";
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:URL]];
  
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [getRequest setHTTPMethod:@"GET"];
  
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
  
  if(responseData == nil)
  {
    //Show an alert if connection is not available
    UIAlertView *lifecycleAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Warning"
                                             message:@"No network connection detected. Displaying data from phone cache."
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
    [lifecycleAlert show];
    
    //Connect to CoreData for local data
    //!- FOR TESTING ONLY -!
    lifecyclePreviousPickerArray = [[NSMutableArray alloc] initWithObjects:
                                      @"Demo - Canvas"
                                    , @"Demo - Requisition"
                                    , @"Demo - Purchase"
                                    , @"Demo - Installation"
                                    , @"Demo - Repair"
                                    , @"Demo - Decommission"
                                    , nil];
    
    lifecyclePreviousIdArray = [[NSMutableArray alloc] initWithObjects:
                                  @"Demo - 00001"
                                , @"Demo - 00002"
                                , @"Demo - 00004"
                                , @"Demo - 00005"
                                , nil];
  }
  else
  {
    lifecycles = [NSJSONSerialization
                  JSONObjectWithData:responseData
                             options:kNilOptions
                               error:&error];
    NSLog(@"lifecycles JSON Result: %@", lifecycles);
    
    lifecyclePreviousPickerArray = [lifecycles valueForKey:@"name"]; //store lifecycle names only in PickerArray
    lifecyclePreviousIdArray     = [lifecycles valueForKey:@"id"];
    NSLog(@"lifecyclePreviousPickerArray: %@", lifecyclePreviousPickerArray);
  }

}


#pragma mark - Set lifecyclePrevious field to picker
- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
  NSLog(@"textFieldDidBeginEditing - function call");
  if(lifecyclePreviousField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - lifecyclePreviousField");
    [textField resignFirstResponder];
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    lifecyclePreviousPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
    lifecyclePreviousPicker.showsSelectionIndicator = YES;
    lifecyclePreviousPicker.dataSource = self;
    lifecyclePreviousPicker.delegate   = self;
    
    [actionSheet addSubview:lifecyclePreviousPicker];
    
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObject:@"Done"]];
    doneButton.momentary = YES;
    doneButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blackColor];
    [doneButton addTarget:self action:@selector(getLifecycleIndex) forControlEvents:UIControlEventValueChanged];
    
    [actionSheet addSubview:doneButton];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    lifecyclePreviousField.inputView = actionSheet;
    
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
  return [lifecyclePreviousPickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [self.lifecyclePreviousPickerArray objectAtIndex:row];
}

#pragma mark - Get the id of the selected lifecycle in lifecyclePrevious Picker
-(void) getLifecycleIndex
{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  int lifecycleIndex  = [lifecyclePreviousPicker selectedRowInComponent:0];
  selectedLifecycleId = [lifecyclePreviousIdArray objectAtIndex:lifecycleIndex]; //selectedIndex
  NSLog(@"selectedLifecycleId: %@", selectedLifecycleId);
  
  NSString *selectedEntity    = [lifecyclePreviousPickerArray objectAtIndex:lifecycleIndex];
  lifecyclePreviousField.text = selectedEntity;
}


#pragma mark - Add Lifecycle
-(void) addLifecycle
{
  if([self validateAddLifecycleFields])
  {
    //Set JSON Request
    addLifecycleJson = [[NSMutableDictionary alloc] init];
    
    [addLifecycleJson setObject:lifecycleNameField.text forKey:@"name"];
    [addLifecycleJson setObject:lifecycleDescriptionField.text forKey:@"description"];
    
    NSMutableDictionary *lifecyclePreviousJson = [[NSMutableDictionary alloc] init];
    [lifecyclePreviousJson setObject:selectedLifecycleId forKey:@"id"];
    [addLifecycleJson setObject:lifecyclePreviousJson forKey:@"prev"];
    
    NSLog(@"addLifecycleJson: %@", addLifecycleJson);
    
    NSError *error   = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:addLifecycleJson
                                   options:NSJSONWritingPrettyPrinted
                                     error:&error];
    
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                                encoding:NSUTF8StringEncoding];
        
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
  httpResponse     = (NSHTTPURLResponse *)response;
  httpResponseCode = [httpResponse statusCode];
  NSLog(@"httpResponse status code: %d", httpResponseCode);
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
