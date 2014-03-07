//
//  CommentViewController.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/26.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import "CommentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "SVProgressHUD.h"

@interface CommentViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;
@property (nonatomic, strong) ServiceClient *client;
@property (nonatomic, strong) NSMutableDictionary *formData;
@end

@implementation CommentViewController

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
    self.formData = nil;
    self.client = [[ServiceClient alloc] initWithDelegate:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];

    if (!self.client.loginedUserId) {
        static NSString *userLoginNotification = @"UserLoginNotification";
        LoginViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginController"];
        loginController.notificationName = userLoginNotification;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getReplyFormData) name:userLoginNotification object:nil];
        
        [self addChildViewController:loginController];
        [self.view addSubview:loginController.view];
        [loginController didMoveToParentViewController:self];
        CGFloat offsetY = 64.0f;
        loginController.view.frame = CGRectMake(0, offsetY, self.view.bounds.size.width, self.view.bounds.size.height-offsetY);
        self.titleLabel.text = @"登录";
        self.sendBtn.hidden = YES;
    } else {
        [self getReplyFormData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getReplyFormData {
    self.titleLabel.text = @"回复";
    [self.textView becomeFirstResponder];
    [self.client loadReplyFormData:self.comment];
    [Flurry logEvent:@"加载回复页面"];
}

- (void)keyboardWillShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    self.keyboardHeight.constant = height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)send:(id)sender {
    NSString *message = self.textView.text;
    message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (message.length < 8) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"抱歉，您的帖子小于 8 个字符的限制" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    } else if (message.length >= 50000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"抱歉，您的帖子大于 50000 个字符的限制" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    } else {
        [self.formData setValue:message forKey:@"message"];
        [self.client postReplyMessage:self.comment parameters:self.formData];
        [SVProgressHUD showWithStatus:@"正在发布..."];
    }
}

#pragma mark WebServiceDelegate methods

- (void)didLoadReplyFormData:(NSMutableDictionary *)data {
    self.formData = data;
    self.sendBtn.hidden = NO;
}

- (void)didPostReplyMessage:(BOOL)successed {
    if (successed) {
        [SVProgressHUD showSuccessWithStatus:@"发布成功！"];
        NSInteger commentCount = [self.comment.article.commentCount integerValue];
        self.comment.article.commentCount = @(commentCount + 1);
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kCommentSuccessNotification object:nil];
    }
}
@end
