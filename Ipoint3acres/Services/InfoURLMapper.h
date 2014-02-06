//
//  InfoURLMapper.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/03.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Models.h"
#import "RegexKitLite.h"

#define kBoardURL       @"/bbs/forum-%@-%d.html"
#define kArticleURL     @"/bbs/thread-%@-1-1.html"
#define kCommentURL     @"/bbs/thread-%@-%d-1.html"
#define kAvatarURL      @"http://www.1point3acres.com/bbs/uc_server/avatar.php?uid=%@&size=middle"

@interface InfoURLMapper : NSObject

+ (instancetype)sharedInstance;

- (NSString *)urlForBoard:(Board *)board atPage:(NSInteger)pageNo;

- (NSString *)commentURLForArticle:(Article *)article atPage:(NSInteger)pageNo;

- (NSString *)getUserIDfromUserLink:(NSString *)link;

- (NSString *)getAvatarURLforUser:(NSString *)userID;

@end
