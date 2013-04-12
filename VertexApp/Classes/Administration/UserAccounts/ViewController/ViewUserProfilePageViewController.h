//
//  ViewUserProfilePageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewUserProfilePageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *viewUserProfileScroller;

@property (strong, nonatomic) IBOutlet UILabel *userProfileNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *userProfileNameField;

@property (strong, nonatomic) IBOutlet UILabel *userProfileUserAccountsLabel;

@property (strong, nonatomic) IBOutlet UITableView *userProfileUserAccountsTableView;
@property (strong, nonatomic) UIPickerView *userProfileNamePicker;
@property (strong, nonatomic) NSMutableArray *userProfilePickerArray;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSMutableArray *userProfileUserAccountsArray;

@property (strong, nonatomic) NSMutableDictionary *userProfiles;
@property int selectedIndex;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@end
