//
//  UpdateAssetTypePageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/4/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateAssetTypePageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *updateAssetTypeScroller;
@property (strong, nonatomic) IBOutlet UILabel *assetTypeNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *assetTypeNameField;

@property (strong, nonatomic) NSNumber *assetTypeId;
@property (strong, nonatomic) NSMutableDictionary *assetTypeInfo;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;


@end
