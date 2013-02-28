//
//  ServiceRequests.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/25/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceRequests : NSObject

/*
 ServiceRequests
 "{
 serviceRequestId: ""REQ-0001"",
 requestor: ""UACCT-0001"",
 assetId: ""ASSET-0003"",
 admin: ""admin userID here"",
 assetTypeId: ""ATYPE-0001"",
 lifecycleId: ""LIFE-0002"",
 serviceId: ""SVC-0004"",
 cost: 999.99,
 remarks: ""Repair Condura Aircon - Cooling fan is broken"",
 scheduledDate: 01-02-2013,
 status: 1
 }"
 */

@property (strong, nonatomic) NSString *serviceRequestId;
@property (strong, nonatomic) NSString *requestor;
@property (strong, nonatomic) NSString *assetId;
@property (strong, nonatomic) NSString *admin;
@property (strong, nonatomic) NSString *assetTypeId;
@property (strong, nonatomic) NSString *lifecycleId;
@property (strong, nonatomic) NSString *serviceId;
@property (strong, nonatomic) NSString *cost;
@property (strong, nonatomic) NSString *remarks;
@property (strong, nonatomic) NSString *scheduledDate;
@property (strong, nonatomic) NSString *status;

@end
