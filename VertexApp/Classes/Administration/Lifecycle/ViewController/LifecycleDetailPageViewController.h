//
//  LifecycleDetailPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/2/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifecycleDetailPageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *lifecycleDetailTextArea;

@property (strong, nonatomic) NSNumber *lifecycleId;
@property (strong, nonatomic) NSMutableDictionary *lifecycleInfo;

@property (strong, nonatomic) NSString *URL;

/*
 @property (strong, nonatomic) IBOutlet UIScrollView *singleAssetViewScroller;
 @property (strong, nonatomic) IBOutlet UITextView *assetDetailsTextArea;
 
 @property (strong, nonatomic) NSString *managedAssetId;
 @property (strong, nonatomic) NSNumber *assetOwnedId;
 @property (strong, nonatomic) NSMutableDictionary *assetInfo;
 
 @property (nonatomic, strong) NSString *URL;
 */

@end
