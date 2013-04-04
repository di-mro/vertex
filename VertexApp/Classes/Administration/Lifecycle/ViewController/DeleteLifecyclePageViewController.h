//
//  DeleteLifecyclePageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/2/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeleteLifecyclePageViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *deleteLifecyclePageEntries;
@property (nonatomic, retain) NSMutableArray *lifecycleNameArray;
@property (nonatomic, retain) NSMutableArray *lifecycleIdArray;
@property (nonatomic, retain) NSMutableDictionary *lifecyclesDict;
@property (nonatomic, retain) NSNumber *selectedLifecycleId;

@property (nonatomic, strong) NSString *URL;
@property int httpResponseCode;



@end
