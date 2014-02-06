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

#define kBaseAPIURL         @"http://www.1point3acres.com/"

@protocol WebServiceDelegate;

@interface ServiceClient : AFHTTPRequestOperationManager

//+ (ServiceClient *)sharedClient;

@property (nonatomic, weak) id<WebServiceDelegate> delegate;

- (void)fetchArticlesForBoard:(Board *)board atPage:(NSInteger)pageNo;

@end

@protocol WebServiceDelegate <NSObject>

- (void)didReceiveArticles: (NSOrderedSet *)articles forBoard: (Board *)board;

@end