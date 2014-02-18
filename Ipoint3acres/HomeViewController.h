//
//  HomeViewController.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/01/30.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickTabView.h"
#import "BoardViewController.h"

@interface HomeViewController : UIViewController <UIPageViewControllerDelegate,UIPageViewControllerDataSource,FlickTabViewDataSource,FlickTabViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) FlickTabView *flickTabView;
@property (nonatomic, strong) UIPageViewController *pageViewController;

- (IBAction)showUserProfile:(id)sender;
@end
