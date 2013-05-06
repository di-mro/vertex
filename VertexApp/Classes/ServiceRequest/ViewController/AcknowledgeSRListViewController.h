//
//  AcknowledgeSRListViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 5/6/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcknowledgeSRListViewController : UIViewController


@property (nonatomic, retain) NSMutableArray *srForAcknowledgementAsset;
@property (nonatomic, retain) NSMutableArray *srForAcknowledgementService;
@property (nonatomic, retain) NSMutableArray *srForAcknowledgementSRIds;

@property (nonatomic, retain) NSMutableArray *srForAcknowledgementEntries;
@property (nonatomic, retain) NSMutableArray *srForAcknowledgementDate;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) NSMutableDictionary *srForAcknowledgementDictionary;

@property (strong, nonatomic) NSNumber *selectedSRId;
@property (strong, nonatomic) NSNumber *statusId;



@end
