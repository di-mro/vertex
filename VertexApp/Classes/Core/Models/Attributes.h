//
//  Attributes.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/8/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AttributeUnits;

@interface Attributes : NSManagedObject

@property (nonatomic, retain) NSString * keyName;
@property (nonatomic, retain) NSNumber * attributeId;
@property (nonatomic, retain) AttributeUnits *attributesToAttributeUnits;

@end
