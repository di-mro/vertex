//
//  DeleteAssetTypePageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/4/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeleteAssetTypePageViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *deleteAssetTypePageEntries;
@property (nonatomic, retain) NSMutableArray *assetTypeNameArray;
@property (nonatomic, retain) NSMutableArray *assetTypeIdArray;
@property (nonatomic, retain) NSMutableDictionary *assetTypeDict;
@property (nonatomic, retain) NSNumber *selectedAssetTypeId;

@property (nonatomic, strong) NSString *URL;
@property int httpResponseCode;

@end
