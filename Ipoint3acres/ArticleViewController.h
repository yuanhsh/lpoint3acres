//
//  ArticleViewController.h
//  Ipoint3acres
//
//  Created by YUAN on 14-2-6.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshableViewController.h"
#import "Models.h"
#import "ServiceClient.h"

@interface ArticleViewController : RefreshableViewController <WebServiceDelegate>

@property (nonatomic, strong) Article *article;
@property (nonatomic, strong) ServiceClient *service;
@property (nonatomic, strong) NSOrderedSet *comments;
@property (nonatomic, strong) NSString *articleID;

@end
