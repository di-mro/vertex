//
//  AssetSupers.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Assets;

@interface AssetSupers : NSManagedObject

@property (nonatomic, retain) NSNumber * assetId;
@property (nonatomic, retain) NSNumber * superId;
@property (nonatomic, retain) NSSet *assetSupersToAssets;
@end

@interface AssetSupers (CoreDataGeneratedAccessors)

- (void)addAssetSupersToAssetsObject:(Assets *)value;
- (void)removeAssetSupersToAssetsObject:(Assets *)value;
- (void)addAssetSupersToAssets:(NSSet *)values;
- (void)removeAssetSupersToAssets:(NSSet *)values;

@end
