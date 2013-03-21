//
//  Lifecycles.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/19/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssetTypeLifecycles;

@interface Lifecycles : NSManagedObject

@property (nonatomic, retain) NSString * lifecycleDesc;
@property (nonatomic, retain) NSNumber * lifecycleId;
@property (nonatomic, retain) NSString * lifecycleName;
@property (nonatomic, retain) NSNumber * prevLifecycle;
@property (nonatomic, retain) AssetTypeLifecycles *lifecycleToAssetTypeLifecycle;

@end
