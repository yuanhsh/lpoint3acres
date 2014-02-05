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

#define kBoardURL       @"/bbs/forum-%d-%d.html"
#define kArticleURL     @"/bbs/thread-%d-1-1.html"
#define kCommentURL     @"/bbs/thread-%d-%d-1.html"
#define kAvatarURL      @"http://www.1point3acres.com/bbs/uc_server/avatar.php?uid=%d&size=middle"

@interface InfoURLMapper : NSObject

+ (instancetype)sharedInstance;

- (NSString *)urlForBoard:(Board *)board atPage:(NSInteger)pageNo;

- (int32_t)getUserIDfromUserLink:(NSString *)link;

- (NSString *)getAvatarURLforUser:(NSInteger)userID;

@end
