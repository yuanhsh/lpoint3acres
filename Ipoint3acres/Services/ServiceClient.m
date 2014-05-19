//
//  ServiceAPIClient.m
//  BookReader
//
//  Created by 苑　海勝 on 2013/12/04.
//  Copyright (c) 2013年 苑　海勝. All rights reserved.
//

#import "ServiceClient.h"

@implementation ServiceClient

@synthesize loginedUserId = _loginedUserId;

+ (ServiceClient *)sharedClient {
    static ServiceClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseAPIURL]];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    
    return _sharedClient;
}

- (id)init {
    if(self = [super initWithBaseURL:[NSURL URLWithString:kBaseAPIURL]]) {
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

- (id)initWithDelegate:(id<WebServiceDelegate>) delegate {
    if(self = [super initWithBaseURL:[NSURL URLWithString:kBaseAPIURL]]) {
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.delegate = delegate;
    }
    return self;
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    [request setValue:kUserAgent forHTTPHeaderField:@"User-Agent"];
    [request setTimeoutInterval:120];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self.operationQueue addOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success{
    return [self GET:URLString parameters:parameters success:success failure:self.failureBlock];
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    self.requestSerializer.stringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    [request setValue:kUserAgent forHTTPHeaderField:@"User-Agent"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success {
    return [self POST:URLString parameters:parameters success:success failure:self.failureBlock];
}

- (void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock {
    __weak ServiceClient *weakSelf = self;
    if (!_failureBlock) {
        _failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"HTTP Request Error: %@", error);
            switch ((int32_t)error.code) {
                case NSURLErrorTimedOut:
                    if ([(id)weakSelf.delegate respondsToSelector:@selector(requestTimedOut)]) {
                        [weakSelf.delegate requestTimedOut];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"请求超时"];
                    }
                    break;
                case NSURLErrorCancelled:
                    
                    break;
                default:
                    if ([(id)weakSelf.delegate respondsToSelector:@selector(requestError)]) {
                        [weakSelf.delegate requestError];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"连接错误"];
                    }
                    break;
            }
        };
    }
    return _failureBlock;
}

- (void)fetchArticlesForBoard:(Board *)board atPage:(NSInteger)pageNo {
    NSInteger page = (pageNo <= 0) ? 1 : pageNo;
    NSString *boardURL = [[InfoURLMapper sharedInstance] urlForBoard:board atPage:page];

    [self GET:boardURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            HTMLParser *parser = [HTMLParser sharedInstance];
            NSOrderedSet *articles = [parser parseArticlesForBoard:board withData:operation.responseData];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didReceiveArticles:articles forBoard:board];
            });
        });

    }];
}

- (void)fetchCommentsForArticle:(Article *)article atPage:(NSInteger)pageNo {
    NSInteger page = (pageNo <= 0) ? 1 : pageNo;
    NSString *commentURL = [[InfoURLMapper sharedInstance] commentURLForArticle:article atPage:page];
    
    [self GET:commentURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            HTMLParser *parser = [HTMLParser sharedInstance];
            NSOrderedSet *comments = [parser parseCommentsForArticle:article withData:operation.responseData];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didReceiveComments:comments forArticle:article];
            });
        });
        
    }];
}

