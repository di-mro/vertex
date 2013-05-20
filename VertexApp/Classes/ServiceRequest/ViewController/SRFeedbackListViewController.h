//
//  SRFeedbackListViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/1/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRFeedbackListViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *srForFeedbackAsset;
@property (nonatomic, retain) NSMutableArray *srForFeedbackService;
@property (nonatomic, retain) NSMutableArray *srForFeedbackSRIds;

@property (nonatomic, retain) NSMutableArray *srForFeedbackEntries;
@property (nonatomic, retain) NSMutableArray *srForFeedbackDate;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) NSMutableDictionary *srForFeedbackDictionary;

@property (strong, nonatomic) NSNumber *selectedSRId;
@property (strong, nonatomic) NSNumber *statusId;


@end
