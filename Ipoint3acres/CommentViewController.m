//
//  CommentViewController.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/26.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import "CommentViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CommentViewController ()

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
	// Do any additional setup after loading the view.
    self.navView.layer.masksToBounds = NO;
    self.navView.layer.cornerRadius = 2; // if you like rounded corners
    self.navView.layer.shadowOffset = CGSizeMake(-2, 2);
    self.navView.layer.shadowRadius = 1;
    self.navView.layer.shadowOpacity = 0.1;
    self.navView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.navView.bounds].CGPath;
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

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)send:(id)sender {
}
@end
