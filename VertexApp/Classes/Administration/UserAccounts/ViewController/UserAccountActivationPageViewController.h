//
//  UserAccountActivationPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/5/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAccountActivationPageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *userAccountActivationScroller;

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;

@property (strong, nonatomic) IBOutlet UILabel *esseNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *esseNameField;

@property (strong, nonatomic) IBOutlet UILabel *userGroupNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *userGroupNameField;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@end
