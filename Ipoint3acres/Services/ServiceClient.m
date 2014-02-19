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
        HTMLParser *parser = [HTMLParser sharedInstance];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (void)loadUserPosts:(NSString *)userId {
    
}
- (void)loadUserFavorites:(NSString *)userId {
    
}

@end
