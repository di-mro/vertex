//
//  Feedback.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/25/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feedback : NSObject

/*
 Feedback
 "{
 serviceRequestId: ""REQ-0001"",
 rating: 1 - 10 score,
 comment: ""Rant/Rave/Commendation Here""
 }"
 */

@property (strong, nonatomic) NSString *serviceRequestId;
@property NSInteger *rating;
@property (strong, nonatomic) NSString *comments;

@end
