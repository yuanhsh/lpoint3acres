//
//  ContentCell.h
//  Ipoint3acres
//
//  Created by YUAN on 14-2-11.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
//#import "AUIAutoGrowingTextView.h"

@interface ContentCell : UITableViewCell <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *posterName;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UILabel *floorNo;
@property (weak, nonatomic) IBOutlet UITextView *postContentView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) Comment *comment;

+ (CGFloat)heightForComment:(Comment *)comment;

@end
