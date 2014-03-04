//
//  OpenSourceViewController.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/03/04.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "OpenSourceViewController.h"

@interface OpenSourceViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation OpenSourceViewController

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
    self.navigationItem.title = @"开源组件许可";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ios_libraries" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    
	for(UIView *v in [[[self.webView subviews] objectAtIndex:0] subviews]) {
        if([v isKindOfClass:[UIImageView class]]) {
            v.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
