//
//  AssetAttributes.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/8/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Assets, MeasurementUnits;

@interface AssetAttributes : NSManagedObject

@property (nonatomic, retain) NSNumber * assetId;
@property (nonatomic, retain) NSString * keyName;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSNumber * unitId;
@property (nonatomic, retain) Assets *assetAttributesToAssets;
@property (nonatomic, retain) MeasurementUnits *assetAttributesToMeasurementUnits;

@end
