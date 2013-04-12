//
//  Bills.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/10/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "Bills.h"
#import "MasterBills.h"
#import "OneTimeBills.h"
#import "RecurringBills.h"
#import "UserAccounts.h"


@implementation Bills

@dynamic billedTo;
@dynamic billId;
@dynamic billsDescription;
@dynamic creator;
@dynamic file;
@dynamic title;
@dynamic url;
@dynamic dueDate;
@dynamic billsToMasterBills;
@dynamic billsToOneTimeBills;
@dynamic billsToRecurringBills;
@dynamic billsToUserAccount;

@end
