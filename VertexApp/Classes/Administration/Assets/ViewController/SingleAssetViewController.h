//
//  SingleAssetViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ViewController.h"

@interface SingleAssetViewController : ViewController

@property (strong, nonatomic) IBOutlet UILabel *assetNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *assetNameField;

@property (strong, nonatomic) IBOutlet UILabel *assetTypeLabel;
@property (strong, nonatomic) IBOutlet UITextField *assetTypeField;

@property (strong, nonatomic) IBOutlet UILabel *modelLabel;
@property (strong, nonatomic) IBOutlet UITextField *modelField;

@property (strong, nonatomic) IBOutlet UILabel *brandLabel;
@property (strong, nonatomic) IBOutlet UITextField *brandField;

@property (strong, nonatomic) IBOutlet UILabel *powerConsumptionLabel;
@property (strong, nonatomic) IBOutlet UITextField *powerConsumptionField;

@property (strong, nonatomic) IBOutlet UILabel *remarksLabel;
@property (strong, nonatomic) IBOutlet UITextView *remarksArea;

@property (strong, nonatomic) NSString *managedAssetId;


@end
