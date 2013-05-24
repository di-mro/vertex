//
//  ProvisioningSRListViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 5/22/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvisioningSRListViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *srForProvisioningAsset;
@property (nonatomic, retain) NSMutableArray *srForProvisioningService;
@property (nonatomic, retain) NSMutableArray *srForProvisioningSRIds;

@property (nonatomic, retain) NSMutableArray *srForProvisioningEntries;
@property (nonatomic, retain) NSMutableArray *srForProvisioningDate;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) NSMutableDictionary *srForProvisioningDictionary;

@property (strong, nonatomic) NSNumber *selectedSRId;
@property (strong, nonatomic) NSNumber *statusId;


@end
