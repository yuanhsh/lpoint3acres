//
//  HTMLParser.h
//  Ipoint3acres
//
//  Created by YUAN on 14-2-3.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Models.h"

@interface HTMLParser : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)parseArticlesForBoard:(Board *)board withData:(NSData *)data;
@end
