//
//  Memoranda.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/9/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Memoranda : NSObject

@property (nonatomic, retain) NSNumber * broadcastGroupId;
@property (nonatomic, retain) NSNumber * creator;
@property (nonatomic, retain) NSData   * file;
@property (nonatomic, retain) NSString * memorandaDesc;
@property (nonatomic, retain) NSNumber * memorandumId;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate   * dateCreated;
@property (nonatomic, retain) NSString * from;

@end
