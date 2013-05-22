//
//  EsseDetailPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/12/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EsseDetailPageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *esseDetailTextArea;

@property (strong, nonatomic) NSNumber *esseId;
@property (strong, nonatomic) NSMutableDictionary *esseInfo;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;


@end
