//
//  HTMLParser.h
//  Ipoint3acres
//
//  Created by YUAN on 14-2-3.
//  Copyright (c) 2014年 YUAN. All rights reserved.
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

- (NSOrderedSet *)parseCommentsForArticle:(Article *)article withData:(NSData *)data;

- (SiteUser *)parseProfileForUser:(NSString *)userId withData:(NSData *)data;

- (NSOrderedSet *)parsePostsForUser:(NSString *)userId withData:(NSData *)data;

- (NSMutableDictionary *)parseReplyFormData:(NSData *)data;

- (Article *)articleWithID:(NSString *)articleID;

@end
