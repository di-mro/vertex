//
//  AssetOwnership.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Assets, Esse;

@interface AssetOwnership : NSManagedObject

@property (nonatomic, retain) NSNumber * assetId;
@property (nonatomic, retain) NSNumber * esseId;
@property (nonatomic, retain) Assets *assetOwnershipToAsset;
@property (nonatomic, retain) Esse *assetOwnershipToEsse;

@end
