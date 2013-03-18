//
//  Feedbacks.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ServiceRequests;

@interface Feedbacks : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * serviceRequestId;
@property (nonatomic, retain) ServiceRequests *feedbacksToSR;

@end
