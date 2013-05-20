//
//  InspectSRPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 5/8/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspectSRPageViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIScrollView *inspectSRScroller;

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
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UITextField *statusField;

@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UITextField *authorField;

@property CGRect addNotesButtonFrame;
@property CGRect schedulesLabelFrame;
@property CGRect scheduleStatusLabelFrame;
@property CGRect scheduleStatusFieldFrame;
@property CGRect scheduleAuthorLabelFrame;
@property CGRect scheduleAuthorFieldFrame;
@property CGRect addScheduleButtonFrame;

@property CGRect fromDateLabelFrame;
@property CGRect fromDateFieldFrame;
@property CGRect fromTimeLabelFrame;
@property CGRect fromTimeFieldFrame;
@property CGRect toDateLabelFrame;
@property CGRect toDateFieldFrame;
@property CGRect toTimeLabelFrame;
@property CGRect toTimeFieldFrame;

@property (strong, nonatomic) NSMutableArray *fromDatesArray;
@property (strong, nonatomic) NSMutableArray *fromTimesArray;
@property (strong, nonatomic) NSMutableArray *toDatesArray;
@property (strong, nonatomic) NSMutableArray *toTimesArray;

@property (strong, nonatomic) NSMutableDictionary *scheduleFromDateDictionary;
@property (strong, nonatomic) NSMutableDictionary *scheduleToDateDictionary;

@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSNumber *serviceRequestId;
@property (strong, nonatomic) NSMutableDictionary *serviceRequestInfo;

@property (strong, nonatomic) NSNumber *statusId;
@property (strong, nonatomic) NSMutableArray *notesTextAreaArray;
@property (strong, nonatomic) NSMutableArray *inspectionNotesArray;
@property (strong, nonatomic) NSMutableArray *schedulesStatusArray;
@property (strong, nonatomic) NSMutableArray *schedulesAuthorArray;

@property (strong, nonatomic) NSMutableDictionary *serviceRequestJson;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSString *fromDate;
@property (strong, nonatomic) NSString *fromTime;
@property (strong, nonatomic) NSString *toDate;
@property (strong, nonatomic) NSString *toTime;

@property (strong, nonatomic) UIAlertView *cancelSRInspectionConfirmation;

@property (strong, nonatomic) IBOutlet UIButton *addNotesButton;
- (IBAction)addNotes:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *addSchedulesButton;
- (IBAction)addInspectionScheduleFields:(id)sender;

@end
