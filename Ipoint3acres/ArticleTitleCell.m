//
//  ArticleTitleCell.m
//  Ipoint3acres
//
//  Created by YUAN on 14-2-2.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "ArticleTitleCell.h"
#import "HTMLParser.h"
#import "InfoURLMapper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "OPCoreText.h"

#define kUserRichText   NO

@interface ArticleTitleCell  ()

@end

@implementation ArticleTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setArticle:(Article *)article {
    _article = article;
    self.useRichText = kUserRichText;

    [self.authorName setTitle:article.authorName forState:UIControlStateNormal];
    self.createDate.text = article.createDate;
    self.lastCommenter.text = article.lastCommenter;
    self.lastCommentDate.text = article.lastCommentDate;
    self.viewCount.text = [NSString stringWithFormat:@"阅:%d 评:%d", article.viewCount, article.commentCount];
    
    NSString *avatarPath = [[InfoURLMapper sharedInstance] getAvatarURLforUser:article.authorID];
    [self.avatar setImageWithURL:[NSURL URLWithString:avatarPath] placeholderImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height/2.0f;
    self.avatar.clipsToBounds = YES;
    
    if (self.useRichText) {
        NSAttributedString *title = [[NSAttributedString alloc] initWithHTMLData:article.titleData options:[HTMLParser sharedInstance].attributedTitleOptions documentAttributes:nil];
        self.titleLabel.attributedText = title;
    } else {
        self.titleLabel.text = article.title;
    }

//    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
//    NSAttributedString *title = [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
//    self.title.attributedText = [NSAttributedString attributedStringWithData:article.titleData];
}

+ (CGFloat)heightForArticle:(Article *)article {
    NSString *text = article.title;
    CGSize constraint = CGSizeMake(300.0f, FLT_MAX);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = 55.0f + size.height + 10.0f;
    return height;
}

@end
