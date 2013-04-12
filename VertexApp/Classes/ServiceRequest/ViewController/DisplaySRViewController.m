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
    if (self)
    {
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
  //Viewing only, editing disabled
  assetField.enabled         = NO;
  lifecycleField.enabled     = NO;
  serviceField.enabled       = NO;
  priorityField.enabled      = NO;
  srDateField.enabled        = NO;
}

@end
