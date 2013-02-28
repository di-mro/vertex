//
//  LoginCredentials.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/27/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginCredentials : NSObject

/*
 login
 "{
 username: ""
 , password: ""
 }"
 */

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end
