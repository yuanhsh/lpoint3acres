//
//  InfoURLMapper.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/03.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "InfoURLMapper.h"

@implementation InfoURLMapper

+ (instancetype)sharedInstance {
    static InfoURLMapper *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (NSString *)urlForBoard:(Board *)board atPage:(NSInteger)pageNo {
    NSString *url = [NSString stringWithFormat:kBoardURLByDate, board.boardID, (long)pageNo];
    return url;
}

- (NSString *)commentURLForArticle:(Article *)article atPage:(NSInteger)pageNo {
    NSString *url = [NSString stringWithFormat:kCommentURL, article.articleID, (long)pageNo];
    return url;
}

- (NSString *)getUserIDfromUserLink:(NSString *)link {
    NSString *regEx = @"space-uid-[0-9]+";
    NSString *match = [link stringByMatching:regEx];
    if ([match isEqual:@""] == NO) {
        match = [match stringByReplacingOccurrencesOfString:@"space-uid-" withString:@""];
        return match;
    }
    return nil;
}

- (NSString *)getArticleIDfromURL:(NSString *)link {
    NSString *regEx = @"http://www.1point3acres.com/bbs/thread-[0-9]+-1-1.html";
    NSString *match = [link stringByMatching:regEx];
    if ([match isEqual:@""] == NO) {
        match = [match stringByReplacingOccurrencesOfString:@"http://www.1point3acres.com/bbs/thread-" withString:@""];
        match = [match stringByReplacingOccurrencesOfString:@"-1-1.html" withString:@""];
        return match;
    }
    return nil;
}

- (NSString *)getAvatarURLforUser:(NSString *)userID {
    return [NSString stringWithFormat:kAvatarURL, userID];
}

- (NSString *)getProfileURLForUser:(NSString *)userID {
    return [NSString stringWithFormat:kUserProfileURL, userID];
}

- (NSString *)getProfileFullURLForUser:(NSString *)userID {
    return [NSString stringWithFormat:kUserProfileFullURL, userID];
}

- (NSString *)getPostsURLForUser:(NSString *)userID {
    return [NSString stringWithFormat:kUserPostsURL, userID, 1];
}

- (NSString *)getFavoritesURLForUser:(NSString *)userID {
    return kUserFavoritesURL;
}

@end
