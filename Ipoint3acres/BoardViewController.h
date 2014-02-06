//
//  BoardViewController.h
//  Ipoint3acres
//
//  Created by YUAN on 14-2-2.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceClient.h"
#import "Board.h"

@interface BoardViewController : UITableViewController <WebServiceDelegate>

@property (nonatomic, strong) Board *board;
@property (nonatomic, strong) ServiceClient *service;
@property (nonatomic, strong) NSOrderedSet *articles;

@end
