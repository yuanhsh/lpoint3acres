//
//  Board.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/06.
//  Copyright (c) 2014年 Yuan. All rights reserved.
//

#import "Board.h"
#import "Article.h"


@implementation Board

@dynamic boardID;
@dynamic hidden;
@dynamic index;
@dynamic name;
@dynamic url;
@dynamic articles;

- (void)addArticlesObject:(Article *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.articles];
    [tempSet addObject:value];
    self.articles = tempSet;
}

@end
