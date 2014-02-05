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
    NSString *url = [NSString stringWithFormat:kBoardURL, board.boardID, pageNo];
    return url;
}

- (int32_t)getUserIDfromUserLink:(NSString *)link {
    NSString *regEx = @"space-uid-[0-9]+";
    NSString *match = [link stringByMatching:regEx];
    if ([match isEqual:@""] == NO) {
        match = [match stringByReplacingOccurrencesOfString:@"space-uid-" withString:@""];
        return [match intValue];
    }
    return 0;
}

- (NSString *)getAvatarURLforUser:(NSInteger)userID {
    return [NSString stringWithFormat:kAvatarURL, userID];
}

@end
