//
//  QuoteContentCell.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/17.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import "QuoteContentCell.h"
#import "InfoURLMapper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSAttributedString+HTML.h"
#import "HTMLParser.h"

@implementation QuoteContentCell

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

- (void)setComment:(Comment *)comment {
    _comment = comment;
    
    self.posterName.textColor = RGBCOLOR(0, 122, 255);
    self.posterName.text = comment.commenterName;
    self.postDate.text = [comment.createDate chinaTimeToLocalTime];
    
    NSString *avatarPath = [[InfoURLMapper sharedInstance] getAvatarURLforUser:comment.commenterID];
    [self.avatar setImageWithURL:[NSURL URLWithString:avatarPath] placeholderImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height/2.0f;
    self.avatar.clipsToBounds = YES;
    
    if ([comment.floorNo intValue] == 1) {
        NSData *contentData = [comment.content dataUsingEncoding:NSUTF8StringEncoding];
        NSAttributedString *attributedText = nil;
        //        if (NO) {
        //            attributedText = [[NSAttributedString alloc] initWithData:contentData
        //                                                              options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
        //                                                   documentAttributes:nil error:nil];
        //        } else {
        attributedText = [[NSAttributedString alloc] initWithHTMLData:contentData options:[HTMLParser sharedInstance].attributedTitleOptions documentAttributes:nil];
        //        }
        
        self.postContentView.attributedText = attributedText;
    } else {
        self.postContentView.text = comment.content;
    }
    
    self.quoteView.text = comment.quoteContent;
    
    self.postContentView.scrollsToTop = NO;
    self.quoteView.scrollsToTop = NO;
    
    [self  setNeedsLayout];
    
}

+ (CGFloat)heightForComment:(Comment *)comment {
    UITextView *textView = [[UITextView alloc] init];
    textView.font = [UIFont systemFontOfSize:kDefaultContentFontSize];
    textView.scrollEnabled = NO;
    
    if ([comment.floorNo intValue] == 1) {
        NSData *contentData = [comment.content dataUsingEncoding:NSUTF8StringEncoding];
        textView.attributedText = [[NSAttributedString alloc] initWithHTMLData:contentData options:[HTMLParser sharedInstance].attributedTitleOptions documentAttributes:nil];
    } else {
        textView.text = comment.content;
    }
    CGSize commentSize = [textView sizeThatFits:CGSizeMake(300, FLT_MAX)];
    
    textView.font = [UIFont systemFontOfSize:kDefaultQuoteFontSize];
    textView.text = comment.quoteContent;
    CGSize quoteSize = [textView sizeThatFits:CGSizeMake(300, FLT_MAX)];
    
    CGFloat height = 50.0f + commentSize.height + quoteSize.height - 20.0f;
    
    return height;
}

@end
