//
//  PollQuestions.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PollResults;

@interface PollQuestions : NSManagedObject

@property (nonatomic, retain) NSNumber * pollId;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSSet *pollQuestionsToPollResults;

@end

@interface PollQuestions (CoreDataGeneratedAccessors)

- (void)addPollQuestionsToPollResultsObject:(PollResults *)value;
- (void)removePollQuestionsToPollResultsObject:(PollResults *)value;
- (void)addPollQuestionsToPollResults:(NSSet *)values;
- (void)removePollQuestionsToPollResults:(NSSet *)values;

@end
