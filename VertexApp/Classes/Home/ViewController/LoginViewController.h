//
//  LoginViewController.h
//  VertexApp
//
//  Created by Mary Rose Oh on 2/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *userNameField;

@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;
@property (strong, nonatomic) NSString *token;

- (IBAction)login:(id)sender;


@end
