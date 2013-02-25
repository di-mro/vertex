//
//  UserInfo.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/25/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

/*
 UserInfo
 "{
 userInfoId: ""UINFO-0001"",
 lastName: ""Mina"",
 firstName: ""Diara"",
 middleName: ""Anorao"",
 suffix: ""Sr"",
 email: ""diaramina@yahoo.com""
 }"
 */

@property (strong, nonatomic) NSString *userInfoId;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *middleName;
@property (strong, nonatomic) NSString *suffix;
@property (strong, nonatomic) NSString *email;

@end
