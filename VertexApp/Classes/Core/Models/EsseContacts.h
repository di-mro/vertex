//
//  EsseContacts.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContactInfo, EsseInfo;

@interface EsseContacts : NSManagedObject

@property (nonatomic, retain) NSNumber * contactInfoId;
@property (nonatomic, retain) NSNumber * esseInfoId;
@property (nonatomic, retain) ContactInfo *esseContactToContactInfo;
@property (nonatomic, retain) EsseInfo *esseContactToEsseInfo;

@end
