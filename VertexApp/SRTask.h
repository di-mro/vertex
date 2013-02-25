//
//  SRTask.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/25/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tasks.h";

@interface SRTask : NSObject

/*
 Tasks
 "{
 taskId : ""TASK-0001""
 serviceRequestId: ""REQ-0001"",
 description: ""Repair Condura Aircon"",
 tasks:
 [
 {taskName: ""Dismantle Aircon"", personnelId: ""PERSON-0001"", isDone: false/true},
 {taskName: ""Replace Fan"", personnelId: ""PERSON-0002"", isDone: false/true},
 {taskName: ""Install Fan"", personnelId: ""PERSON-0002"", isDone: false/true},
 {taskName: ""Nth Task Here"", personnelID: PERSONN, isDone: false/true},
 ]
 }"
 */

@property (strong, nonatomic) NSString *taskId;
@property (strong, nonatomic) NSString *serviceRequestId;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) Tasks *tasks;

@end
