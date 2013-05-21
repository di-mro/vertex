//
//  ApprovalSRListViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 5/20/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApprovalSRListViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *srForApprovalAsset;
@property (nonatomic, retain) NSMutableArray *srForApprovalService;
@property (nonatomic, retain) NSMutableArray *srForApprovalSRIds;

@property (nonatomic, retain) NSMutableArray *srForApprovalEntries;
@property (nonatomic, retain) NSMutableArray *srForApprovalDate;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) NSMutableDictionary *srForApprovalDictionary;

@property (strong, nonatomic) NSNumber *selectedSRId;
@property (strong, nonatomic) NSNumber *statusId;

@end
