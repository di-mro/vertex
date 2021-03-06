//
//  OneTimeBills.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bills;

@interface OneTimeBills : NSManagedObject

@property (nonatomic, retain) NSNumber * billId;
@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSNumber * serviceRequestId;
@property (nonatomic, retain) Bills *oneTimeBillToBills;

@end
