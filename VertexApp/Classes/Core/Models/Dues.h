//
//  Dues.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RecurringBills;

@interface Dues : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * dueDescription;
@property (nonatomic, retain) NSNumber * dueId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) RecurringBills *duesToRecurringBills;

@end
