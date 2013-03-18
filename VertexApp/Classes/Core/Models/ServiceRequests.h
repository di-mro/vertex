//
//  ServiceRequests.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Assets, Feedbacks, Priorities, ServiceRequestSchedules, Services, Statuses, Tasks, UserAccounts;

@interface ServiceRequests : NSManagedObject

@property (nonatomic, retain) NSNumber * admin;
@property (nonatomic, retain) NSNumber * assetId;
@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * lifecycleId;
@property (nonatomic, retain) NSNumber * priorityId;
@property (nonatomic, retain) NSString * remarks;
@property (nonatomic, retain) NSNumber * requestor;
@property (nonatomic, retain) NSNumber * serviceId;
@property (nonatomic, retain) NSNumber * serviceRequestId;
@property (nonatomic, retain) NSNumber * statusId;
@property (nonatomic, retain) Assets *srToAsset;
@property (nonatomic, retain) Feedbacks *srToFeedbacks;
@property (nonatomic, retain) Priorities *srToPriorities;
@property (nonatomic, retain) Services *srToServices;
@property (nonatomic, retain) ServiceRequestSchedules *srToSRSchedule;
@property (nonatomic, retain) Statuses *srToStatuses;
@property (nonatomic, retain) Tasks *srToTasks;
@property (nonatomic, retain) UserAccounts *srToUserAccount;
@end

@interface ServiceRequests (CoreDataGeneratedAccessors)

- (void)addSrToSRScheduleObject:(ServiceRequestSchedules *)value;
- (void)removeSrToSRScheduleObject:(ServiceRequestSchedules *)value;
- (void)addSrToSRSchedule:(NSSet *)values;
- (void)removeSrToSRSchedule:(NSSet *)values;

- (void)addSrToUserAccountObject:(UserAccounts *)value;
- (void)removeSrToUserAccountObject:(UserAccounts *)value;
- (void)addSrToUserAccount:(NSSet *)values;
- (void)removeSrToUserAccount:(NSSet *)values;

@end
