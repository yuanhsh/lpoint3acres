//
//  ArticleTitleCell.h
//  Ipoint3acres
//
//  Created by YUAN on 14-2-2.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface ArticleTitleCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UITextView *title;
@property (strong, nonatomic) IBOutlet UIButton *authorName;
@property (strong, nonatomic) IBOutlet UILabel *createDate;
@property (strong, nonatomic) IBOutlet UILabel *lastCommenter;
@property (strong, nonatomic) IBOutlet UILabel *lastCommentDate;
@property (strong, nonatomic) IBOutlet UILabel *viewCount;
@property (weak, nonatomic) Article *article;
@end
