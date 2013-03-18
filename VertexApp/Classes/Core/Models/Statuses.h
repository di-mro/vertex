//
//  Statuses.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ServiceRequests;

@interface Statuses : NSManagedObject

@property (nonatomic, retain) NSString * statusDescription;
@property (nonatomic, retain) NSNumber * statusId;
@property (nonatomic, retain) NSString * statusName;
@property (nonatomic, retain) ServiceRequests *statusesToSR;

@end
