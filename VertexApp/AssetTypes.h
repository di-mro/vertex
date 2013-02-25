//
//  AssetTypes.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/25/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetTypes : NSObject

/*
 AssetTypes
 "{
 assetTypeId: ""ATYPE-0001"",
 assetTypeName: ""Air Conditioner"",
 description: ""Cooling Appliance""
 }
 */

@property (strong, nonatomic) NSString *assetTypeId;
@property (strong, nonatomic) NSString *assetTypeName;
@property (strong, nonatomic) NSString *description;

@end
