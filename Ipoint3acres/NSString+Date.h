//
//  NSString+Date.h
//  Ipoint3acres
//
//  Created by YUAN on 14-2-15.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+TimeAgo.h"

@interface NSString (Date)

- (NSString *)chinaTimeToLocalTime;

- (NSString *)chinaTimeToLocalTimeWithLimit:(NSTimeInterval)limit;

@end
