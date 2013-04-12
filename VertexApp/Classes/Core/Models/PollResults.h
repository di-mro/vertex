//
//  PollResults.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Feedbacks;

@interface PollResults : NSManagedObject

@property (nonatomic, retain) NSNumber * feedbackId;
@property (nonatomic, retain) NSNumber * pollId;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) Feedbacks *pollResultsToFeedbacks;
@property (nonatomic, retain) NSManagedObject *pollResultsToPollQuestions;

@end
