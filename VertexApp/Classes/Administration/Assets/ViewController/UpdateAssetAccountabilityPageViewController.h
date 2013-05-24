//
//  UpdateAssetAccountabilityPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/3/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateAssetAccountabilityPageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *updateAssetAccountabilityScroller;

@property (strong, nonatomic) IBOutlet UILabel *assetNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *assetNameField;

@property (strong, nonatomic) IBOutlet UILabel *userAccountLabel;
@property (strong, nonatomic) IBOutlet UITextField *userAccountField;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) UIAlertView *cancelUpdateAssetAccountabilityConfirmation;

@end
