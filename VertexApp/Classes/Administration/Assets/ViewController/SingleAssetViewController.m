//
//  SingleAssetViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "SingleAssetViewController.h"

@interface SingleAssetViewController ()

@end

@implementation SingleAssetViewController

@synthesize assetNameField;
@synthesize assetTypeField;
@synthesize modelField;
@synthesize brandField;
@synthesize powerConsumptionField;
@synthesize remarksArea;

@synthesize managedAssetId;

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
  NSLog(@"managedAssetId: %@", managedAssetId);
  //assetNameField.text = managedAssetId;
  //For viewing only, editing disabled
  assetNameField.enabled = NO;
  assetTypeField.enabled = NO;
  modelField.enabled = NO;
  brandField.enabled = NO;
  powerConsumptionField.enabled = NO;
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
