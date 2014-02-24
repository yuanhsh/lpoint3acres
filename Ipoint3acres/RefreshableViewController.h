//
//  RefreshableViewController.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/07.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"

@interface RefreshableViewController : UITableViewController <EGORefreshTableHeaderDelegate>

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, strong) MJRefreshFooterView *refreshFooterView;

- (void)triggerRefreshTableView;

- (void)startRefreshingTableView;
- (void)stopRefreshingTableView;

- (void)startLoadingMoreData;
- (void)stopLoadingMoreData;

- (void)dismissLoadingHeaderAndFooter;
@end
