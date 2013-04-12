//
//  RemoveEssePageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/12/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoveEssePageViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *removeEssePageEntries;

@property (nonatomic, retain) NSMutableArray *esseNameArray;
@property (nonatomic, retain) NSMutableArray *esseIdArray;
@property (nonatomic, retain) NSMutableDictionary *esse;
@property (nonatomic, retain) NSNumber *selectedEsseId;

@property (nonatomic, strong) NSString *URL;
@property int httpResponseCode;

@end
