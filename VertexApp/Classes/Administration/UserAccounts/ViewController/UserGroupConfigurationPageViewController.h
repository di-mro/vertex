//
//  UserGroupConfigurationPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/5/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserGroupConfigurationPageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *userGroupConfigScroller;

@property (strong, nonatomic) IBOutlet UILabel *userGroupNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *userGroupNameField;

@property (strong, nonatomic) IBOutlet UILabel *addUserAccountsLabel;
@property (strong, nonatomic) IBOutlet UITextField *addUserAccountsField;

@property (strong, nonatomic) IBOutlet UITableView *addUserAccountsTableView;
@property (strong, nonatomic) NSMutableArray *userAccountsArray;

@property (strong, nonatomic) UIPickerView *userAccountsPicker;
@property (strong, nonatomic) NSMutableArray *userAccountsPickerArray;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSMutableDictionary *users;
@property int selectedIndex;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

- (IBAction)addUserAccounts:(id)sender;


@end
