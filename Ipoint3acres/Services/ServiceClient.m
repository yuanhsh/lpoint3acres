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

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.102 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
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
        NSLog(@"fetchArticlesForBoard %@ at page %d, Error: %@", board.name, pageNo, error);
    }];
}

- (void)fetchCommentsForArticle:(Article *)article atPage:(NSInteger)pageNo {
    NSInteger page = (pageNo <= 0) ? 1 : pageNo;
    NSString *commentURL = [[InfoURLMapper sharedInstance] commentURLForArticle:article atPage:page];
    
    [self GET:commentURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            HTMLParser *parser = [HTMLParser sharedInstance];
            [parser parseCommentsForArticle:article withData:operation.responseData];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.delegate didReceiveArticles:articles forBoard:board];
            });
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fetchCommentsForArticle %@ at page %d, Error: %@", article.articleID, pageNo, error);
    }];
}
@end
