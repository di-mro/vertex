//
//  ContactInfo.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContactTypes, EsseContacts, PersonnelContacts, UserContacts;

@interface ContactInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * contactInfoId;
@property (nonatomic, retain) NSNumber * contactTypeId;
@property (nonatomic, retain) NSNumber * primary;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) ContactTypes *contactInfoToContactType;
@property (nonatomic, retain) EsseContacts *contactInfoToEsse;
@property (nonatomic, retain) PersonnelContacts *contactInfoToPersonnel;
@property (nonatomic, retain) UserContacts *contactInfoToUserContact;

@end
