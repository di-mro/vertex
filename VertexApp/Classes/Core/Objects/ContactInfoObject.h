//
//  ContactInfoObject.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/9/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactInfoObject : NSObject

@property (nonatomic, retain) NSNumber * contactInfoId;
@property (nonatomic, retain) NSNumber * contactTypeId;
@property (nonatomic, retain) NSNumber * primary;
@property (nonatomic, retain) NSString * value;

@end
