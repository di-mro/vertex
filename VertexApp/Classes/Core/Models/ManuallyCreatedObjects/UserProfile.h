//
//  UserProfile.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/25/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

/*
 UserProfiles
 "{
 profileId: ""UPROF-0001"",
 profileName: ""Admin"",
 description: ""Administrator""
 }
 */

@property (strong, nonatomic) NSString *profileId;
@property (strong, nonatomic) NSString *profileName;
@property (strong, nonatomic) NSString *description;

@end
