//
//  DisplaySRViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/15/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "DisplaySRViewController.h"

@interface DisplaySRViewController ()

@end

@implementation DisplaySRViewController

@synthesize nameField;
@synthesize unitLocationField;
@synthesize contactNumberField;
@synthesize assetField;
@synthesize lifecycleField;
@synthesize serviceField;
@synthesize priorityField;
@synthesize srDetailsTextArea;
@synthesize srDateField;
@synthesize displaySRScroller;

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
  self.displaySRScroller.contentSize = CGSizeMake(280.0, 1000.0);
  [self initField];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization of fields
- (void) initField
{
  nameField.enabled          = NO;
  unitLocationField.enabled  = NO;
  contactNumberField.enabled = NO;
  assetField.enabled         = NO;
  lifecycleField.enabled     = NO;
  serviceField.enabled       = NO;
  priorityField.enabled      = NO;
  srDateField.enabled        = NO;
  //srDetailsTextArea enabling / disabling is set in Attributes Inspector
}

- (IBAction)submitSR:(id)sender
{
  //Save to DB service request details
}

- (IBAction)discardSR:(id)sender
{
  //Clear and clean the fields and go back to Home (?)
}
@end
