//
//  MasterBills.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/8/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bills;

@interface MasterBills : NSManagedObject

@property (nonatomic, retain) NSNumber * billId;
@property (nonatomic, retain) NSNumber * subBillId;
@property (nonatomic, retain) NSSet *masterBillsToBills;
@end

@interface MasterBills (CoreDataGeneratedAccessors)

- (void)addMasterBillsToBillsObject:(Bills *)value;
- (void)removeMasterBillsToBillsObject:(Bills *)value;
- (void)addMasterBillsToBills:(NSSet *)values;
- (void)removeMasterBillsToBills:(NSSet *)values;

@end
