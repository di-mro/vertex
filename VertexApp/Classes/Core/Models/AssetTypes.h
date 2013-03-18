//
//  AssetTypes.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/13/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssetTypeAttributesTemplate, AssetTypeLifecycles, Assets;

@interface AssetTypes : NSManagedObject

@property (nonatomic, retain) NSString * assetTypeDesc;
@property (nonatomic, retain) NSNumber * assetTypeId;
@property (nonatomic, retain) NSString * assetTypeName;
@property (nonatomic, retain) Assets *assetTypeToAsset;
@property (nonatomic, retain) AssetTypeAttributesTemplate *assetTypeToAssetTypeAttributes;
@property (nonatomic, retain) NSSet *assetTypeToAssetTypeLifecycle;
@end

@interface AssetTypes (CoreDataGeneratedAccessors)

- (void)addAssetTypeToAssetTypeLifecycleObject:(AssetTypeLifecycles *)value;
- (void)removeAssetTypeToAssetTypeLifecycleObject:(AssetTypeLifecycles *)value;
- (void)addAssetTypeToAssetTypeLifecycle:(NSSet *)values;
- (void)removeAssetTypeToAssetTypeLifecycle:(NSSet *)values;

@end
