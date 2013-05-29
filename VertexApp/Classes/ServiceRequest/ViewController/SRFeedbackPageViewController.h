//
//  SRFeedbackPageViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/1/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAccountInfoManager.h"
#import "UserAccountsObject.h"

@interface SRFeedbackPageViewController : UIViewController
{
  UserAccountInfoManager *userAccountInfoSQLManager;
  UserAccountsObject *userAccountsObject;
}


@property (strong, nonatomic) IBOutlet UITextView *srCommentsTextArea;
@property (strong, nonatomic) IBOutlet UIScrollView *srFeedbackScroller;

@property int srRatings;
@property (strong, nonatomic) NSMutableArray *srFeedbackRatingsArray;

@property (strong, nonatomic) UIAlertView *cancelSRFeedbackConfirmation;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) NSNumber *userId;

@property (strong, nonatomic) NSNumber *serviceRequestId;

@property (strong, nonatomic) NSNumber *topicId;
@property (strong, nonatomic) NSMutableDictionary *srFeedbackInfo;

@property (strong, nonatomic) NSMutableArray *srFeedbackQuestions;
@property (strong, nonatomic) NSMutableArray *srFeedbackQuestionId;

@property (strong, nonatomic) NSMutableDictionary *addFeebackJson;


@end
