//
//  ProfileFunctions.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SystemFunctions, UserProfiles;

@interface ProfileFunctions : NSManagedObject

@property (nonatomic, retain) NSNumber * profileId;
@property (nonatomic, retain) NSNumber * systemFunctionId;
@property (nonatomic, retain) UserProfiles *profileFunctionsToUserProfile;
@property (nonatomic, retain) SystemFunctions *profileFunctionToSystemFunctions;

@end
