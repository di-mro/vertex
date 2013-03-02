//
//  SRFeedbackListViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/1/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRFeedbackListViewController : UIViewController

- (void) displaySRFeedbackListPageEntries;

@property (nonatomic, retain) NSMutableArray *displaySRFeedbackListEntries;
@property (nonatomic, retain) NSMutableArray *displaySRFeedbackSubtitles;

@end
