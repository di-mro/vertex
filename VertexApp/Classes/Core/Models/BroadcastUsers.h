//
//  BroadcastUsers.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserAccounts, BroadcastGroups;

@interface BroadcastUsers : NSManagedObject

@property (nonatomic, retain) NSNumber * broadcastGroupId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) BroadcastGroups *broadcastUsersToBroadcastGroups;
@property (nonatomic, retain) UserAccounts *broadcastUsersToUserAccount;

@end
