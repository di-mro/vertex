//
//  UserAccountsObject.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/10/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAccountsObject : NSObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * credentialId;
@property (nonatomic, retain) NSNumber * profileId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * userInfoId;
@property (nonatomic, retain) NSString * userName;

@end
