//
//  UpdateAssetPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/20/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateAssetPageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *updateAssetPageScroller;

@property (strong, nonatomic) IBOutlet UILabel *assetNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *assetNameField;

@property (strong, nonatomic) IBOutlet UILabel *assetTypeLabel;
@property (strong, nonatomic) UIPickerView *assetTypePicker;
@property (strong, nonatomic) IBOutlet UITextField *assetTypeField;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) IBOutlet UILabel *assetAttributesLabel;

/*
@property (strong, nonatomic) IBOutlet UILabel *modelLabel;
@property (strong, nonatomic) IBOutlet UITextField *modelField;

@property (strong, nonatomic) IBOutlet UILabel *brandLabel;
@property (strong, nonatomic) IBOutlet UITextField *brandField;

@property (strong, nonatomic) IBOutlet UILabel *powerConsumptionLabel;
@property (strong, nonatomic) IBOutlet UITextField *powerConsumptionField;

@property (strong, nonatomic) IBOutlet UILabel *remarksLabel;
@property (strong, nonatomic) IBOutlet UITextView *remarksArea;
*/

@property (nonatomic, strong) NSMutableArray *assetTypeAttributes;
@property int selectedIndex;
@property (nonatomic, strong) NSMutableDictionary *attribTextFields;

@property (nonatomic, retain) NSArray *assetTypePickerArray;
@property (nonatomic, strong) NSMutableDictionary *assetTypes;
@property (nonatomic, strong) NSNumber *selectedAssetTypeId;

@property (strong, nonatomic) NSString *managedAssetId;
@property (strong, nonatomic) NSNumber *assetOwnedId;
@property (strong, nonatomic) NSMutableDictionary *assetInfo;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@end
