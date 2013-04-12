//
//  UpdateEssePageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/12/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateEssePageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *updateEsseScroller;

@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;

@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;

@property (strong, nonatomic) IBOutlet UILabel *middleNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *middleNameField;

@property (strong, nonatomic) IBOutlet UILabel *contactInformationLabel;
@property (strong, nonatomic) IBOutlet UILabel *wirelineLabel;
@property (strong, nonatomic) IBOutlet UITextField *wirelineField;

@property (strong, nonatomic) IBOutlet UILabel *wirelessLabel;
@property (strong, nonatomic) IBOutlet UITextField *wirelessField;

@property (strong, nonatomic) IBOutlet UILabel *emailAddressLabel;
@property (strong, nonatomic) IBOutlet UITextField *emailAddressField;

@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UITextField *addressField;

@property (strong, nonatomic) NSNumber *esseId;
@property (strong, nonatomic) NSMutableDictionary *esseInfo;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@end
