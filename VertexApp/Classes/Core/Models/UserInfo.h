//
//  UserInfo.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/13/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserAccounts, UserContacts;

@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * suffix;
@property (nonatomic, retain) NSNumber * userInfoId;
@property (nonatomic, retain) UserAccounts *userInfoToUserAccounts;
@property (nonatomic, retain) UserContacts *userInfoToUserContacts;
@end

@interface UserInfo (CoreDataGeneratedAccessors)

- (void)addUserInfoToUserContactsObject:(UserContacts *)value;
- (void)removeUserInfoToUserContactsObject:(UserContacts *)value;
- (void)addUserInfoToUserContacts:(NSSet *)values;
- (void)removeUserInfoToUserContacts:(NSSet *)values;

@end
