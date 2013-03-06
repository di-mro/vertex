//
//  ContactDetails.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/25/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactDetails : NSObject

/*
 contactDetails:
 [
 {
 email: ""pat@rick.com"",
 mobile: ""+6399999999"",
 address: ""Here, there, everywhere""
 }
 ]
 */

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *address;

@end
