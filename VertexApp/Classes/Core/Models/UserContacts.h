//
//  UserContacts.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContactInfo, UserInfo;

@interface UserContacts : NSManagedObject

@property (nonatomic, retain) NSNumber * contactInfoId;
@property (nonatomic, retain) NSNumber * userInfoId;
@property (nonatomic, retain) ContactInfo *userContactToContactInfo;
@property (nonatomic, retain) UserInfo *userContactToUserInfo;

@end
