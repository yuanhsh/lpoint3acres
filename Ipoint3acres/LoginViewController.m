//
//  LoginViewController.m
//  Ipoint3acres
//
//  Created by YUAN on 14-2-17.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary *textAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelLogin)];
    self.navigationItem.leftBarButtonItem = closeButton;
}


- (void)cancelLogin {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder && [nextResponder isKindOfClass:[UITextField class]]) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        if ([nextResponder isKindOfClass:[UIButton class]]) {
            [self login:nextResponder];
        }
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (IBAction)login:(id)sender {
    ServiceClient *client = [[ServiceClient alloc] init];
    client.delegate = self;
    [SVProgressHUD showWithStatus:@"登录中..."];
    [client loginWithUsername:self.username.text password:self.password.text];
}

- (void)loginSuccessedWithUserId:(NSString *)loginedUserId {
    NSLog(@"Success Login!");
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.notificationName) {
            double delayInSeconds = 0.2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:nil];
            });
        }
    }];
}

- (void)loginFailed {
    NSLog(@"Failed Login!");
    [SVProgressHUD dismiss];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressHUD showErrorWithStatus:@"登录失败！"];
    });
    
}
@end