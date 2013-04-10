//
//  ServiceRequestSchedulesObject.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/9/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceRequestSchedulesObject : NSObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * scheduleId;
@property (nonatomic, retain) NSNumber * serviceRequestId;

@end
