//
//  UpdateAssetOwnershipPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/3/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateAssetOwnershipPageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *updateAssetOwnershipScroller;

@property (strong, nonatomic) IBOutlet UILabel *assetNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *assetNameField;

@property (strong, nonatomic) IBOutlet UILabel *esseInfoLabel;
@property (strong, nonatomic) IBOutlet UITextField *esseInfoField;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) UIAlertView *cancelUpdateAssetOwnershipConfirmation;


@end
