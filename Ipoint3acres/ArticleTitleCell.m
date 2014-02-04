//
//  ArticleTitleCell.m
//  Ipoint3acres
//
//  Created by YUAN on 14-2-2.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "ArticleTitleCell.h"
#import "DTCoreText.h"

@implementation ArticleTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    // update cell view
    NSData *data = [article.title dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    NSAttributedString *title = [[NSAttributedString alloc] initWithData:data options:options
                                                      documentAttributes:nil error:nil];
//    [NSAttributedString alloc] initWithCoder:(NSCoder *)
    self.title.attributedText = title;
    self.authorName.titleLabel.text = article.authorName;
    self.createDate.text = article.createDate;
    self.lastCommenter.text = article.lastCommenter;
    self.lastCommentDate.text = article.lastCommentDate;
    int view = article.viewCount;
    int comment = article.commentCount;
    self.viewCount.text = [NSString stringWithFormat:@"查看:%d 评论:%d", view, comment];
}

@end
