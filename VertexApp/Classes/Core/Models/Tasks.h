//
//  Tasks.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Personnels, ServiceRequests;

@interface Tasks : NSManagedObject

@property (nonatomic, retain) NSNumber * serviceRequestId;
@property (nonatomic, retain) NSString * taskDescription;
@property (nonatomic, retain) NSNumber * taskId;
@property (nonatomic, retain) NSString * taskName;
@property (nonatomic, retain) NSNumber * assignedTo;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSSet *tasksToPersonnels;
@property (nonatomic, retain) ServiceRequests *tasksToSR;

@end

@interface Tasks (CoreDataGeneratedAccessors)

- (void)addTasksToPersonnelsObject:(Personnels *)value;
- (void)removeTasksToPersonnelsObject:(Personnels *)value;
- (void)addTasksToPersonnels:(NSSet *)values;
- (void)removeTasksToPersonnels:(NSSet *)values;

@end
