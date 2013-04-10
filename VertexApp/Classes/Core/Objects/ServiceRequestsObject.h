//
//  ServiceRequestsObject.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/9/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceRequestsObject : NSObject

@property (nonatomic, retain) NSNumber * admin;
@property (nonatomic, retain) NSNumber * assetId;
@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSDate   * dateCreated;
@property (nonatomic, retain) NSNumber * lifecycleId;
@property (nonatomic, retain) NSNumber * priorityId;
@property (nonatomic, retain) NSString * remarks;
@property (nonatomic, retain) NSNumber * requestor;
@property (nonatomic, retain) NSNumber * serviceId;
@property (nonatomic, retain) NSNumber * serviceRequestId;
@property (nonatomic, retain) NSNumber * statusId;
@property (nonatomic, retain) NSString * adminRemarks;

@end
