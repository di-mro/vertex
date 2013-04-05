//
//  AddAssetTypePageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/3/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAssetTypePageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *addAssetTypeScroller;

@property (strong, nonatomic) IBOutlet UILabel *assetTypeNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *assetTypeNameField;

@property (strong, nonatomic) IBOutlet UILabel *addAssetAttributesLabel;
@property (strong, nonatomic) IBOutlet UITextField *addAssetAttributesField;

@property (strong, nonatomic) IBOutlet UITableView *addAssetAttributesTable;
@property (strong, nonatomic) NSMutableArray *assetAttributesArray;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;


- (IBAction)addAssetAttributes:(id)sender;


@end
