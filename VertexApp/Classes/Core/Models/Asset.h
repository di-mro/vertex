//
//  Asset.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/25/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Asset : NSObject

/*
 Assets
 "{
 assetId: ""ASSET-0001"",
 assetName: ""GreenField Tower1"",
 assetTypeId: ""ATYPE-0001"",
 parentAsset: ""None""
 }
 */

@property (strong, nonatomic) NSString *assetId;
@property (strong, nonatomic) NSString *assetName;
@property (strong, nonatomic) NSString *assetTypeId;
@property (strong, nonatomic) NSString *parentAsset;


@end
