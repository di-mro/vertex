//
//  Assets.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssetAccountability, AssetAttributes, AssetOwnership, AssetSupers, AssetTypes, ManagedAssets, ServiceRequests;

@interface Assets : NSManagedObject

@property (nonatomic, retain) NSNumber * assetId;
@property (nonatomic, retain) NSString * assetName;
@property (nonatomic, retain) NSNumber * assetTypeId;
@property (nonatomic, retain) NSSet *assetToAssetAccountability;
@property (nonatomic, retain) NSSet *assetToAssetAttributes;
@property (nonatomic, retain) AssetOwnership *assetToAssetOwnership;
@property (nonatomic, retain) NSSet *assetToAssetSupers;
@property (nonatomic, retain) AssetTypes *assetToAssetType;
@property (nonatomic, retain) ManagedAssets *assetToManagedAsset;
@property (nonatomic, retain) NSSet *assetToServiceRequests;
@end

@interface Assets (CoreDataGeneratedAccessors)

- (void)addAssetToAssetAccountabilityObject:(AssetAccountability *)value;
- (void)removeAssetToAssetAccountabilityObject:(AssetAccountability *)value;
- (void)addAssetToAssetAccountability:(NSSet *)values;
- (void)removeAssetToAssetAccountability:(NSSet *)values;

- (void)addAssetToAssetAttributesObject:(AssetAttributes *)value;
- (void)removeAssetToAssetAttributesObject:(AssetAttributes *)value;
- (void)addAssetToAssetAttributes:(NSSet *)values;
- (void)removeAssetToAssetAttributes:(NSSet *)values;

- (void)addAssetToAssetSupersObject:(AssetSupers *)value;
- (void)removeAssetToAssetSupersObject:(AssetSupers *)value;
- (void)addAssetToAssetSupers:(NSSet *)values;
- (void)removeAssetToAssetSupers:(NSSet *)values;

- (void)addAssetToServiceRequestsObject:(ServiceRequests *)value;
- (void)removeAssetToServiceRequestsObject:(ServiceRequests *)value;
- (void)addAssetToServiceRequests:(NSSet *)values;
- (void)removeAssetToServiceRequests:(NSSet *)values;

@end
