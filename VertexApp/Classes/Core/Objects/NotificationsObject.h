//
//  NotificationsObject.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/9/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationsObject : NSObject

@property (nonatomic, retain) NSNumber * broadcastGroupId;
@property (nonatomic, retain) NSNumber * creator;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * notificationId;
@property (nonatomic, retain) NSNumber * noticePriorityId;
@property (nonatomic, retain) NSDate   * dateCreated;
@property (nonatomic, retain) NSDate   * endDate;
@property (nonatomic, retain) NSDate   * validity;

@end
