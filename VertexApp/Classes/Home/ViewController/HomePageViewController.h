//
//  HomePageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/13/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "UserAccountInfoManager.h"
#import "UserAccountsObject.h"


@interface HomePageViewController : UIViewController
{
  UserAccountInfoManager *userAccountInfoSQLManager;
  UserAccountsObject *userAccountsObject;
}


- (void)displayHomePageEntries;

@property (strong, nonatomic) NSMutableArray *homePageEntries;
@property (strong, nonatomic) NSMutableArray *homePageIcons;

@property (strong, nonatomic) NSNumber *userProfileId;
@property (strong, nonatomic) NSString *token;

@property (strong, nonatomic) NSMutableDictionary *systemFunctionsInfo;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

-(void) logout;


@end
