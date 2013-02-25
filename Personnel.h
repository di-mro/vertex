//
//  Personnel.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/25/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactDetails.h";

@interface Personnel : NSObject

/*
 Personnels
 "{
 personnelId: ""PERSON-0001"",
 personnelName: ""Patrack Chua"",
 position: ""Head Security Officer"",
 contactDetails:
 [
 {
 email: ""pat@rick.com"",
 mobile: ""+6399999999"",
 address: ""Here, there, everywhere""
 }
 ]
 }
 */

@property (strong, nonatomic) NSString *personnelId;
@property (strong, nonatomic) NSString *personnelName;
@property (strong, nonatomic) NSString *position;
@property (strong, nonatomic) ContactDetails *contactDetails;

@end
