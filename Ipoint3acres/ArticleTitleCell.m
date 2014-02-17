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

- (void)setIsViewed:(BOOL)isViewed {
    _isViewed = isViewed;
    self.article.isViewed = @(isViewed);
    if ([self.article.isStick boolValue]) {
        self.titleLabel.textColor = [UIColor purpleColor];
    } else if (isViewed) {
        self.titleLabel.textColor = [UIColor grayColor];
    } else {
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

- (void)setArticle:(Article *)article {
    _article = article;
    self.useRichText = kUserRichText;
    self.authorName.textColor = RGBCOLOR(0, 122, 255);

    self.authorName.text = article.authorName;
    self.createDate.text = article.createDate;
    self.lastCommenter.text = article.lastCommenter;
    self.lastCommentDate.text = [article.lastCommentDate chinaTimeToLocalTime];
    int viewCount = [article.viewCount intValue];
    int commentCount = [article.commentCount intValue];
    self.viewCount.text = [NSString stringWithFormat:@"阅:%d 评:%d", viewCount, commentCount];
    
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
    if ([self.article.isStick boolValue]) {
        self.titleLabel.textColor = [UIColor purpleColor];
    } else if ([self.article.isViewed boolValue]) {
        self.titleLabel.textColor = [UIColor grayColor];
    } else {
        self.titleLabel.textColor = [UIColor blackColor];
    }

//    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
//    NSAttributedString *title = [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
//    self.title.attributedText = [NSAttributedString attributedStringWithData:article.titleData];
}

+ (CGFloat)heightForArticle:(Article *)article {
    static NSMutableDictionary *heightCache = nil;
    if (!heightCache) {
        heightCache = [NSMutableDictionary dictionaryWithCapacity:50];
    }
    if (heightCache[article.articleID]) {
        NSNumber *result = heightCache[article.articleID];
        return [result floatValue];
    }
    
    NSString *text = article.title;
    CGSize constraint = CGSizeMake(300.0f, FLT_MAX);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = 55.0f + size.height + 10.0f;
    
    [heightCache setValue:@(height) forKey:article.articleID];
    return height;
}

@end
