//
//  SRFeedbackPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/1/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRFeedbackPageViewController : UIViewController

- (void) displaySRFeedbackPageQuestions;

@property (nonatomic, retain) NSMutableArray *displaySRFeedbackQuestions;

@property (strong, nonatomic) IBOutlet UITextView *srCommentsTextArea;
@property (strong, nonatomic) IBOutlet UIScrollView *srFeedbackScroller;

@property float srRatings;

@end
