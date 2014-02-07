//
//  RefreshableViewController.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/07.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface RefreshableViewController : UITableViewController <EGORefreshTableHeaderDelegate>

- (void)startRefreshingTableView;
- (void)stopRefreshingTableView;

@end