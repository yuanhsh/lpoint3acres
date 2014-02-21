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

#define kBaseAPIURL         @"http://www.1point3acres.com/"

#define kLoginURL   @"/bbs/member.php?mod=logging&action=login&loginsubmit=yes&infloat=yes&lssubmit=yes&inajax=1"
#define kLogoutURL  @"/bbs/member.php?mod=logging&action=logout"

#define kBoardURLByLastPost @"/bbs/forum-%@-%ld.html"
#define kBoardURLByDate @"/bbs/forum.php?mod=forumdisplay&fid=%@&filter=author&orderby=dateline&page=%ld"

#define kArticleURL     @"/bbs/thread-%@-1-1.html"
#define kCommentURL     @"/bbs/thread-%@-%ld-1.html"
#define kAvatarURL      @"http://www.1point3acres.com/bbs/uc_server/avatar.php?uid=%@&size=middle"

#define kUserProfileURL @"/bbs/home.php?mod=space&uid=%@&do=profile"
#define kUserFavoritesURL   @"/bbs/home.php?mod=space&do=favorite&type=thread"
#define kUserPostsURL   @"/bbs/home.php?mod=space&uid=%@&do=thread&view=me&type=thread&order=dateline&from=space&page=%d"

#define kUserProfileFullURL @"http://www.1point3acres.com/bbs/home.php?mod=space&uid=%@&do=profile"

@interface InfoURLMapper : NSObject

+ (instancetype)sharedInstance;

- (NSString *)urlForBoard:(Board *)board atPage:(NSInteger)pageNo;

- (NSString *)commentURLForArticle:(Article *)article atPage:(NSInteger)pageNo;

- (NSString *)getUserIDfromUserLink:(NSString *)link;

- (NSString *)getArticleIDfromURL:(NSString *)link;

- (NSString *)getAvatarURLforUser:(NSString *)userID;

- (NSString *)getProfileURLForUser:(NSString *)userID;

- (NSString *)getPostsURLForUser:(NSString *)userID;

- (NSString *)getFavoritesURLForUser:(NSString *)userID;

- (NSString *)getProfileFullURLForUser:(NSString *)userID;

@end
