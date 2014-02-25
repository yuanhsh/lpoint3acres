//
//  FirstFloorContentCell.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/12.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "InfoURLMapper.h"
#import "Models.h"
#import "HTMLParser.h"

@protocol ContentCellDelegate;

@interface FirstFloorContentCell : UITableViewCell<UIActionSheetDelegate, DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *posterName;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UILabel *floorNo;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (strong, nonatomic) DTAttributedTextView *postContentView;
@property (weak, nonatomic) Comment *comment;
@property (nonatomic, strong) NSMutableSet *mediaPlayers;
@property (nonatomic, strong) NSURL *lastActionLink;

@property (nonatomic, weak) id<ContentCellDelegate> delegate;

- (CGFloat)heightForComment:(Comment *)comment;

@end

@protocol ContentCellDelegate <NSObject>

- (void)requestOpenURL:(NSString *)url;

@end