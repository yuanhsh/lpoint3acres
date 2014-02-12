//
//  ContentCell.m
//  Ipoint3acres
//
//  Created by YUAN on 14-2-11.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "ContentCell.h"
#import "InfoURLMapper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSAttributedString+HTML.h"
#import "HTMLParser.h"

@implementation ContentCell

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
    self.postDate.text = comment.createDate;
    
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
    
    CGSize size = [textView sizeThatFits:CGSizeMake(300, FLT_MAX)];
    
//    CGSize size = textView.contentSize;
//    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        size.width += (textView.textContainerInset.left + textView.textContainerInset.right ) / 2.0f;
//        size.height += (textView.textContainerInset.top + textView.textContainerInset.bottom) / 2.0f;
//    }
    CGFloat height = 45.0f + size.height + 10.0f - 20.0f;
    
    return height;
}

@end
