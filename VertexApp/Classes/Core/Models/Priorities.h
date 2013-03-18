//
//  Priorities.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ServiceRequests;

@interface Priorities : NSManagedObject

@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * priorityDescription;
@property (nonatomic, retain) NSNumber * priorityId;
@property (nonatomic, retain) NSString * priorityName;
@property (nonatomic, retain) ServiceRequests *prioritiesToSR;

@end
