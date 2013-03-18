//
//  Notifications.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BroadcastGroups;

@interface Notifications : NSManagedObject

@property (nonatomic, retain) NSNumber * broadcastGroupId;
@property (nonatomic, retain) NSNumber * creator;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * notificationId;
@property (nonatomic, retain) NSNumber * priorityLevel;
@property (nonatomic, retain) BroadcastGroups *notificationToBroadcastGroup;

@end
