//
//  ApprovalSRPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 5/20/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAccountInfoManager.h"
#import "UserAccountsObject.h"


@interface ApprovalSRPageViewController : UIViewController
{
  UserAccountInfoManager *userAccountInfoSQLManager;
  UserAccountsObject *userAccountsObject;
}


@property (strong, nonatomic) IBOutlet UIScrollView *approvalSRPageScroller;
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

@property CGRect addNotesButtonFrame;
@property CGRect schedulesLabelFrame;
@property CGRect statusLabelFrame;
@property CGRect statusFieldFrame;
@property CGRect authorLabelFrame;
@property CGRect authorFieldFrame;
@property CGRect addScheduleButtonFrame;

@property CGRect fromDateLabelFrame;
@property CGRect fromDateFieldFrame;
@property CGRect fromTimeLabelFrame;
@property CGRect fromTimeFieldFrame;
@property CGRect toDateLabelFrame;
@property CGRect toDateFieldFrame;
@property CGRect toTimeLabelFrame;
@property CGRect toTimeFieldFrame;

@property CGRect separatorFrame;

@property (strong, nonatomic) NSMutableArray *statusArray;
@property (strong, nonatomic) NSMutableArray *authorArray;
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
@property (strong, nonatomic) NSMutableArray *approvalNotesArray;
@property (strong, nonatomic) NSMutableArray *schedulesStatusArray;
@property (strong, nonatomic) NSMutableArray *schedulesAuthorArray;

@property (strong, nonatomic) NSString *fromDate;
@property (strong, nonatomic) NSString *fromTime;
@property (strong, nonatomic) NSString *toDate;
@property (strong, nonatomic) NSString *toTime;

@property (strong, nonatomic) NSMutableDictionary *serviceRequestJson;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) UIAlertView *cancelSRApprovalConfirmation;


@property (strong, nonatomic) IBOutlet UIButton *addNotesButton;
- (IBAction)addNotes:(id)sender;


@end
