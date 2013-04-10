//
//  BroadcastGroups.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BroadcastUsers, MemorandaObject, Notifications;

@interface BroadcastGroups : NSManagedObject

@property (nonatomic, retain) NSNumber * broadcastGroupId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) MemorandaObject *broadcastGroupsToMemoranda;
@property (nonatomic, retain) BroadcastUsers *broadcastGroupToBroadcastUsers;
@property (nonatomic, retain) Notifications *broadcastGroupToNotifications;
@end

@interface BroadcastGroups (CoreDataGeneratedAccessors)

- (void)addBroadcastGroupToBroadcastUsersObject:(BroadcastUsers *)value;
- (void)removeBroadcastGroupToBroadcastUsersObject:(BroadcastUsers *)value;
- (void)addBroadcastGroupToBroadcastUsers:(NSSet *)values;
- (void)removeBroadcastGroupToBroadcastUsers:(NSSet *)values;

@end
