//
//  UserAccountInfoManager.h
//  VertexApp
//
//  Created by Mary Rose Oh on 5/28/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "UserAccountsObject.h"


@interface UserAccountInfoManager : NSObject
{
  sqlite3 *db;
}


-(void) openDB;

-(void) createTable: (NSString *) tableName
         withField1: (NSNumber *) field1
         withField2: (NSString *) field2
         withField3: (NSString *) field3
         withField4: (NSNumber *) field4
         withField5: (NSNumber *) field5
         withField6: (NSString *) field6;

-(void) saveUserInfo: (NSNumber *) userId
                    : (NSString *) username
                    : (NSString *) password
                    : (NSNumber *) userProfileId
                    : (NSNumber *) userInfoId
                    : (NSString *) token;

-(UserAccountsObject *) getUserAccountInfo;

-(void) truncateUserAccounts;


@end
