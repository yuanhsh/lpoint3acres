//
//  HTMLParser.m
//  Ipoint3acres
//
//  Created by YUAN on 14-2-3.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "DataManager.h"
#import "HTMLParser.h"
#import "TFHpple.h"

@implementation HTMLParser

+ (instancetype)sharedInstance {
    static HTMLParser *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (NSArray *)parseArticlesForBoard:(Board *)board withData:(NSData *)data {
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    NSString *queryString = @"//table[@summary='forum_27']/tbody";
    NSArray *nodes = [parser searchWithXPathQuery:queryString];
    NSInteger i = 0;
    for (TFHppleElement *element in nodes) {
//        NSString *content = [element raw];
        NSArray *ids = [[element objectForKey:@"id"] componentsSeparatedByString:@"_"]; //stickthread_80717
        Article *article = [self articleInBoard:board withID:ids[1]];
        article.isStick = NO;
        NSLog(@"%d - %@", ++i, ids[1]);
    }
    return nil;
}

- (Article *)articleInBoard:(Board *)board withID:(NSString *)articleID {
    Article *article = nil;
    for (Article *item in board.articles) {
        if ([item.articleID isEqualToString:articleID]) {
            article = item;
            break;
        }
    }
    
    if (!article) {
        // add a new row in database
        NSManagedObjectContext *context = [DataManager sharedInstance].managedObjectContext;
        article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:context];
        article.articleID = articleID;
        [board addArticlesObject:article];
    }
    
    return article;
}
@end
