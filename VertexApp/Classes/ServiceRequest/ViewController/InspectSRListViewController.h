//
//  InspectSRListViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 5/8/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspectSRListViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *srForInspectionAsset;
@property (nonatomic, retain) NSMutableArray *srForInspectionService;
@property (nonatomic, retain) NSMutableArray *srForInspectionSRIds;

@property (nonatomic, retain) NSMutableArray *srForInspectionEntries;
@property (nonatomic, retain) NSMutableArray *srForInspectionDate;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) NSMutableDictionary *srForInspectionDictionary;

@property (strong, nonatomic) NSNumber *selectedSRId;
@property (strong, nonatomic) NSNumber *statusId;


@end
