//
//  SiteUser.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/20.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import "SiteUser.h"
#import "Article.h"
#import "Favorite.h"


@implementation SiteUser

@dynamic gender;
@dynamic signature;
@dynamic userId;
@dynamic username;
@dynamic birthdate;
@dynamic college;
@dynamic degree;
@dynamic major;
@dynamic postCount;
@dynamic favorites;
@dynamic posts;

- (void)addFavoritesObject:(Favorite *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.favorites];
    [tempSet addObject:value];
    self.favorites = tempSet;
}

- (void)addPostsObject:(Article *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.posts];
    [tempSet addObject:value];
    self.posts = tempSet;
}

@end
