//
//  AssetAccountables.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Assets, UserAccounts;

@interface AssetAccountables : NSManagedObject

@property (nonatomic, retain) NSNumber * assetId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) Assets *assetAccountabilityToAsset;
@property (nonatomic, retain) UserAccounts *assetAccountabilityToUserAccount;

@end
