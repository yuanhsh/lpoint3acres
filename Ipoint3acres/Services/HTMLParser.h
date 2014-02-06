//
//  HTMLParser.h
//  Ipoint3acres
//
//  Created by YUAN on 14-2-3.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Models.h"
#import "DTCoreText.h"
#import "NSAttributedString+HTML.h"

extern const void (^attributedCallBackBlock)(DTHTMLElement *element);

@interface HTMLParser : NSObject

@property (nonatomic, strong, readonly) NSDictionary *attributedTitleOptions;

+ (instancetype)sharedInstance;

- (NSOrderedSet *)parseArticlesForBoard:(Board *)board withData:(NSData *)data;
@end
