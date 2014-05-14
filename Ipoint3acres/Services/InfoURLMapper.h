//
//  InfoURLMapper.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/03.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Models.h"
#import "RegexKitLite.h"

#define kBaseAPIURL @"http://www.1point3acres.com/"
#define kForumURL   @"http://www.1point3acres.com/bbs/"

#define kLoginURL   @"/bbs/member.php?mod=logging&action=login&loginsubmit=yes&infloat=yes&lssubmit=yes&inajax=1"
#define kLogoutURL  @"/bbs/member.php?mod=logging&action=logout"

#define kBoardURLByLastPost @"/bbs/forum-%@-%ld.html"
#define kBoardURLByDate @"/bbs/forum.php?mod=forumdisplay&fid=%@&filter=author&orderby=dateline&page=%ld"

#define kArticleURL     @"/bbs/thread-%@-1-1.html"
#define kCommentURL     @"/bbs/thread-%@-%ld-1.html"

#define kUserProfileURL @"/bbs/home.php?mod=space&uid=%@&do=profile"
#define kUserFavoritesURL   @"/bbs/home.php?mod=space&do=favorite&type=thread"
#define kUserPostsURL   @"/bbs/home.php?mod=space&uid=%@&do=thread&view=me&type=thread&order=dateline&from=space&page=%d"

#define kUnreadNotifURL    @"/bbs/home.php?mod=space&do=notice&isread=0"

//&extra=page%3D1&page=3 was deleted, need XMLHttpRequest header
#define kReplyFormURL   @"/bbs/forum.php?mod=post&action=reply&fid=%@&tid=%@&reppost=%@&infloat=yes&handlekey=reply&inajax=1&ajaxtarget=fwin_content_reply"
#define kReplyQuoteFormURL   @"/bbs/forum.php?mod=post&action=reply&fid=%@&tid=%@&repquote=%@&infloat=yes&handlekey=reply&inajax=1&ajaxtarget=fwin_content_reply"
#define kReplyPostURL   @"/bbs/forum.php?mod=post&infloat=yes&action=reply&fid=%@&tid=%@&replysubmit=yes&inajax=1"

#define kAvatarURL      @"http://www.1point3acres.com/bbs/uc_server/avatar.php?uid=%@&size=middle"
#define kUserProfileFullURL @"http://www.1point3acres.com/bbs/home.php?mod=space&uid=%@&do=profile"
#define kArticleFullURL     @"http://www.1point3acres.com/bbs/thread-%@-1-1.html"

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

- (NSString *)getArticleFullURL:(NSString *)articleID;

- (NSString *)getReplyFormURLForComment:(Comment *)comment;

- (NSString *)getReplyPostURLForComment:(Comment *)comment;

- (NSString *)getNotifArticleIDfromURL:(NSString *)link;

- (NSString *)getNotifPostIDfromURL:(NSString *)link;

@end
