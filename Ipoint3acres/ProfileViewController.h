//
//  ProfileViewController.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/18.
//  Copyright (c) 2014年 Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceClient.h"
#import "SVProgressHUD.h"
#import "TOLAdViewController.h"

@interface ProfileViewController : TOLAdViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, WebServiceDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIImageView *avatar;
@property (strong, nonatomic) UIImageView *gender;
@property (strong, nonatomic) UITextView *infoTextView;
@property (strong, nonatomic) UITextView *signatureTextView;

@property (strong, nonatomic) NSString *userID;
@property (assign, nonatomic) BOOL viewSelf;

@end
