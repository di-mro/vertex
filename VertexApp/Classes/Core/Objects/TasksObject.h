//
//  TasksObject.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/10/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TasksObject : NSObject

@property (nonatomic, retain) NSNumber * serviceRequestId;
@property (nonatomic, retain) NSString * taskDescription;
@property (nonatomic, retain) NSNumber * taskId;
@property (nonatomic, retain) NSString * taskName;
@property (nonatomic, retain) NSNumber * assignedTo;
@property (nonatomic, retain) NSNumber * status;

@end
