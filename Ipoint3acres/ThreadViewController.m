//
//  ThreadViewController.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/03/17.
//  Copyright (c) 2014年 Haisheng Yuan. All rights reserved.
//

#import "ThreadViewController.h"
#import "ArticleViewController.h"

@interface ThreadViewController ()

@end

@implementation ThreadViewController

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
    
    ArticleViewController *articleController = [self.storyboard instantiateViewControllerWithIdentifier:@"articleController"];
    articleController.article = self.article;
	[self addChildViewController:articleController];
    [self.view addSubview:articleController.view];
    [articleController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldDisplayAds{
#ifdef FREE_VERSION
    return YES;
#else
    return NO;
#endif
}

@end
