//
//  ServiceRequestSchedules.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ServiceRequests;

@interface ServiceRequestSchedules : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * scheduleId;
@property (nonatomic, retain) NSNumber * serviceRequestId;
@property (nonatomic, retain) ServiceRequests *srScheduleToSR;

@end
