//
//  NoticePriorities.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/8/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Notifications;

@interface NoticePriorities : NSManagedObject

@property (nonatomic, retain) NSNumber * noticePriorityId;
@property (nonatomic, retain) NSNumber * priorityLevel;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * noticePrioritiesDesc;
@property (nonatomic, retain) Notifications *noticePrioritiesToNotifications;

@end
