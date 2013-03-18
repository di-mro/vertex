//
//  Memoranda.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BroadcastGroups;

@interface Memoranda : NSManagedObject

@property (nonatomic, retain) NSNumber * broadcastGroupId;
@property (nonatomic, retain) NSNumber * creator;
@property (nonatomic, retain) NSData * file;
@property (nonatomic, retain) NSString * memorandaDesc;
@property (nonatomic, retain) NSNumber * memorandumId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) BroadcastGroups *memorandaToBroadcastGroup;

@end
