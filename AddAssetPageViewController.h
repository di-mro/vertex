//
//  AddAssetPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ViewController.h"

@interface AddAssetPageViewController : ViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *addAssetScroller;

@property (strong, nonatomic) IBOutlet UILabel *assetNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *assetNameField;

@property (strong, nonatomic) IBOutlet UILabel *assetTypeLabel;
//@property (strong, nonatomic) IBOutlet UIPickerView *assetTypePicker;
@property (strong, nonatomic) UIPickerView *assetTypePicker;
@property (strong, nonatomic) IBOutlet UITextField *assetTypeField;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) IBOutlet UILabel *modelLabel;
@property (strong, nonatomic) IBOutlet UITextField *modelField;

@property (strong, nonatomic) IBOutlet UILabel *brandLabel;
@property (strong, nonatomic) IBOutlet UITextField *brandField;

@property (strong, nonatomic) IBOutlet UILabel *powerConsumptionLabel;
@property (strong, nonatomic) IBOutlet UITextField *powerConsumptionField;

@property (strong, nonatomic) IBOutlet UILabel *remarksLabel;
@property (strong, nonatomic) IBOutlet UITextView *remarksArea;

@property (nonatomic, retain) NSArray *assetTypePickerArray;

@end
