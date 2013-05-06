//
//  AcknowledgeSRPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 5/6/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcknowledgeSRPageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *acknowledgeSRScroller;

@property (strong, nonatomic) IBOutlet UILabel *assetLabel;
@property (strong, nonatomic) IBOutlet UITextField *assetField;

@property (strong, nonatomic) IBOutlet UILabel *lifecycleLabel;
@property (strong, nonatomic) IBOutlet UITextField *lifecycleField;

@property (strong, nonatomic) IBOutlet UILabel *serviceLabel;
@property (strong, nonatomic) IBOutlet UITextField *serviceField;

@property (strong, nonatomic) IBOutlet UILabel *estimatedCostLabel;
@property (strong, nonatomic) IBOutlet UITextField *estimatedCostField;

@property (strong, nonatomic) IBOutlet UILabel *dateRequestedLabel;
@property (strong, nonatomic) IBOutlet UITextField *dateRequestedField;

@property (strong, nonatomic) IBOutlet UILabel *priorityLabel;
@property (strong, nonatomic) IBOutlet UITextField *priorityField;

@property (strong, nonatomic) IBOutlet UILabel *notesLabel;
@property (strong, nonatomic) IBOutlet UITextView *notesTextArea;

@property (strong, nonatomic) UIPickerView *srGenericPicker;
@property (strong, nonatomic) NSArray *currentArray;
@property (strong, nonatomic) UITextField *currentTextField;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (nonatomic, retain) NSMutableArray *assetPickerArray;
@property (nonatomic, retain) NSArray *lifecyclePickerArray;
@property (nonatomic, retain) NSArray *servicePickerArray;
@property (nonatomic, retain) NSArray *priorityPickerArray;

@property (nonatomic, retain) NSArray *ownedAssetsArray;
@property (nonatomic, retain) NSArray *ownedAssetsIdArray;
@property (nonatomic, retain) NSArray *ownedAssetTypeIdArray;
@property (nonatomic, retain) NSArray *managedAssetsArray;
@property (nonatomic, retain) NSArray *managedAssetsIdArray;
@property (nonatomic, retain) NSArray *managedAssetTypeIdArray;

@property (strong, nonatomic) NSMutableDictionary *ownedAssets;
@property (strong, nonatomic) NSMutableDictionary *managedAssets;
@property (strong, nonatomic) NSMutableDictionary *lifecycles;
@property (strong, nonatomic) NSMutableDictionary *services;
@property (strong, nonatomic) NSMutableDictionary *priorities;

//@property (strong, nonatomic) NSDate *dateRequested;
//@property int selectedIndex;

@property (strong, nonatomic) NSMutableArray *assetIdArray;
@property (strong, nonatomic) NSMutableArray *assetTypeIdArray;
@property (strong, nonatomic) NSMutableArray *lifecycleIdArray;
@property (strong, nonatomic) NSMutableArray *servicesIdArray;
@property (strong, nonatomic) NSMutableArray *priorityIdArray;

@property (strong, nonatomic) NSMutableArray *servicesCostArray;
@property (strong, nonatomic) NSNumber *serviceCost;

@property (strong, nonatomic) NSNumber *selectedAssetId;
@property (strong, nonatomic) NSNumber *selectedAssetTypeId;
@property (strong, nonatomic) NSNumber *selectedLifecycleId;
@property (strong, nonatomic) NSNumber *selectedServicesId;
@property (strong, nonatomic) NSNumber *selectedPriorityId;

@property (strong, nonatomic) NSMutableDictionary *serviceRequestJson;

@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSNumber *serviceRequestId;
@property (strong, nonatomic) NSMutableDictionary *serviceRequestInfo;
@property (strong, nonatomic) NSNumber *statusId;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@end
