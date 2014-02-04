//
//  HTMLParser.m
//  Ipoint3acres
//
//  Created by YUAN on 14-2-3.
//  Copyright (c) 2014年 Yuan Haisheng. All rights reserved.
//

#import "DataManager.h"
#import "HTMLParser.h"
#import "TFHpple.h"
#import "InfoURLMapper.h"

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
    NSString *queryString = [NSString stringWithFormat:@"//table[@summary='forum_%d']/tbody", 27];
    NSArray *nodes = [parser searchWithXPathQuery:queryString];
    InfoURLMapper *mapper = [InfoURLMapper sharedInstance];
    NSMutableArray *articleArray = [NSMutableArray array];
    
    // there should be 50 articles
    for (TFHppleElement *element in nodes) {
        NSArray *ids = [[element objectForKey:@"id"] componentsSeparatedByString:@"_"]; //ex. stickthread_80717
        Article *article = [self articleInBoard:board withID:ids[1]];
        article.isStick = ([ids[0] rangeOfString:@"stick"].location != NSNotFound);
        
        TFHppleElement *tr = [element firstChildWithTagName:@"tr"];
        
        // 1, get title
        NSString *title = [[tr firstChildWithTagName:@"th"] raw];
        title = [title stringByReplacingOccurrencesOfString:@"<span class=\"tps\">"
                                                 withString:@"<span style=\"display:none\">"];
        title = [title stringByReplacingOccurrencesOfString:@"em>"
                                                 withString:@"span>"];
        article.title = title;
        
        
        NSArray *tds = [tr childrenWithTagName:@"td"]; //there are 4 children: icn, by, num,by
        
        // 2, get author & create date
        TFHppleElement *authorInfo = [[(TFHppleElement *)tds[1] firstChildWithTagName:@"cite"] firstChildWithTagName:@"a"];
        TFHppleElement *createDateInfo = [[(TFHppleElement *)tds[1] firstChildWithTagName:@"em"] firstChildWithTagName:@"span"];
        NSString *authorLink = [authorInfo objectForKey:@"href"];
        NSString *authorName = [[authorInfo firstTextChild] content];
        NSString *createDate = [[createDateInfo firstTextChild] content];
        article.authorID = [mapper getUserIDfromUserLink:authorLink];
        article.authorName = authorName;
        article.createDate = createDate;
        
        // 3, get view and comment count
        NSString *commentCount = [[[(TFHppleElement *)tds[2] firstChildWithTagName:@"a"] firstTextChild] content];
        NSString *viewCount = [[[(TFHppleElement *)tds[2] firstChildWithTagName:@"em"] firstTextChild] content];
        article.commentCount = [commentCount intValue];
        article.viewCount = [viewCount intValue];
        
        // 4, get last comment info
        TFHppleElement *commenterInfo = [[(TFHppleElement *)tds[3] firstChildWithTagName:@"cite"] firstChildWithTagName:@"a"];
        NSString *commenterLink = [commenterInfo objectForKey:@"href"];
        NSString *commenterName = [[commenterInfo firstTextChild] content];
        article.lastCommenterID = [mapper getUserIDfromUserLink:commenterLink];
        article.lastCommenter = commenterName;
        
        // 5, get last comment date
        TFHppleElement *commenterDateInfo = [[[(TFHppleElement *)tds[3] firstChildWithTagName:@"em"] firstChildWithTagName:@"a"] firstChildWithTagName:@"span"];
        NSString *commentDate = [commenterDateInfo objectForKey:@"title"];
        article.lastCommentDate = commentDate;
        
        [articleArray addObject:article];
    }

    return articleArray;
}

- (Article *)articleInBoard:(Board *)board withID:(NSString *)articleID {
    Article *article = nil;
    for (Article *item in board.articles) {
        if (item.articleID == [articleID intValue]) {
            article = item;
            break;
        }
    }
    
    if (!article) {
        // add a new row in database
        NSManagedObjectContext *context = [DataManager sharedInstance].managedObjectContext;
        article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:context];
        article.articleID = [articleID intValue];
        [board addArticlesObject:article];
    }
    
    return article;
}
@end
