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

@end
