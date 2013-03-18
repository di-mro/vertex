//
//  UserProfiles.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserAccounts, ProfileFunctions;

@interface UserProfiles : NSManagedObject

@property (nonatomic, retain) NSNumber * profileId;
@property (nonatomic, retain) NSString * profileName;
@property (nonatomic, retain) NSString * userProfileDescription;
@property (nonatomic, retain) ProfileFunctions *userProfilesToProfileFunctions;
@property (nonatomic, retain) UserAccounts *userProfileToUserAccount;
@end

@interface UserProfiles (CoreDataGeneratedAccessors)

- (void)addUserProfilesToProfileFunctionsObject:(ProfileFunctions *)value;
- (void)removeUserProfilesToProfileFunctionsObject:(ProfileFunctions *)value;
- (void)addUserProfilesToProfileFunctions:(NSSet *)values;
- (void)removeUserProfilesToProfileFunctions:(NSSet *)values;

@end
