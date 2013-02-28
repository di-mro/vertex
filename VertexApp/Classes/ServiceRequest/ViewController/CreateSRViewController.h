//
//  CreateSRViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/15/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ViewController.h"
#import "SRObject.h"

@interface CreateSRViewController : ViewController
@property (strong, nonatomic) IBOutlet UIScrollView *createSRScroller;
@property (strong, nonatomic) IBOutlet UIPickerView *srGenericPicker;
@property (strong, nonatomic) IBOutlet NSArray *currentArray;
@property (strong, nonatomic) IBOutlet UITextField *currentTextField;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameField;

@property (strong, nonatomic) IBOutlet UILabel *unitLocationLabel;
@property (strong, nonatomic) IBOutlet UITextField *unitLocationField;

@property (strong, nonatomic) IBOutlet UILabel *contactNumberLabel;
@property (strong, nonatomic) IBOutlet UITextField *contactNumberField;

@property (strong, nonatomic) IBOutlet UILabel *chooseAssetLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *assetPicker;
@property (nonatomic, retain) NSArray *assetPickerArray;
@property (strong, nonatomic) IBOutlet UITextField *assetField;

@property (strong, nonatomic) IBOutlet UILabel *chooseLifecycleLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *lifecyclePicker;
@property (nonatomic, retain) NSArray *lifecyclePickerArray;
@property (strong, nonatomic) IBOutlet UITextField *lifecycleField;


@property (strong, nonatomic) IBOutlet UILabel *chooseServicePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *servicePicker;
@property (nonatomic, retain) NSArray *servicePickerArray;
@property (strong, nonatomic) IBOutlet UITextField *serviceField;

@property (strong, nonatomic) IBOutlet UILabel *priorityLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *priorityPicker;
@property (nonatomic, retain) NSArray *priorityPickerArray;
@property (strong, nonatomic) IBOutlet UITextField *priorityField;

@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;
@property (strong, nonatomic) IBOutlet UITextView *detailsTextArea;

@property (strong, nonatomic) SRObject *srObject;


@end
