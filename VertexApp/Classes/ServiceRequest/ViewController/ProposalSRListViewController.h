//
//  ProposalSRListViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 5/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProposalSRListViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *srForProposalAsset;
@property (nonatomic, retain) NSMutableArray *srForProposalService;
@property (nonatomic, retain) NSMutableArray *srForProposalSRIds;

@property (nonatomic, retain) NSMutableArray *srForProposalEntries;
@property (nonatomic, retain) NSMutableArray *srForProposalDate;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) NSMutableDictionary *srForProposalDictionary;

@property (strong, nonatomic) NSNumber *selectedSRId;
@property (strong, nonatomic) NSNumber *statusId;


@end
