//
//  CreateSRViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/15/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "CreateSRViewController.h"

@interface CreateSRViewController ()

@end

@implementation CreateSRViewController

@synthesize createSRScroller;
@synthesize assetPicker;
@synthesize assetPickerArray;
@synthesize lifecyclePicker;
@synthesize lifecyclePickerArray;
@synthesize servicePicker;
@synthesize servicePickerArray;
@synthesize priorityPicker;
@synthesize priorityPickerArray;
@synthesize assetField;
@synthesize lifecycleField;
@synthesize serviceField;
@synthesize priorityField;
@synthesize srGenericPicker;
@synthesize currentArray;
@synthesize currentTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  self.createSRScroller.contentSize = CGSizeMake(280.0, 1000.0);
  
  //!-Remove hardcoded shiznitz. Must retrieve listing in DB-!
  self.assetPickerArray = [[NSArray alloc] initWithObjects:@"Aircon",@"Window", @"Bathtub",@"Bathroom Faucet",@"Toilet",@"Kitchen Sink",@"Lighting Fixtures", nil];
  self.lifecyclePickerArray = [[NSArray alloc] initWithObjects: @"Canvas", @"Requisition", @"Purchase", @"Installation", @"Repair", @"Decommission", nil];
  self.servicePickerArray = [[NSArray alloc] initWithObjects:@"Fix pipes", @"Clean filter", @"Fix wiring", nil];
  self.priorityPickerArray = [[NSArray alloc] initWithObjects:@"Emergency", @"Scheduled", @"Daily blah", @"Maintenance", nil];
  
  //Initialize generic picker
  srGenericPicker.frame = CGRectMake(0,self.view.frame.size.height, srGenericPicker.frame.size.width, srGenericPicker.frame.size.height);
  srGenericPicker.delegate   = self;
  srGenericPicker.dataSource = self;
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)previewSR:(id)sender
{
  //proceed to ViewSRViewController
  //Pass data
}

- (IBAction)cancelSR:(id)sender
{
  //Clear fields, go back to where you belong
}

#pragma mark - Implementing the Picker Viewsss - !-Remove the hardcoded shiznitz-!
/*
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  //Check the number of component to be returned by each Picker in Create SR
  if([pickerView isEqual: assetPicker])
  {
    // return the appropriate number of components for the Picker
    return 1;
  }
  else if([pickerView isEqual: lifecyclePicker])
  {
    return 1;
  }
  else if([pickerView isEqual:servicePicker])
  {
    return 1;
  }
  else if([pickerView isEqual:priorityPicker])
  {
    return 1;
  }
  else
  {
    return 1;
  }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  if([pickerView isEqual: assetPicker])
  {
    // return the appropriate number of rows in component for the Picker
    return [assetPickerArray count];
  }
  else if([pickerView isEqual: lifecyclePicker])
  {
    return [lifecyclePickerArray count];
  }
  else if([pickerView isEqual:servicePicker])
  {
    return [servicePickerArray count];
  }
  else if([pickerView isEqual:priorityPicker])
  {
    return [priorityPickerArray count];
  }
  else
  {
    return 1;
  }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  if([pickerView isEqual: assetPicker])
  {
    // return the appropriate number of rows in component for the Picker
    return [assetPickerArray objectAtIndex:row];
  }
  else if([pickerView isEqual: lifecyclePicker])
  {
    return [lifecyclePickerArray objectAtIndex:row];
  }
  else if([pickerView isEqual:servicePicker])
  {
    return [servicePickerArray objectAtIndex:row];
  }
  else if([pickerView isEqual:priorityPicker])
  {
    return [priorityPickerArray objectAtIndex:row];
  }
  else
  {
    return [assetPickerArray objectAtIndex:row];
  }
}

-(IBAction)selectedRow {
  //int selectedIndex = [assetTypePicker selectedRowInComponent:0];
  
  //Do something with the selected row, save in DB
   NSString *message = [NSString stringWithFormat:@"You selected: %@",[assetTypePickerArray objectAtIndex:selectedIndex]];
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
   [alert show];
   [alert release];
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.superclass endEditing:YES];
  [self.view endEditing:YES];
}

#pragma mark - UIPickers implementation when text fields are selected
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  
  currentTextField = textField;
  if(textField == assetField)
  {
    currentArray = assetPickerArray;
    //[srGenericPicker reloadData];
    [self animatePickerViewIn];
    return NO;
  }
  else if(textField == lifecycleField)
  {
    currentArray = lifecyclePickerArray;
    [self animatePickerViewIn];
    return NO;
  }
  else
  {
    return NO;
  }
}

-(void)animatePickerViewIn
{
  [UIView animateWithDuration:0.25 animations:^{
    [srGenericPicker setFrame:CGRectMake(0, srGenericPicker.frame.origin.y-srGenericPicker.frame.size.height, srGenericPicker.frame.size.width, srGenericPicker.frame.size.height)];
  }];
}

-(NSInteger)srGenericPicker:(UIPickerView *)srGenericPicker numberOfRowsInComponent:(NSInteger)component
{
  return [currentArray count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [currentArray objectAtIndex:row];
}

/*
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  //and here you can do in two ways:
  //1
  [currentTextField setText:[currentArray objectAtIndex:row]];
  //2
  [currentTextField setText:[self pickerView:pickerView titleForRow:row inComponent:component]];
}
*/


@end
