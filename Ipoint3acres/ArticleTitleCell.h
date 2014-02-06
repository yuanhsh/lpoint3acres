//
//  ArticleTitleCell.h
//  Ipoint3acres
//
//  Created by YUAN on 14-2-2.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Article.h"

@interface ArticleTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *createDate;
@property (weak, nonatomic) IBOutlet UILabel *lastCommenter;
@property (weak, nonatomic) IBOutlet UILabel *lastCommentDate;
@property (weak, nonatomic) IBOutlet UILabel *viewCount;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) Article *article;
@property (assign, nonatomic) BOOL useRichText;

+ (CGFloat)heightForArticle:(Article *)article;
@end
