//
//  SingleAssetViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ViewController.h"

@interface SingleAssetViewController : ViewController

@property (strong, nonatomic) IBOutlet UIScrollView *singleAssetViewScroller;
@property (strong, nonatomic) IBOutlet UITextView *assetDetailsTextArea;

@property (strong, nonatomic) NSString *managedAssetId;
@property (strong, nonatomic) NSNumber *assetOwnedId;
@property (strong, nonatomic) NSMutableDictionary *assetInfo;

@property (nonatomic, strong) NSString *URL;

@end
