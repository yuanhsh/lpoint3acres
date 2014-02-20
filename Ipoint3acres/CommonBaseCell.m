//
//  CommonBaseCell.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/20.
//  Copyright (c) 2014年 Yuan. All rights reserved.
//

#import "CommonBaseCell.h"

@implementation CommonBaseCell

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

@end
