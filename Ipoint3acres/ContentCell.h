//
//  ContentCell.h
//  Ipoint3acres
//
//  Created by YUAN on 14-2-11.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "AUIAutoGrowingTextView.h"

@interface ContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *posterName;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UILabel *floorNo;
@property (weak, nonatomic) IBOutlet AUIAutoGrowingTextView *postContentView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) Comment *comment;

+ (CGFloat)heightForComment:(Comment *)comment;

@end