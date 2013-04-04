//
//  CreateNoticePageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/3/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNoticePageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *createNoticeScroller;

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UITextView *messageTextArea;

@property (strong, nonatomic) IBOutlet UILabel *priorityLevelLabel;
@property (strong, nonatomic) IBOutlet UITextField *priorityLevelField;

@property (strong, nonatomic) IBOutlet UILabel *userGroupNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *userGroupNameField;

@property (strong, nonatomic) IBOutlet UILabel *validityLabel;
@property (strong, nonatomic) IBOutlet UITextField *validityField;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;


@end
