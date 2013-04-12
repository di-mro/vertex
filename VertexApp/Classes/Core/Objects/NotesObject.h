//
//  NotesObject.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotesObject : NSObject

@property (nonatomic, retain) NSNumber * noteId;
@property (nonatomic, retain) NSNumber * serviceRequestId;
@property (nonatomic, retain) NSNumber * sender;
@property (nonatomic, retain) NSString * creationDate;
@property (nonatomic, retain) NSString * creationTime;
@property (nonatomic, retain) NSString * creationTimezone;
@property (nonatomic, retain) NSString * note;

@end
