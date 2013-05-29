//
//  LoginViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAccountInfoManager.h"
#import "sqlite3.h"


@interface LoginViewController : UIViewController
{
  //sqlite3 *db;
  UserAccountInfoManager *userAccountInfoSQLManager;
}


@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;

@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) NSMutableDictionary *userInfo;

@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSNumber *userProfileId;
@property (strong, nonatomic) NSNumber *userInfoId;
@property (strong, nonatomic) NSString *token;

- (IBAction)login:(id)sender;

/*
//SQLite
-(NSString *) getFilePath;

-(void) openDB;

-(void) createTable: (NSString *) tableName
         withField1: (NSNumber *) field1
         withField2: (NSString *) field2
         withField3: (NSString *) field3
         withField4: (NSNumber *) field4
         withField5: (NSNumber *) field5
         withField6: (NSString *) field6;

-(void) saveUserInfo;
*/

@end
