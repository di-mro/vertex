//
//  UpdateAssetListViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/20/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateAssetListViewController : UIViewController

- (void)displayUpdateAssetsPageEntries;

@property (nonatomic, retain) NSMutableArray *updateAssetsPageEntries;

@property (nonatomic, strong) NSString *URL;

@property (nonatomic, strong) NSMutableDictionary *managedAssets;
@property (nonatomic, strong) NSMutableDictionary *assetOwned;
@property (nonatomic, strong) UITableView *assetsTableView;

@property (nonatomic, strong) NSMutableArray *assetNameArray;
@property (nonatomic, strong) NSMutableArray *assetIdArray;
@property (nonatomic, strong) NSMutableArray *assetIdNameArray;
@property (nonatomic, strong) NSNumber *selectedAssetId;


@end
