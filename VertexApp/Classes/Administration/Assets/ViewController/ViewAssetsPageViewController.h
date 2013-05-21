//
//  ViewAssetsPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/13/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewAssetsPageViewController : UIViewController

- (void)displayViewAssetsPageEntries;

@property (nonatomic, retain) NSMutableArray *viewAssetsPageEntries;

@property (nonatomic, strong) NSString *URL;

@property (nonatomic, strong) NSMutableDictionary *managedAssets;
@property (nonatomic, strong) NSMutableDictionary *assetOwned;
@property (nonatomic, strong) UITableView *assetsTableView;

@property (nonatomic, strong) NSMutableArray *assetNameArray;
@property (nonatomic, strong) NSMutableArray *assetIdArray;
@property (nonatomic, strong) NSMutableArray *assetIdNameArray;
@property (nonatomic, strong) NSNumber *selectedAssetId;


@end
