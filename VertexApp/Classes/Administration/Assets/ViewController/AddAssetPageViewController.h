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

#import "UserAccountInfoManager.h"
#import "UserAccountsObject.h"


@interface AddAssetPageViewController : ViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>
{
  UserAccountInfoManager *userAccountInfoSQLManager;
  UserAccountsObject *userAccountsObject;
}


@property (strong, nonatomic) IBOutlet UIView *addAssetView;

@property (strong, nonatomic) IBOutlet UIScrollView *addAssetScroller;

@property (strong, nonatomic) IBOutlet UILabel *assetNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *assetNameField;

@property (strong, nonatomic) IBOutlet UILabel *assetTypeLabel;
@property (strong, nonatomic) UIPickerView *assetTypePicker;
@property (strong, nonatomic) IBOutlet UITextField *assetTypeField;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) IBOutlet UILabel *assetAttributesMainLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *assetAttributeScroller;

@property (nonatomic, retain) NSArray *assetTypePickerArray;
@property (nonatomic, retain) UIPickerView *genericPicker;
@property (nonatomic, retain) NSArray *currentPickerArray;
@property (nonatomic, retain) UITextField *currentTextField;
@property (nonatomic, strong) NSMutableDictionary *assetTypes;

@property (nonatomic, strong) NSMutableArray *assetTypeAttributes;
@property (nonatomic, strong) NSNumber *selectedAssetTypeId;
@property int selectedIndex;

@property (nonatomic, strong) NSMutableDictionary *attribTextFields;
@property (nonatomic, strong) NSMutableDictionary *attribUnits;
@property (strong, nonatomic) UIPickerView *attributesPicker;
@property (strong, nonatomic) NSMutableArray *selectedUnitIds;

@property (strong, nonatomic) NSNumber *userId;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) UIAlertView *cancelAddAssetConfirmation;


@end
