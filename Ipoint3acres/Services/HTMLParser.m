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

const void (^attributedCallBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
    // the block is being called for an entire paragraph, so we check the individual elements
    for (DTHTMLElement *oneChildElement in element.childNodes) {
        // if an element is larger than twice the font size put it in it's own block
        if (oneChildElement.displayStyle == DTHTMLElementDisplayStyleInline && oneChildElement.textAttachment.displaySize.height > 2.0 * oneChildElement.fontDescriptor.pointSize) {
            oneChildElement.displayStyle = DTHTMLElementDisplayStyleBlock;
            oneChildElement.paragraphStyle.minimumLineHeight = element.textAttachment.displaySize.height;
            oneChildElement.paragraphStyle.maximumLineHeight = element.textAttachment.displaySize.height;
        }
    }
};

@implementation HTMLParser

@synthesize attributedTitleOptions = _attributedTitleOptions;

+ (instancetype)sharedInstance {
    static HTMLParser *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (NSDictionary *)attributedTitleOptions {
    if (!_attributedTitleOptions) {
        _attributedTitleOptions = @{NSTextSizeMultiplierDocumentOption: @1.0,
                                    DTDefaultLinkDecoration: @0,
                                    DTDefaultLinkColor: @"#007AFF",
                                    DTDefaultLinkHighlightColor: @"#007AFF",
                                    DTDefaultFontSize: @14.0,
//                                    DTDefaultFontFamily: @"Times New Roman", //Helvetica Neue
                                    DTWillFlushBlockCallBack: attributedCallBackBlock,
                                    DTUseiOS6Attributes: @YES};
    }
    return _attributedTitleOptions;
}

- (NSOrderedSet *)parseArticlesForBoard:(Board *)board withData:(NSData *)data {
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    NSString *queryString = [NSString stringWithFormat:@"//table[@summary='forum_%@']/tbody", board.boardID];
    NSArray *nodes = [parser searchWithXPathQuery:queryString];
    InfoURLMapper *mapper = [InfoURLMapper sharedInstance];
//    NSMutableArray *articleArray = [NSMutableArray array];
    NSMutableOrderedSet *articleArray = [NSMutableOrderedSet orderedSet];
    
    // there should be 50 articles
    for (TFHppleElement *element in nodes) {
        NSArray *ids = [[element objectForKey:@"id"] componentsSeparatedByString:@"_"]; //ex. stickthread_80717
        if (ids.count != 2) {
            continue;
        }
        Article *article = [self articleInBoard:board withID:ids[1]];
        article.isStick = @([ids[0] rangeOfString:@"stick"].location != NSNotFound);
        
        TFHppleElement *tr = [element firstChildWithTagName:@"tr"];
        
        // 1, get title
        NSString *title = [[tr firstChildWithTagName:@"th"] raw];
        title = [title stringByReplacingOccurrencesOfString:@"<span class=\"tps\">"
                                                 withString:@"<span style=\"display:none\">"];
        title = [title stringByReplacingOccurrencesOfString:@"em>"
                                                 withString:@"span>"];
        title = [title stringByReplacingOccurrencesOfString:@"class=\"xi1\">New</a>"
                                                 withString:@"class=\"xi1\"></a>"];
        
        NSData *titleData = [title dataUsingEncoding:NSUTF8StringEncoding];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithHTMLData:titleData options:self.attributedTitleOptions documentAttributes:nil];
        
        NSString *plainTitle = [attributedTitle.string stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        article.title = plainTitle;
        article.titleData = titleData;
        
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
        article.commentCount = @([commentCount integerValue]);
        article.viewCount = @([viewCount integerValue]);
        
        // 4, get last comment info
        TFHppleElement *commenterInfo = [[(TFHppleElement *)tds[3] firstChildWithTagName:@"cite"] firstChildWithTagName:@"a"];
        NSString *commenterLink = [commenterInfo objectForKey:@"href"];
        NSString *commenterName = [[commenterInfo firstTextChild] content];
        article.lastCommenterID = [mapper getUserIDfromUserLink:commenterLink];
        article.lastCommenter = commenterName;
        
        // 5, get last comment date
        TFHppleElement *commenterDateInfo = [[(TFHppleElement *)tds[3] firstChildWithTagName:@"em"] firstChildWithTagName:@"a"];
        NSString *commentDate = [[commenterDateInfo firstChildWithTagName:@"span"] objectForKey:@"title"];
        if (!commentDate || [commentDate isEqualToString:@""]) {
            commentDate = [commenterDateInfo firstTextChild].content;
        }
        article.lastCommentDate = commentDate;
        
        [articleArray addObject:article];
    }

    return articleArray;
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
        NSManagedObjectContext *context = [DataManager sharedInstance].mainObjectContext;
        article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:context];
        article.articleID = articleID;
        [board addArticlesObject:article];
//        NSMutableOrderedSet *singleSet = [NSMutableOrderedSet orderedSetWithObject:article];
//        [board addArticles:singleSet];
    }
    
    return article;
}

