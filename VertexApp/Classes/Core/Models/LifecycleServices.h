//
//  LifecycleServices.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssetTypeLifecycles, Services;

@interface LifecycleServices : NSManagedObject

@property (nonatomic, retain) NSNumber * assetTypeLifecycleId;
@property (nonatomic, retain) id services;
@property (nonatomic, retain) AssetTypeLifecycles *lifecycleServicesToAssetTypeLifecycle;
@property (nonatomic, retain) Services *lifecycleServicesToServices;
@end

@interface LifecycleServices (CoreDataGeneratedAccessors)

- (void)addLifecycleServicesToServicesObject:(Services *)value;
- (void)removeLifecycleServicesToServicesObject:(Services *)value;
- (void)addLifecycleServicesToServices:(NSSet *)values;
- (void)removeLifecycleServicesToServices:(NSSet *)values;

@end
