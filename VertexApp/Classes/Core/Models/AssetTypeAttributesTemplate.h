//
//  AssetTypeAttributesTemplate.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssetTypes;

@interface AssetTypeAttributesTemplate : NSManagedObject

@property (nonatomic, retain) NSNumber * assetTypeId;
@property (nonatomic, retain) id attributes;
@property (nonatomic, retain) AssetTypes *assetTypeAttributesToAssetTypes;

@end
