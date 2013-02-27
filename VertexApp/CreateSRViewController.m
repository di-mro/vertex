//
//  CreateSRViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/15/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "CreateSRViewController.h"
#import "HomePageViewController.h"
#import "ServiceRequestViewController.h"

@interface CreateSRViewController ()

@end

@implementation CreateSRViewController

@synthesize createSRScroller;
@synthesize actionSheet;
@synthesize assetPickerArray;
@synthesize lifecyclePickerArray;
@synthesize servicePickerArray;
@synthesize priorityPickerArray;

@synthesize assetField;
@synthesize lifecycleField;
@synthesize serviceField;
@synthesize priorityField;
@synthesize nameField;
@synthesize unitLocationField;
@synthesize contactNumberField;
@synthesize detailsTextArea;

@synthesize srGenericPicker;
@synthesize currentArray;
@synthesize currentTextField;

@synthesize srObject;


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
  
  //[Cancel] Navigation Button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSR)];
  
  //[Create] Navigation Button
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(createSR)];
  
  //Configure Scroller size
  self.createSRScroller.contentSize = CGSizeMake(320.0, 900.0);
  
  /* !- Remove hardcoded values. Must retrieve listing in DB -! */
  self.assetPickerArray = [[NSArray alloc] initWithObjects:@"Aircon",@"Window", @"Bathtub",@"Bathroom Faucet",@"Toilet",@"Kitchen Sink",@"Lighting Fixtures", nil];
  
  self.lifecyclePickerArray = [[NSArray alloc] initWithObjects: @"Canvas", @"Requisition", @"Purchase", @"Installation", @"Repair", @"Decommission", nil];
  
  self.servicePickerArray = [[NSArray alloc] initWithObjects:@"Fix broken pipes", @"Clean filter", @"Fix wiring", @"Declog pipes", @"Repaint", @"Miscellaneous", nil];
  
  self.priorityPickerArray = [[NSArray alloc] initWithObjects:@"Emergency", @"Scheduled", @"Routine", @"Urgent", nil];
  
  //Set delegates for the Picker fields
  [assetField setDelegate:self];
  [lifecycleField setDelegate:self];
  [serviceField setDelegate:self];
  [priorityField setDelegate:self];
  
  //SRObject initialization
  srObject = [[SRObject alloc] init];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Generic Picker definitions
-(void) defineGenericPicker
{
  //Generic Picker definition
  srGenericPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
  srGenericPicker.showsSelectionIndicator = YES;
  srGenericPicker.dataSource = self;
  srGenericPicker.delegate = self;
}

#pragma mark - Settings certain fields to Pickers when clicked
- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
  NSLog(@"textFieldDidBeginEditing");
  
  //Action Sheet definition
  actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                            delegate:nil
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:nil
                                   otherButtonTitles:nil];
  [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
  
  UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObject:@"Done"]];
  doneButton.momentary = YES;
  doneButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
  doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
  doneButton.tintColor = [UIColor blackColor];
  [doneButton addTarget:self
                 action:@selector(selectedRow)
       forControlEvents:UIControlEventValueChanged];
  
  [actionSheet addSubview:doneButton];
  [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
  [actionSheet setBounds :CGRectMake(0, 0, 320, 485)];

  if(assetField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - assetField");
    [textField resignFirstResponder];
    
    currentArray = [[NSArray alloc] initWithObjects: nil];
    [self defineGenericPicker];
    [actionSheet addSubview:srGenericPicker];
    
    currentArray = assetPickerArray;
    currentTextField = assetField;
    assetField.inputView = actionSheet;

    return YES;
  }
  else if(lifecycleField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - lifecycleField");
    [textField resignFirstResponder];
    
    currentArray = [[NSArray alloc] initWithObjects: nil];
    [self defineGenericPicker];
    [actionSheet addSubview:srGenericPicker];
    
    currentArray = lifecyclePickerArray;
    currentTextField = lifecycleField;
    lifecycleField.inputView = actionSheet;
    
    return YES;
  }
  else if(serviceField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - serviceField");
    [textField resignFirstResponder];
    
    currentArray = [[NSArray alloc] initWithObjects: nil];
    [self defineGenericPicker];
    [actionSheet addSubview:srGenericPicker];
    
    currentArray = servicePickerArray;
    currentTextField = serviceField;
    serviceField.inputView = actionSheet;
    
    return YES;
  }
  else if(priorityField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - priorityField");
    [textField resignFirstResponder];
    
    currentArray = [[NSArray alloc] initWithObjects: nil];
    [self defineGenericPicker];
    [actionSheet addSubview:srGenericPicker];
    
    currentArray = priorityPickerArray;
    currentTextField = priorityField;
    priorityField.inputView = actionSheet;
    
    return YES;
  }
  else
  {
    return NO;
  }
  
}

