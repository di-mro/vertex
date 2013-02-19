//
//  AddAssetPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AddAssetPageViewController.h"

@interface AddAssetPageViewController ()

@end

@implementation AddAssetPageViewController

@synthesize assetTypePickerArray;
@synthesize assetTypePicker;
@synthesize addAssetScroller;

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
  self.addAssetScroller.contentSize = CGSizeMake(280.0, 1000.0);
  
  //!-Remove hardcoded values. Must retrieve listing in DB-!
  self.assetTypePickerArray = [[NSArray alloc] initWithObjects:@"Aircon",@"Door", @"Exhaust Fan",@"Faucet",@"Toilet",@"Kitchen Sink",@"Lighting Fixtures", nil];;
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAddAsset:(id)sender
{
  //Cancel / clear the fields
}

- (IBAction)createAddAsset:(id)sender
{
  //Save inputs in db
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

-(IBAction)selectedRow {
  //int selectedIndex = [assetTypePicker selectedRowInComponent:0];
  
  //Do something with the selected row, save in DB
  /*
  NSString *message = [NSString stringWithFormat:@"You selected: %@",[assetTypePickerArray objectAtIndex:selectedIndex]];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
  [alert release];
  */
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.superclass endEditing:YES];
  [self.view endEditing:YES];
}

@end
