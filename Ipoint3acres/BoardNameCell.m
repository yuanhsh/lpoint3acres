//
//  BoardNameCell.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/03/06.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import "BoardNameCell.h"

@implementation BoardNameCell

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

- (void)setBoard:(Board *)board {
    _board = board;
    self.nameLabel.text = board.name;
    self.checkMark.hidden = [board.hidden boolValue];
    if ([board.hidden boolValue]) {
        self.nameLabel.textColor = [UIColor grayColor];
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
    }
}

@end
