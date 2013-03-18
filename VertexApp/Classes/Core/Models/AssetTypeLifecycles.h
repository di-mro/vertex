//
//  AssetTypeLifecycles.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssetTypes, LifecycleServices, Lifecycles;

@interface AssetTypeLifecycles : NSManagedObject

@property (nonatomic, retain) NSNumber * assetTypeId;
@property (nonatomic, retain) NSNumber * assetTypeLifecycleId;
@property (nonatomic, retain) NSNumber * lifecycleId;
@property (nonatomic, retain) Lifecycles *assetTypeLifecycleToLifecycle;
@property (nonatomic, retain) LifecycleServices *assetTypeLifecycleToLifecycleServices;
@property (nonatomic, retain) AssetTypes *assetTypeLifeycleToAssetType;
@end

@interface AssetTypeLifecycles (CoreDataGeneratedAccessors)

- (void)addAssetTypeLifecycleToLifecycleObject:(Lifecycles *)value;
- (void)removeAssetTypeLifecycleToLifecycleObject:(Lifecycles *)value;
- (void)addAssetTypeLifecycleToLifecycle:(NSSet *)values;
- (void)removeAssetTypeLifecycleToLifecycle:(NSSet *)values;

@end
