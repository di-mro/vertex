//
//  UserAccountsObject.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/10/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAccountsObject : NSObject


@property (nonatomic, retain) NSNumber *userId;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password; //added field
@property (nonatomic, retain) NSNumber *userProfileId;
@property (nonatomic, retain) NSNumber *userInfoId;
@property (nonatomic, retain) NSString *token; //added field

//fields from data model
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * credentialId;

@end