#pragma mark - Get selected row in Pickers
-(void)selectedRow {
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  int selectedIndex = [srGenericPicker selectedRowInComponent:0];
  NSString *selectedEntity = [currentArray objectAtIndex:selectedIndex];
  currentTextField.text = selectedEntity;
  
  /* !- Get selectedEntity then save in DB -! */
}

#pragma mark - Dismiss editing to hide onscreen keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.view endEditing:YES];
}


#pragma mark - Implementing Picker Views functionality
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  NSLog(@"Current Array - numberOfRowsInComponent: %@", currentArray);
  return [currentArray count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [currentArray objectAtIndex:row];
}

#pragma mark - [Cancel] button logic implementation
-(void) cancelSR
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Service Request");
  
  //Go back to Home Page
  HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - [Create] button logic implementation
-(void) createSR
{
  if ([self validateCreateSRFields])
  {
    //Put SR info into SR object.
    /* !- Save SR info to db - PUT -!*/
    srObject.asset = assetField.text;
    srObject.lifecycle = lifecycleField.text;
    srObject.service = serviceField.text;
    srObject.priority = priorityField.text;
    srObject.name = nameField.text;
    srObject.unitLocation = unitLocationField.text;
    srObject.contactNumber = contactNumberField.text;
    srObject.details = detailsTextArea.text;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Create Service Request");
    
    /* !- Add validation if information is properly saved in DB -! */
    //if(validateSaveToDB)
    //Inform user SR is saved
    UIAlertView *createSRAlert = [[UIAlertView alloc] initWithTitle:@"Service Request"
                                                            message:@"Service Request Created."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
    [createSRAlert show];
    //Transition to Service Request Page - alertView clickedButtonAtIndex
  }
  else
  {
    NSLog(@"Unable to create Service Request");
  }
}

#pragma mark - Transition to Service Requests Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0) //OK
  {
    ServiceRequestViewController* controller = (ServiceRequestViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SRPage"];
    
    [self.navigationController pushViewController:controller animated:YES];
  }
}

#pragma mark - Service Request fields validation
-(BOOL) validateCreateSRFields
{
  UIAlertView *createSRValidateAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Incomplete Information"
                                              message:@"Please fill out the necessary fields."
                                             delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
  
  if([assetField.text isEqualToString:(@"")]
     || [lifecycleField.text isEqualToString:(@"")]
     || [serviceField.text isEqualToString:(@"")]
     || [priorityField.text isEqualToString:(@"")]
     || [nameField.text isEqualToString:(@"")]
     || [unitLocationField.text isEqualToString:(@"")]
     || [contactNumberField.text isEqualToString:(@"")])
  {
    [createSRValidateAlert show];
    return false;
  }
  else
  {
    return true;
  }
}

/* !- TODO -! */
#pragma mark - Validate if information is saved to DB properly
-(BOOL) validateSaveToDB
{
  /*
   if()
   {
   return true;
   }
   else
   {
   return false;
   }
   */
}

#pragma mark - Dimiss the Pickers actionSheet when [Done] button is clicked
-(void)dismissActionSheet:(id) sender
{
  [sender dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - Dismiss keyboard when fields are not in use
-(void)dismissKeyboard
{
  [assetField resignFirstResponder];
  [lifecycleField resignFirstResponder];
  [serviceField resignFirstResponder];
  [priorityField resignFirstResponder];
  [nameField resignFirstResponder];
  [unitLocationField resignFirstResponder];
  [contactNumberField resignFirstResponder];
  [detailsTextArea resignFirstResponder];
}


@end
