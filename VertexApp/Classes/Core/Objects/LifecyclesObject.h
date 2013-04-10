//
//  LifecyclesObject.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/9/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LifecyclesObject : NSObject

@property (nonatomic, retain) NSString * lifecycleDesc;
@property (nonatomic, retain) NSNumber * lifecycleId;
@property (nonatomic, retain) NSString * lifecycleName;
@property (nonatomic, retain) NSNumber * prevLifecycle;

@end
