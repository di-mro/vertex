//
//  ServiceRequestSchedulesObject.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/9/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceRequestSchedulesObject : NSObject

@property (nonatomic, retain) NSString * toDate;
@property (nonatomic, retain) NSNumber * scheduleId;
@property (nonatomic, retain) NSNumber * serviceRequestId;
@property (nonatomic, retain) NSString * toTime;
@property (nonatomic, retain) NSString * toTimezone;
@property (nonatomic, retain) NSString * fromDate;
@property (nonatomic, retain) NSString * fromTime;
@property (nonatomic, retain) NSString * fromTimezone;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * author;
@property (nonatomic, retain) NSNumber * statusId;

@end
