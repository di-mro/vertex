//
//  Bills.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OneTimeBills, RecurringBills, UserAccounts;

@interface Bills : NSManagedObject

@property (nonatomic, retain) NSNumber * billedTo;
@property (nonatomic, retain) NSNumber * billId;
@property (nonatomic, retain) NSString * billsDescription;
@property (nonatomic, retain) NSNumber * creator;
@property (nonatomic, retain) NSData * file;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) OneTimeBills *billsToOneTimeBills;
@property (nonatomic, retain) RecurringBills *billsToRecurringBills;
@property (nonatomic, retain) UserAccounts *billsToUserAccount;

@end