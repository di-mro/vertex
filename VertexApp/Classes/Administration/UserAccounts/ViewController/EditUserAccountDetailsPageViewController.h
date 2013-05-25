//
//  EditUserAccountDetailsPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/6/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditUserAccountDetailsPageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *editUserAccountDetailsScroller;

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;

@property (strong, nonatomic) IBOutlet UILabel *contactInformationLabel;
@property (strong, nonatomic) IBOutlet UILabel *wirelineLabel;
@property (strong, nonatomic) IBOutlet UITextField *wirelineField;

@property (strong, nonatomic) IBOutlet UILabel *wirelessLabel;
@property (strong, nonatomic) IBOutlet UITextField *wirelessField;

@property (strong, nonatomic) IBOutlet UILabel *emailAddressLabel;
@property (strong, nonatomic) IBOutlet UITextField *emailAddressField;

@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UITextField *addressField;

@property (strong, nonatomic) UIPickerView *userAccountsPicker;
@property (strong, nonatomic) NSMutableArray *userAccountsPickerArray;
@property (strong, nonatomic) NSMutableArray *userInfoIdArray;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) NSMutableDictionary *users;
@property int selectedIndex;

@property (strong, nonatomic) NSNumber *userInfoId;
@property (strong, nonatomic) NSMutableDictionary *userInfo;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) UIAlertView *cancelEditUserAccountDetailsConfirmation;


@end
