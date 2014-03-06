//
//  BoardNameCell.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/03/06.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"

@interface BoardNameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkMark;
@property (weak, nonatomic) Board *board;
@end
