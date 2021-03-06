//
//  UserCredentials.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserAccounts;

@interface UserCredentials : NSManagedObject

@property (nonatomic, retain) NSNumber * credentialId;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * revision;
@property (nonatomic, retain) NSString * salt;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) UserAccounts *userCredentialsToUserAccount;

@end
