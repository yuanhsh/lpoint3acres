//
//  ServiceAPIClient.m
//  BookReader
//
//  Created by 苑　海勝 on 2013/12/04.
//  Copyright (c) 2013年 苑　海勝. All rights reserved.
//

#import "ServiceClient.h"

@implementation ServiceClient

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
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self.operationQueue addOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    [request setValue:kUserAgent forHTTPHeaderField:@"User-Agent"];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
    return operation;
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

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fetchArticlesForBoard %@ at page %ld, Error: %@", board.name, (long)pageNo, error);
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fetchCommentsForArticle %@ at page %ld, Error: %@", article.articleID, (long)pageNo, error);
    }];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
    NSDictionary *parameters = @{@"username": username, @"password": password, @"cookietime": @"2592000", @"quickforward": @"yes", @"handlekey": @"ls"};
    
    [self POST:kLoginURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resString = operation.responseString;
        resString = [resString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if ( !resString || [resString isEqualToString:@""]) {
            [self.delegate loginFailed];
        } else {
//            NSString *usernameMatch = [resString stringByMatching:@"'username':'.*?'"];
            NSString *uidMatch = [resString stringByMatching:@"'uid':'.+?'"];
            uidMatch = [uidMatch stringByReplacingOccurrencesOfString:@"'" withString:@""];
            NSArray *userIdArray = [uidMatch componentsSeparatedByString:@":"];
            if (userIdArray.count == 2) {
                self.loginedUserId = userIdArray[1];
                [self.delegate loginSuccessedWithUserId:self.loginedUserId];
            } else {
                [self.delegate loginFailed];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.delegate loginFailed];
    }];
}

- (void)logout {
    [self GET:kLogoutURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kKeyLoginedUserID];
        [self.delegate logoutSuccessed];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
        [self.delegate logoutFailed];
    }];
}

- (NSString *)loginedUserId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kKeyLoginedUserID];
}

- (void)setLoginedUserId:(NSString *)loginedUserId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:loginedUserId forKey:kKeyLoginedUserID];
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)loadUserFavorites:(NSString *)userId {
    // todo
    NSString *favsURL = [[InfoURLMapper sharedInstance] getFavoritesURLForUser:userId];
    [self GET:favsURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            HTMLParser *parser = [HTMLParser sharedInstance];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.delegate didLoadFavorites:favs forUser:userId];
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
