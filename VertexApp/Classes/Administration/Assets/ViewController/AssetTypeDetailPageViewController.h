//
//  AssetTypeDetailPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/4/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetTypeDetailPageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *assetTypeDetailTextArea;

@property (strong, nonatomic) NSNumber *assetTypeId;
@property (strong, nonatomic) NSMutableDictionary *assetTypeInfo;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;


@end
