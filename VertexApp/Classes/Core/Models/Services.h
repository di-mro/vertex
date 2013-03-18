//
//  Services.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LifecycleServices, ServiceRequests;

@interface Services : NSManagedObject

@property (nonatomic, retain) NSNumber * serviceId;
@property (nonatomic, retain) NSString * serviceName;
@property (nonatomic, retain) LifecycleServices *servicesToLifecycleServices;
@property (nonatomic, retain) ServiceRequests *servicesToSR;
@end

@interface Services (CoreDataGeneratedAccessors)

- (void)addServicesToLifecycleServicesObject:(LifecycleServices *)value;
- (void)removeServicesToLifecycleServicesObject:(LifecycleServices *)value;
- (void)addServicesToLifecycleServices:(NSSet *)values;
- (void)removeServicesToLifecycleServices:(NSSet *)values;

@end
