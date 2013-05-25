//
//  ProvisioningSRPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 5/22/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvisioningSRPageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *provisioningSRPageScroller;
@property CGFloat scrollViewHeight;

@property (strong, nonatomic) IBOutlet UILabel *assetLabel;
@property (strong, nonatomic) IBOutlet UITextField *assetField;

@property (strong, nonatomic) IBOutlet UILabel *lifecycleLabel;
@property (strong, nonatomic) IBOutlet UITextField *lifecycleField;

@property (strong, nonatomic) IBOutlet UILabel *serviceLabel;
@property (strong, nonatomic) IBOutlet UITextField *serviceField;

@property (strong, nonatomic) IBOutlet UILabel *estimatedCostLabel;
@property (strong, nonatomic) IBOutlet UITextField *estimatedCostField;

@property (strong, nonatomic) IBOutlet UILabel *dateRequestedLabel;
@property (strong, nonatomic) IBOutlet UITextField *dateRequestedField;

@property (strong, nonatomic) IBOutlet UILabel *priorityLabel;
@property (strong, nonatomic) IBOutlet UITextField *priorityField;

@property (strong, nonatomic) IBOutlet UILabel *requestorLabel;
@property (strong, nonatomic) IBOutlet UITextField *requestorField;

@property (strong, nonatomic) IBOutlet UILabel *adminLabel;
@property (strong, nonatomic) IBOutlet UITextField *adminField;

@property (strong, nonatomic) IBOutlet UILabel *notesLabel;
@property (strong, nonatomic) IBOutlet UITextView *notesTextArea;

@property (strong, nonatomic) IBOutlet UILabel *schedulesLabel;

@property (strong, nonatomic) UILabel *tasksLabel;
@property (strong, nonatomic) UITextField *personnelField;

@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIPickerView *personnelPicker;

@property (strong, nonatomic) NSMutableDictionary *personnels;

@property (strong, nonatomic) NSMutableArray *personnelNameArray;
@property (strong, nonatomic) NSMutableArray *personnelIdArray;

@property (strong, nonatomic) NSNumber *selectedPersonnelId;
@property (strong, nonatomic) NSString *selectedPersonnelName;

@property CGRect addNotesButtonFrame;
@property CGRect schedulesLabelFrame;
@property CGRect statusLabelFrame;
@property CGRect statusFieldFrame;
@property CGRect authorLabelFrame;
@property CGRect authorFieldFrame;

@property CGRect fromDateLabelFrame;
@property CGRect fromDateFieldFrame;
@property CGRect fromTimeLabelFrame;
@property CGRect fromTimeFieldFrame;
@property CGRect toDateLabelFrame;
@property CGRect toDateFieldFrame;
@property CGRect toTimeLabelFrame;
@property CGRect toTimeFieldFrame;

@property CGRect separatorFrame;
@property CGRect taskSeparatorFrame;

@property CGRect tasksLabelFrame;
@property CGRect taskNameLabelFrame;
@property CGRect taskNameFieldFrame;
@property CGRect taskDescriptionLabelFrame;
@property CGRect taskDescriptionAreaFrame;
@property CGRect personnelLabelFrame;
@property CGRect personnelFieldFrame;
@property CGRect taskStatusLabelFrame;
@property CGRect addTasksButtonFrame;
 
@property (strong, nonatomic) NSMutableArray *taskNameArray;
@property (strong, nonatomic) NSMutableArray *taskDescriptionArray;
@property (strong, nonatomic) NSMutableArray *personnelArray;
@property (strong, nonatomic) NSMutableArray *taskStatusArray;

@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSNumber *serviceRequestId;
@property (strong, nonatomic) NSMutableDictionary *serviceRequestInfo;

@property (strong, nonatomic) NSNumber *statusId;

@property (strong, nonatomic) NSMutableArray *notesTextAreaArray;
@property (strong, nonatomic) NSMutableArray *provisioningNotesArray;
@property (strong, nonatomic) NSMutableArray *schedulesStatusArray;
@property (strong, nonatomic) NSMutableArray *schedulesAuthorArray;

@property (strong, nonatomic) NSMutableDictionary *serviceRequestJson;
@property (strong, nonatomic) NSMutableDictionary *tasksJson;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) UIAlertView *cancelSRProvisioningConfirmation;


@property (strong, nonatomic) IBOutlet UIButton *addNotesButton;
- (IBAction)addNotes:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *addTasksButton;
- (IBAction)addTasks:(id)sender;


@end
