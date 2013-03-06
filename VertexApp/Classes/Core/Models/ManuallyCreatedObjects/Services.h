//
//  Services.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/25/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Services : NSObject

/*
 Services
 "{
 serviceId: ""SVC-0004"",
 serviceName: ""Repair cooling fan""
 }
 */

@property (strong, nonatomic) NSString *serviceId;
@property (strong, nonatomic) NSString *serviceName;

@end
