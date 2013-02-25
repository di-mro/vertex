//
//  Lifecycles.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/25/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lifecycles : NSObject

/*
 Lifecycles
 "{
 lifecycleId: ""LIFE-0001"",
 lifeCycleName: ""Commission""
 lifeCycleDescription : ""Commission""
 }
 */

@property (strong, nonatomic) NSString *lifecycleId;
@property (strong, nonatomic) NSString *lifeCycleName;
@property (strong, nonatomic) NSString *lifeCycleDescription;

@end
