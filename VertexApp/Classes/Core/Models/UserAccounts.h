//
//  UserAccounts.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/13/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssetAccountability, Bills, BroadcastUsers, ServiceRequests, UserAccountOwnership, UserCredentials, UserInfo, UserProfiles;

@interface UserAccounts : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * credentialId;
@property (nonatomic, retain) NSNumber * profileId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * userInfoId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) AssetAccountability *userAccountToAssetAccountability;
@property (nonatomic, retain) Bills *userAccountToBills;
@property (nonatomic, retain) BroadcastUsers *userAccountToBroadcastUsers;
@property (nonatomic, retain) ServiceRequests *userAccountToServiceRequest;
@property (nonatomic, retain) UserAccountOwnership *userAccountToUserAccountOwnership;
@property (nonatomic, retain) UserCredentials *userAccountToUserCredential;
@property (nonatomic, retain) UserInfo *userAccountToUserInfo;
@property (nonatomic, retain) UserProfiles *userAccountToUserProfile;
@end

@interface UserAccounts (CoreDataGeneratedAccessors)

- (void)addUserAccountToAssetAccountabilityObject:(AssetAccountability *)value;
- (void)removeUserAccountToAssetAccountabilityObject:(AssetAccountability *)value;
- (void)addUserAccountToAssetAccountability:(NSSet *)values;
- (void)removeUserAccountToAssetAccountability:(NSSet *)values;

- (void)addUserAccountToBillsObject:(Bills *)value;
- (void)removeUserAccountToBillsObject:(Bills *)value;
- (void)addUserAccountToBills:(NSSet *)values;
- (void)removeUserAccountToBills:(NSSet *)values;

- (void)addUserAccountToBroadcastUsersObject:(BroadcastUsers *)value;
- (void)removeUserAccountToBroadcastUsersObject:(BroadcastUsers *)value;
- (void)addUserAccountToBroadcastUsers:(NSSet *)values;
- (void)removeUserAccountToBroadcastUsers:(NSSet *)values;

- (void)addUserAccountToServiceRequestObject:(ServiceRequests *)value;
- (void)removeUserAccountToServiceRequestObject:(ServiceRequests *)value;
- (void)addUserAccountToServiceRequest:(NSSet *)values;
- (void)removeUserAccountToServiceRequest:(NSSet *)values;

- (void)addUserAccountToUserCredentialObject:(UserCredentials *)value;
- (void)removeUserAccountToUserCredentialObject:(UserCredentials *)value;
- (void)addUserAccountToUserCredential:(NSSet *)values;
- (void)removeUserAccountToUserCredential:(NSSet *)values;

@end
