//
//  LoginViewController.h
//  Ipoint3acres
//
//  Created by YUAN on 14-2-17.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceClient.h"

@interface LoginViewController : UIViewController<WebServiceDelegate>

@property (strong, nonatomic) NSString *notificationName;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *submit;
- (IBAction)login:(id)sender;

@end
