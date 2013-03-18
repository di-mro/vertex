//
//  PersonnelContacts.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContactInfo, PersonnelInfo;

@interface PersonnelContacts : NSManagedObject

@property (nonatomic, retain) NSNumber * contactInfoId;
@property (nonatomic, retain) NSNumber * personnelInfoId;
@property (nonatomic, retain) ContactInfo *personnelContactToContactInfo;
@property (nonatomic, retain) PersonnelInfo *personnelContactToPersonnelInfo;

@end
