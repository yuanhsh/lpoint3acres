//
//  NSString+Date.m
//  Ipoint3acres
//
//  Created by YUAN on 14-2-15.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import "NSString+Date.h"

#define kTimeAgoLimit 2*24*60*60

@implementation NSString (Date)

- (NSString *)chinaTimeToLocalTime {
    return [self chinaTimeToLocalTimeWithLimit:kTimeAgoLimit];
}

- (NSString *)chinaTimeToLocalTimeWithLimit:(NSTimeInterval)limit {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8]; //GMT+08:00
        [dateFormatter setTimeZone:sourceTimeZone];
    }
    
    NSDate *date = [dateFormatter dateFromString:self];
    return [date timeAgoWithLimit:limit];
}

@end
