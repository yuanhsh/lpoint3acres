//
//  QuoteContentCell.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/17.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "AUIAutoGrowingTextView.h"

@interface QuoteContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *posterName;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UILabel *floorNo;
@property (weak, nonatomic) IBOutlet AUIAutoGrowingTextView *postContentView;
@property (weak, nonatomic) IBOutlet AUIAutoGrowingTextView *quoteView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) Comment *comment;

+ (CGFloat)heightForComment:(Comment *)comment;

@end
