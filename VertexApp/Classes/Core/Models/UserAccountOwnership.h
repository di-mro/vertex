//
//  UserAccountOwnership.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserAccounts, Esse;

@interface UserAccountOwnership : NSManagedObject

@property (nonatomic, retain) NSNumber * esseId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) Esse *userAccountOwnershipToEsse;
@property (nonatomic, retain) UserAccounts *userAccountOwnershipToUserAccounts;

@end
