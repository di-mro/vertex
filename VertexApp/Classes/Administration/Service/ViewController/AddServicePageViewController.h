//
//  AddServicePageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/2/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddServicePageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *addServiceScroller;

@property (strong, nonatomic) IBOutlet UILabel *assetTypeLabel;
@property (strong, nonatomic) IBOutlet UITextField *assetTypeField;

@property (strong, nonatomic) IBOutlet UILabel *lifecycleLabel;
@property (strong, nonatomic) IBOutlet UITextField *lifecycleField;

@property (strong, nonatomic) IBOutlet UILabel *serviceLabel;
@property (strong, nonatomic) IBOutlet UITextField *serviceField;

@property (strong, nonatomic) IBOutlet UILabel *serviceCostLabel;
@property (strong, nonatomic) IBOutlet UITextField *serviceCostField;

@property (strong, nonatomic) NSMutableArray *assetPickerArray;
@property (strong, nonatomic) NSMutableArray *assetTypeIdArray;
@property (strong, nonatomic) NSMutableArray *lifecyclePickerArray;
@property (strong, nonatomic) NSMutableArray *lifecycleIdArray;

@property (strong, nonatomic) NSMutableDictionary *assetTypes;
@property (strong, nonatomic) NSMutableDictionary *lifecycles;

@property (strong, nonatomic) UIPickerView *srGenericPicker;
@property (strong, nonatomic) NSArray *currentArray;
@property (strong, nonatomic) UITextField *currentTextField;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property int selectedIndex;
@property (strong, nonatomic) NSNumber *selectedAssetTypeId;
@property (strong, nonatomic) NSNumber *selectedLifecycleId;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@end
