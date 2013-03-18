//
//  AssetAccountability.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Assets.h"


@class Assets;

@interface AssetAccountability : NSManagedObject

@property (nonatomic, retain) NSNumber * assetId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) Assets *assetAccountabilityToAsset;
@property (nonatomic, retain) AssetAccountability *assetAccountabilityToUserAccount;

@end