- (void)fetchCommentsForArticle:(Article *)article atURL:(NSString *)commentURL {
    [self GET:commentURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            HTMLParser *parser = [HTMLParser sharedInstance];
            NSOrderedSet *comments = [parser parseCommentsForArticle:article withData:operation.responseData];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didReceiveComments:comments forArticle:article];
            });
        });
        
    }];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
    NSDictionary *parameters = @{@"username": username, @"password": password, @"cookietime": @"2592000", @"quickforward": @"yes", @"handlekey": @"ls"};
    
    [self POST:kLoginURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resString = operation.responseString;
        resString = [resString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if ( !resString || [resString isEqualToString:@""]) {
            if ([self.delegate respondsToSelector:@selector(loginFailed)]) {
                [self.delegate loginFailed];
            }
        } else {
//            NSString *usernameMatch = [resString stringByMatching:@"'username':'.*?'"];
            NSString *uidMatch = [resString stringByMatching:@"'uid':'.+?'"];
            uidMatch = [uidMatch stringByReplacingOccurrencesOfString:@"'" withString:@""];
            NSArray *userIdArray = [uidMatch componentsSeparatedByString:@":"];
            if (userIdArray.count == 2) {
                self.loginedUserId = userIdArray[1];
                if ([self.delegate respondsToSelector:@selector(loginSuccessedWithUserId:)]) {
                    [self.delegate loginSuccessedWithUserId:self.loginedUserId];
                }
            } else {
                if ([self.delegate respondsToSelector:@selector(loginFailed)]) {
                    [self.delegate loginFailed];
                }
            }
        }
    }];
}

- (void)logout {
    [self GET:kLogoutURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.loginedUserId = nil;
        [self.delegate logoutSuccessed];
    }];
}

- (NSString *)loginedUserId {
    if (!_loginedUserId) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _loginedUserId = [defaults objectForKey:kKeyLoginedUserID];
    }
    return _loginedUserId;
}

- (void)setLoginedUserId:(NSString *)loginedUserId {
    _loginedUserId = loginedUserId;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (loginedUserId) {
        [defaults setObject:loginedUserId forKey:kKeyLoginedUserID];
    } else {
        [defaults removeObjectForKey:kKeyLoginedUserID];
    }
    [defaults synchronize];
}

- (void)loadUserProfile:(NSString *)userId {
    NSString *profileURL = [[InfoURLMapper sharedInstance] getProfileURLForUser:userId];
    [self GET:profileURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            HTMLParser *parser = [HTMLParser sharedInstance];
            SiteUser *user = [parser parseProfileForUser:userId withData:operation.responseData];
//            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didLoadUserProfile:user];
//            });
//        });
    }];
}

- (void)loadUserPosts:(NSString *)userId {
    NSString *postsURL = [[InfoURLMapper sharedInstance] getPostsURLForUser:userId];
    [self GET:postsURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            HTMLParser *parser = [HTMLParser sharedInstance];
            NSOrderedSet *posts = [parser parsePostsForUser:userId withData:operation.responseData];
//            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didLoadPosts:posts forUser:userId];
//            });
//        });
    }];
}

- (void)loadUserFavorites:(NSString *)userId {
    // TODO
    NSString *favsURL = [[InfoURLMapper sharedInstance] getFavoritesURLForUser:userId];
    [self GET:favsURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //HTMLParser *parser = [HTMLParser sharedInstance];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.delegate didLoadFavorites:favs forUser:userId];
            });
        });
    }];
}

- (void)loadReplyFormData:(Comment *)comment {
    NSString *url = [[InfoURLMapper sharedInstance] getReplyFormURLForComment:comment];
    NSLog(@"loadReplyFormData url %@", url);
    [super GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            HTMLParser *parser = [HTMLParser sharedInstance];
            NSMutableDictionary *formData = [parser parseReplyFormData:operation.responseData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didLoadReplyFormData:formData];
            });
        });
    } failure:self.failureBlock];
}

- (void)postReplyMessage:(Comment *)comment parameters:(NSDictionary *)params {
    NSString *url = [[InfoURLMapper sharedInstance] getReplyPostURLForComment:comment];
    [self POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate didPostReplyMessage:YES];
    }];
}

- (void)loadUnreadNotifs {
    [self GET:kUnreadNotifURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            HTMLParser *parser = [HTMLParser sharedInstance];
            NSOrderedSet *notifs = [parser parseUnreadNotifsWithData:operation.responseData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didLoadUnreadNotifs:notifs];
            });
        });
    }];
}

@end
