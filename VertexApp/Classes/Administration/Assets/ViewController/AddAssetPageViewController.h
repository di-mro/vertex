//
//  AddAssetPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ViewController.h"
#import "Assets.h"
#import "AssetAttributes.h"
#import "AssetTypes.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"


@interface AddAssetPageViewController : ViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *addAssetScroller;

@property (strong, nonatomic) IBOutlet UILabel *assetNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *assetNameField;

@property (strong, nonatomic) IBOutlet UILabel *assetTypeLabel;
@property (strong, nonatomic) UIPickerView *assetTypePicker;
@property (strong, nonatomic) IBOutlet UITextField *assetTypeField;
@property (strong, nonatomic) UIActionSheet *actionSheet;

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

@property (strong, nonatomic) IBOutlet UILabel *assetAttributesMainLabel;

@property (nonatomic, retain) NSArray *assetTypePickerArray;
@property (nonatomic, strong) NSMutableDictionary *assetTypes;

@property (nonatomic, strong) NSMutableArray *assetTypeAttributes;
@property (nonatomic, strong) NSNumber *selectedAssetTypeId;
@property int selectedIndex;
@property (nonatomic, strong) NSMutableDictionary *attribTextFields;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) NSManagedObjectContext *context;

//@property (strong, nonatomic) Assets *assetObject;
//@property (strong, nonatomic) AssetAttributes *assetAttributesObject;
//@property (strong, nonatomic) AssetTypes *assetTypesObject;


@end
