//
//  ContactTypes.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContactInfo;

@interface ContactTypes : NSManagedObject

@property (nonatomic, retain) NSNumber * contactTypeId;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) ContactInfo *contactTypeToContactInfo;

@end
