//
//  AssetTypeAttributes.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/8/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssetTypes;

@interface AssetTypeAttributes : NSManagedObject

@property (nonatomic, retain) NSNumber * assetTypeId;
@property (nonatomic, retain) NSNumber * attributeId;
@property (nonatomic, retain) NSNumber * required;
@property (nonatomic, retain) AssetTypes *assetTypeAttributesToAssetTypes;

@end
