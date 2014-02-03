//
//  PageURLMapper.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/03.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "PageURLMapper.h"

@implementation PageURLMapper

+ (instancetype)sharedInstance {
    static PageURLMapper *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (NSString *)urlForBoard:(Board *)board atPage:(NSInteger)pageNo {
    NSString *url = [NSString stringWithFormat:board.url, pageNo];
    return url;
}

@end
