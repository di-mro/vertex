//
//  AddUserProfileViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/6/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddUserProfilePageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *addUserProfileScroller;

@property (strong, nonatomic) IBOutlet UILabel *userProfileNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *userProfileNameField;

@property (strong, nonatomic) IBOutlet UILabel *addUserAccountsLabel;
@property (strong, nonatomic) IBOutlet UITextField *addUserAccountsField;

@property (strong, nonatomic) IBOutlet UITableView *userAccountsTableView;
@property (strong, nonatomic) NSMutableArray *userAccountsArray;

@property (strong, nonatomic) UIPickerView *userAccountsPicker;
@property (strong, nonatomic) NSMutableArray *userAccountsPickerArray;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSMutableDictionary *users;
@property int selectedIndex;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) UIAlertView *cancelAddUserProfileConfirmation;

- (IBAction)addUserAccount:(id)sender;


@end