- (NSOrderedSet *)parseCommentsForArticle:(Article *)article withData:(NSData *)data {
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    NSString *queryString = [NSString stringWithFormat:@"//td[@class='plc']"];
    NSArray *nodes = [parser searchWithXPathQuery:queryString];
    NSMutableOrderedSet *commentArray = [NSMutableOrderedSet orderedSet];
    
    for (TFHppleElement *element in nodes) {
        TFHppleElement *divPi = [element firstChildWithClassName:@"pi"];
        TFHppleElement *divPct = [element firstChildWithClassName:@"pct"];
        if (divPi && divPct && [divPi.tagName isEqualToString:@"div"] && [divPct.tagName isEqualToString:@"div"]) {
            
            TFHppleElement *postIDNode = [[divPi firstChildWithTagName:@"strong"] firstChildWithTagName:@"a"];
            NSString *postIDStr = [postIDNode objectForKey:@"id"];
            NSString *postID = [[postIDStr componentsSeparatedByString:@"postnum"] lastObject];
            
            Comment *comment = [self commentInArticle:article withID:postID];
            
            // get post content
            NSString *quoteContent = nil;
            NSString *content = [[divPct firstChildWithTagName:@"div"] firstChildWithTagName:@"div"].raw;
            content = [content stringByReplacingOccurrencesOfString:@"<div class=\"quote\">"
                                                     withString:@"<div style=\"display:none\">"];
            if (![[postIDNode firstTextChild].content isEqualToString:@"垅头"]) {
                // get quote content
                NSString *matchedQuote = [content stringByMatching:@"<blockquote>.*</blockquote>"];
                if (matchedQuote && ![matchedQuote isEqualToString:@""]) {
                    NSData *quoteData = [matchedQuote dataUsingEncoding:NSUTF8StringEncoding];
                    NSAttributedString *attributedQuote = [[NSAttributedString alloc] initWithHTMLData:quoteData options:self.attributedTitleOptions documentAttributes:nil];
                    quoteContent = attributedQuote.string;
                }
                // comment in this article
                NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
                NSAttributedString *attributedContent = [[NSAttributedString alloc] initWithHTMLData:contentData options:self.attributedTitleOptions documentAttributes:nil];
                content = attributedContent.string;
            } else {
                comment.floorNo = @1;
            }
            comment.quoteContent = quoteContent;
            comment.content = content;
            
            TFHppleElement *commenterInfo = [[divPi firstChildWithClassName:@"pti"] firstChildWithClassName:@"authi"];
            TFHppleElement *commenterInfoLink = [commenterInfo firstChildWithTagName:@"a"];
            TFHppleElement *commentDateInfo = [commenterInfo firstChildWithTagName:@"em"];
            comment.commenterName = [commenterInfoLink firstTextChild].content;
            comment.commenterID = [[InfoURLMapper sharedInstance] getUserIDfromUserLink:[commenterInfoLink objectForKey:@"href"]];
            
            TFHppleElement *dateSpan = [commentDateInfo firstChildWithTagName:@"span"];
            if (dateSpan && [dateSpan.tagName isEqualToString:@"span"]) {
                comment.createDate = [dateSpan objectForKey:@"title"];
            } else {
                comment.createDate = [commentDateInfo firstTextChild].content;
            }
            comment.createDate = [comment.createDate stringByReplacingOccurrencesOfString:@"发表于 " withString:@""];
            
            [commentArray addObject:comment];
        }
    }
    return commentArray;
}

- (Comment *)commentInArticle:(Article *)article withID:(NSString *)postID {
    Comment *comment = nil;
    for (Comment *item in article.comments) {
        if ([item.postID isEqualToString:postID]) {
            comment = item;
            break;
        }
    }
    
    if (!comment) {
        // add a new row in database
        NSManagedObjectContext *context = [DataManager sharedInstance].mainObjectContext;
        comment = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:context];
        comment.postID = postID;
        [article addCommentsObject:comment];
    }
    
    return comment;
}


@end
