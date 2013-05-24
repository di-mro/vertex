//
//  AddLifecyclePageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/30/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddLifecyclePageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *addLifecycleScroller;

@property (strong, nonatomic) IBOutlet UILabel *lifecycleNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *lifecycleNameField;

@property (strong, nonatomic) IBOutlet UILabel *lifecycleDescriptionLabel;
@property (strong, nonatomic) IBOutlet UITextField *lifecycleDescriptionField;

@property (strong, nonatomic) IBOutlet UILabel *lifecyclePreviousLabel;
@property (strong, nonatomic) IBOutlet UITextField *lifecyclePreviousField;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) UIAlertView *cancelAddLifecycleConfirmation;


@end
