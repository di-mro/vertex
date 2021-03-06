//
//  AcknowledgeSRPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 5/6/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAccountInfoManager.h"
#import "UserAccountsObject.h"


@interface AcknowledgeSRPageViewController : UIViewController
{
  UserAccountInfoManager *userAccountInfoSQLManager;
  UserAccountsObject *userAccountsObject;
}


@property (strong, nonatomic) IBOutlet UIScrollView *acknowledgeSRScroller;

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

@property (strong, nonatomic) IBOutlet UILabel *notesLabel;
@property (strong, nonatomic) IBOutlet UITextView *notesTextArea;

@property (strong, nonatomic) NSNumber *userId;

@property (strong, nonatomic) NSNumber *serviceRequestId;
@property (strong, nonatomic) NSMutableDictionary *serviceRequestInfo;

@property (strong, nonatomic) NSNumber *statusId;
@property (strong, nonatomic) NSMutableArray *notesTextAreaArray;

@property (strong, nonatomic) NSMutableDictionary *serviceRequestJson;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) UIAlertView *cancelSRAcknowledgementConfirmation;
@property (strong, nonatomic) UIAlertView *rejectSRAcknowledgementConfirmation;

@property (strong, nonatomic) IBOutlet UIButton *addNotesButton;
- (IBAction)addNotes:(id)sender;

@end
