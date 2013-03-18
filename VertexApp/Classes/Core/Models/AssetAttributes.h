//
//  AssetAttributes.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Assets;

@interface AssetAttributes : NSManagedObject

@property (nonatomic, retain) NSNumber * assetId;
@property (nonatomic, retain) NSString * keyName;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) Assets *assetAttributesToAssets;

@end
