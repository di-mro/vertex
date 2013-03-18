//
//  RecurringBills.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bills, Dues;

@interface RecurringBills : NSManagedObject

@property (nonatomic, retain) NSNumber * billId;
@property (nonatomic, retain) NSNumber * dueId;
@property (nonatomic, retain) Dues *recurringBillsToDues;
@property (nonatomic, retain) Bills *recurringBillToBills;
@end

@interface RecurringBills (CoreDataGeneratedAccessors)

- (void)addRecurringBillsToDuesObject:(Dues *)value;
- (void)removeRecurringBillsToDuesObject:(Dues *)value;
- (void)addRecurringBillsToDues:(NSSet *)values;
- (void)removeRecurringBillsToDues:(NSSet *)values;

@end
