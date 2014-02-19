//
//  Article.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/06.
//  Copyright (c) 2014年 Yuan. All rights reserved.
//

#import "Article.h"
#import "Board.h"
#import "Comment.h"


@implementation Article

@dynamic articleID;
@dynamic articleURL;
@dynamic authorID;
@dynamic authorName;
@dynamic commentCount;
@dynamic content;
@dynamic createDate;
@dynamic isStick;
@dynamic isViewed;
@dynamic lastCommentDate;
@dynamic lastCommenter;
@dynamic lastCommenterID;
@dynamic title;
@dynamic titleData;
@dynamic viewCount;
@dynamic board;
@dynamic author;
@dynamic comments;

- (void)addCommentsObject:(Comment *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.comments];
    [tempSet addObject:value];
    self.comments = tempSet;
}

@end
