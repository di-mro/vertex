//
//  UpdateAssetTypeListViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/4/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateAssetTypeListViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *updateAssetTypePageEntries;

@property (nonatomic, strong) NSMutableDictionary *assetTypeDict;
@property (nonatomic, strong) NSMutableArray *assetTypeNameArray;
@property (nonatomic, strong) NSMutableArray *assetTypeIdArray;
@property (nonatomic, strong) NSNumber *selectedAssetTypeId;

@property (nonatomic, strong) NSString *URL;
@property int httpResponseCode;

/*
- (void)displayUpdateAssetsPageEntries;

@property (nonatomic, retain) NSMutableArray *updateAssetsPageEntries;

@property (nonatomic, strong) NSMutableDictionary *managedAssets;
@property (nonatomic, strong) NSMutableDictionary *assetOwned;
@property (nonatomic, strong) UITableView *assetsTableView;

@property (nonatomic, strong) NSMutableArray *assetNameArray;
@property (nonatomic, strong) NSMutableArray *assetIdArray;
@property (nonatomic, strong) NSMutableArray *assetIdNameArray;
@property (nonatomic, strong) NSNumber *selectedAssetId;

@property (nonatomic, strong) NSString *URL;
@property int httpResponseCode;
*/

@end
