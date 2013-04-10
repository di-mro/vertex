//
//  MeasurementUnits.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/8/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssetAttributes;

@interface MeasurementUnits : NSManagedObject

@property (nonatomic, retain) NSNumber * unitId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * restriction;
@property (nonatomic, retain) NSString * abbreviate;
@property (nonatomic, retain) AssetAttributes *measurementUnitsToAssetAttributes;
@property (nonatomic, retain) NSManagedObject *measurementUnitsToAttributeUnits;

@end
