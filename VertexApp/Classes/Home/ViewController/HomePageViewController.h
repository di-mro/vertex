//
//  HomePageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/13/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageViewController : UIViewController

- (void)displayHomePageEntries;

@property (nonatomic, retain) NSMutableArray *homePageEntries;
@property (nonatomic, retain) NSMutableArray *homePageIcons;

-(void) logout;


@end
