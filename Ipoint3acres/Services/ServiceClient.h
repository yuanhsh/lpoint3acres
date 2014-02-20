//
//  ServiceAPIClient.h
//  BookReader
//
//  Created by 苑　海勝 on 2013/12/04.
//  Copyright (c) 2013年 苑　海勝. All rights reserved.
//

#import "AFNetworking.h"
#import "HTMLParser.h"
#import "InfoURLMapper.h"
#import "Models.h"

#define kUserAgent  @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.102 Safari/537.36"

#define kArticleCountPerPage    50
#define kCommentCountPerPage    20

#define kKeyLoginedUserID   @"loginedUserId"

@protocol WebServiceDelegate;

@interface ServiceClient : AFHTTPRequestOperationManager

//+ (ServiceClient *)sharedClient;

@property (nonatomic, strong) NSString *loginedUserId;
@property (nonatomic, weak) id<WebServiceDelegate> delegate;

- (id)initWithDelegate:(id<WebServiceDelegate>) delegate;

- (void)fetchArticlesForBoard:(Board *)board atPage:(NSInteger)pageNo;
- (void)fetchCommentsForArticle:(Article *)article atPage:(NSInteger)pageNo;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password;
- (void)logout;

- (void)loadUserProfile:(NSString *)userId;
- (void)loadUserPosts:(NSString *)userId;
- (void)loadUserFavorites:(NSString *)userId;

@end

@protocol WebServiceDelegate <NSObject>
@optional
- (void)didReceiveArticles: (NSOrderedSet *)articles forBoard: (Board *)board;
- (void)didReceiveComments: (NSOrderedSet *)comments forArticle: (Article *)article;

- (void)loginSuccessedWithUserId:(NSString *)loginedUserId;
- (void)loginFailed;

- (void)didLoadUserProfile: (SiteUser *)user;
- (void)didLoadPosts:(NSOrderedSet *)posts forUser:(NSString *)userId;
- (void)didLoadFavorites:(NSOrderedSet *)favs forUser:(NSString *)userId;
@end