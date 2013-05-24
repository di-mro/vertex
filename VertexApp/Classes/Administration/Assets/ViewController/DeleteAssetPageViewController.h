//
//  DeleteAssetViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/3/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeleteAssetPageViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *deleteAssetPageEntries;
@property (nonatomic, retain) NSMutableArray *assetNameArray;
@property (nonatomic, retain) NSMutableArray *assetIdArray;
@property (nonatomic, retain) NSMutableDictionary *assetsDict;
@property (nonatomic, retain) NSNumber *selectedAssetId;

@property (nonatomic, strong) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) UIAlertView *cancelDeleteAssetConfirmation;
@property (strong, nonatomic) UIAlertView *deleteAssetConfirmation;


@end
