//
//  ServiceAPIClient.h
//  BookReader
//
//  Created by 苑　海勝 on 2013/12/04.
//  Copyright (c) 2013年 苑　海勝. All rights reserved.
//

#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Board.h"

#define kBaseAPIURL         @"http://www.1point3acres.com/"
#define kActivateAPIPath    @"/contents/api/auth/activate"
#define kLoginAPIPath       @"/contents/api/auth/login"
#define kBookListAPIPath    @"/contents/api/cust/booklist"

@interface ServiceClient : AFHTTPRequestOperationManager

+ (ServiceClient *)sharedClient;

- (void)fetchArticlesForBoard:(Board *)board atPage:(NSInteger)pageNo;

@end

@protocol WebServiceDelegate <NSObject>

- (void)didReceiveArticles: (NSArray *)articles forBoard: (Board *)board;

@end