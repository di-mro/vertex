//
//  AddAssetPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AddAssetPageViewController.h"
#import "HomePageViewController.h"
#import "AssetPageViewController.h"

@interface AddAssetPageViewController ()

@end

@implementation AddAssetPageViewController

@synthesize assetTypePickerArray;
@synthesize assetTypePicker;
@synthesize addAssetScroller;
@synthesize actionSheet;

@synthesize assetNameField;
@synthesize assetTypeField;
@synthesize modelField;
@synthesize brandField;
@synthesize powerConsumptionField;
@synthesize remarksArea;

@synthesize assetObject;


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
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAddAsset)];
  
  //[Add] navigation button
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(createAsset)];
  
  //Configure Scroller size
  self.addAssetScroller.contentSize = CGSizeMake(320, 720);
  
  //Configure Picker array values
  self.assetTypePickerArray = [[NSArray alloc] initWithObjects:@"Aircon",@"Door", @"Exhaust Fan",@"Faucet",@"Toilet",@"Kitchen Sink",@"Lighting Fixtures", nil];
  
  //assetTypePicker in assetTypeField
  [assetTypeField setDelegate:self];
  
  //AssetObject initialization
  assetObject = [[AssetObject alloc] init];
    
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Change assetTypeField to assetTypePicker when clicked
- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
  if(assetTypeField.isEditing)
  {
    NSLog(@"textFieldDidBeginEditing - function call");
    [textField resignFirstResponder];
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    assetTypePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
    assetTypePicker.showsSelectionIndicator = YES;
    assetTypePicker.dataSource = self;
    assetTypePicker.delegate = self;
    
    [actionSheet addSubview:assetTypePicker];
    
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObject:@"Done"]];
    doneButton.momentary = YES;
    doneButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blackColor];
    [doneButton addTarget:self action:@selector(selectedRow) forControlEvents:UIControlEventValueChanged];
    
    [actionSheet addSubview:doneButton];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    assetTypeField.inputView = actionSheet;
    
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
  return [assetTypePickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [self.assetTypePickerArray objectAtIndex:row];
}

#pragma mark - Get the selected row in assetTypePicker
-(void)selectedRow{
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  int selectedIndex = [assetTypePicker selectedRowInComponent:0];
  NSString *selectedAssetType = [assetTypePickerArray objectAtIndex:selectedIndex];
  assetTypeField.text = selectedAssetType;
  
  //Do something with the selected row, store then save in DB
}

#pragma mark - End editing for the fields, dismiss onscreen keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.view endEditing:YES];
}

#pragma mark - [Cancel] button implementation
-(void) cancelAddAsset
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Add Asset");
  
  //Go back to Home Page
  HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];

  [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - [Add] button implementation
-(void) createAsset
{
  if([self validateAddAssetFields])
  {
    /* !- Put Asset info into Asset object. Save Asset info to db - PUT -! */
    assetObject.assetName = assetNameField.text;
    assetObject.assetType = assetTypeField.text;
    assetObject.model = modelField.text;
    assetObject.brand = brandField.text;
    assetObject.powerConsumption = powerConsumptionField.text;
    assetObject.remarks = remarksArea.text;
    
    NSLog(@"assetObject: %@", assetObject.assetType);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Create Asset");
    
    /*
     //ActivityIndicator Code
     UIActivityIndicatorView *spinner =
     [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150     // Hi
     , 225   // Frennn
     , 20    // Na
     , 30)]; // Masungit
     [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
     spinner.color = [UIColor blueColor];
     [self.view addSubview:spinner];
     [spinner startAnimating];
     //[spinner stopAnimating];
     */
    
    /* !- TODO validateSaveToDB -! */
    //if(validateSaveToDB)
    //Inform user asset is saved
    UIAlertView *createAssetAlert = [[UIAlertView alloc] initWithTitle:@"Create Asset"
                                                               message:@"Asset Created."
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
    [createAssetAlert show];
    //Transition to Assets Page - alertView clickedButtonAtIndex
  }
  else
  {
    NSLog(@"Unable to add Asset");
  }
}

#pragma mark - Transition to Assets Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0)
  {
    AssetPageViewController* controller = (AssetPageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AssetsPage"];
    
    [self.navigationController pushViewController:controller animated:YES];
  }
}

#pragma mark - Login fields validation
-(BOOL) validateAddAssetFields
{
  UIAlertView *addAssetValidateAlert = [[UIAlertView alloc] initWithTitle:@"Incomplete Information"
                                                               message:@"Please fill out the necessary fields."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
  
  if([assetNameField.text isEqualToString:(@"")]
     || [assetTypeField.text isEqualToString:(@"")]
     || [modelField.text isEqualToString:(@"")]
     || [brandField.text isEqualToString:(@"")])
  {
    [addAssetValidateAlert show];
    return false;
  }
  else
  {
    return true;
  }
}

/* !- TODO -! */
#pragma mark - Check if saved to DB properly
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

#pragma mark - Dismiss assetTypePicker action sheet
-(void)dismissActionSheet:(id) sender
{
  [sender dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - Dismiss onscreen keyboard
-(void)dismissKeyboard
{
  [assetNameField resignFirstResponder];
  [assetTypeField resignFirstResponder];
  [modelField resignFirstResponder];
  [brandField resignFirstResponder];
  [powerConsumptionField resignFirstResponder];
  [remarksArea resignFirstResponder];
}


@end
