//
//  DisplaySRViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/15/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ViewController.h"

@interface DisplaySRViewController : ViewController

@property (strong, nonatomic) IBOutlet UILabel *assetLabel;
@property (strong, nonatomic) IBOutlet UITextField *assetField;

@property (strong, nonatomic) IBOutlet UILabel *lifecycleLabel;
@property (strong, nonatomic) IBOutlet UITextField *lifecycleField;

@property (strong, nonatomic) IBOutlet UILabel *serviceLabel;
@property (strong, nonatomic) IBOutlet UITextField *serviceField;

@property (strong, nonatomic) IBOutlet UILabel *priorityLabel;
@property (strong, nonatomic) IBOutlet UITextField *priorityField;

@property (strong, nonatomic) IBOutlet UILabel *srDetailsLabel;
@property (strong, nonatomic) IBOutlet UITextView *srDetailsTextArea;

@property (strong, nonatomic) IBOutlet UILabel *srDateLabel;
@property (strong, nonatomic) IBOutlet UITextField *srDateField;

@property (strong, nonatomic) IBOutlet UIScrollView *displaySRScroller;


@end
