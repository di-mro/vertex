//
//  AttributeUnits.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/8/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MeasurementUnits;

@interface AttributeUnits : NSManagedObject

@property (nonatomic, retain) NSNumber * unitId;
@property (nonatomic, retain) NSNumber * attributeId;
@property (nonatomic, retain) MeasurementUnits *attributeUnitsToMeasurementUnits;
@property (nonatomic, retain) NSManagedObject *attributeUnitsToAttributes;

@end
