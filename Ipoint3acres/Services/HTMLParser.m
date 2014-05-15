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
                                    DTDefaultFontSize: @kDefaultContentFontSize,
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
        title = [title stringByReplacingOccurrencesOfString:@"隐藏置顶帖"
                                                 withString:@""];
        
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
        if (!createDate || [createDate isEqualToString:@""]) {
            TFHppleElement *subCreateDateInfo = [createDateInfo firstChildWithTagName:@"span"];
            if (subCreateDateInfo) {
                createDate = [subCreateDateInfo objectForKey:@"title"];
            }
        }
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
        if ([commentDate length] <= 16) { // "yyyy-MM-dd HH:mm" -> "yyyy-MM-dd HH:mm:ss"
            commentDate = [NSString stringWithFormat:@"%@:00", commentDate];
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

- (NSString *)removeIllegalCharacters:(NSString *)str {
    NSString *result = [[str componentsSeparatedByCharactersInSet:[NSCharacterSet illegalCharacterSet]] componentsJoinedByString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"class=\"jammer\"" withString:@"style=\"display:none\""];
//    result = [result stringByReplacingOccurrencesOfRegex:@"<font class=\"jammer\">.*?</font>" withString:@""];
//    result = [result stringByReplacingOccurrencesOfRegex:@"<span style=\"display:none\">.*?</span>" withString:@""];
    return result;
}

- (NSOrderedSet *)parseCommentsForArticle:(Article *)article withData:(NSData *)data {
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    
    //update view count and comment count of the article
    NSArray *countNodes = [parser searchWithXPathQuery:@"//td[@class='pls ptm pbm']"];
    if (countNodes.count >= 1) {
        NSArray *countElements = [[(TFHppleElement *)countNodes[0] firstChildWithTagName:@"div"] childrenWithClassName:@"xi1"];
        if (countElements.count == 2) {
            NSString *viewCountStr = [(TFHppleElement *)countElements[0] firstTextChild].content;
            NSString *commentCountStr = [(TFHppleElement *)countElements[1] firstTextChild].content;
            @try {
                article.viewCount = @([viewCountStr integerValue]);
                article.commentCount = @([commentCountStr integerValue]);
            }
            @catch (NSException *exception) {}
            @finally {}
        }
    }
    
    if (!article.shortTitle || [article.shortTitle isEqualToString:@""]) {
        NSArray *titleNodes = [parser searchWithXPathQuery:@"//title"];
        NSString *shortTitle = [(TFHppleElement *)titleNodes[0] firstTextChild].content;
        NSRange range = [shortTitle rangeOfString:@"【" options:NSBackwardsSearch];
        if(range.location != NSNotFound) {
            shortTitle = [shortTitle substringToIndex:range.location];
        }
        article.shortTitle = shortTitle;
    }
    
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
            content = [content stringByReplacingOccurrencesOfString:@"<div class=\"quote\">" withString:@"<div style=\"display:none\">"];
            NSString *floorName = [postIDNode firstTextChild].content;
            if ([floorName rangeOfString:@"垅头"].location == NSNotFound) {
                // comment in this article
                content = [self removeIllegalCharacters:content];
                NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
                NSAttributedString *attributedContent = [[NSAttributedString alloc] initWithHTMLData:contentData options:self.attributedTitleOptions documentAttributes:nil];
                content = attributedContent.string;
                
                // get quote content
                TFHpple *quoteParser = [TFHpple hppleWithHTMLData:contentData];
                NSArray *quoteNodes = [quoteParser searchWithXPathQuery:[NSString stringWithFormat:@"//blockquote"]];
                if (quoteNodes.count >= 1) {
                    TFHppleElement *quoteElement = quoteNodes[0];
                    NSString *quoteString = [self removeIllegalCharacters:quoteElement.raw];
                    NSData *quoteData = [quoteString dataUsingEncoding:NSUTF8StringEncoding];
                    NSAttributedString *attributedQuote = [[NSAttributedString alloc] initWithHTMLData:quoteData options:self.attributedTitleOptions documentAttributes:nil];
                    quoteContent = attributedQuote.string;
                }
            } else {
                comment.floorNo = @1;
                content = [divPct firstChildWithClassName:@"pcb"].raw;
//                content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                content = [content stringByReplacingOccurrencesOfString:@"class=\"ptg mbm mtn\"" withString:@"style=\"display:none\""];
                content = [content stringByReplacingOccurrencesOfString:@"class=\"fullvfastpost\"" withString:@"style=\"display:none\""];
                content = [content stringByReplacingOccurrencesOfString:@"class=\"psth xs1\"" withString:@"style=\"display:none\""];
                content = [content stringByReplacingOccurrencesOfString:@"class=\"rate\"" withString:@"style=\"display:none\""];
                content = [content stringByReplacingOccurrencesOfString:@"class=\"modact\"" withString:@"style=\"display:none\""];
                content = [self removeIllegalCharacters:content];
                
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

- (SiteUser *)parseProfileForUser:(NSString *)userId withData:(NSData *)data {
    SiteUser *user = [self siteUserWithID:userId];
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    
    NSArray *titleNodes = [parser searchWithXPathQuery:@"//meta[@name='keywords']"];
    if (titleNodes.count >= 1) {
        NSString *username = [(TFHppleElement *)titleNodes[0] objectForKey:@"content"];
        username = [username stringByReplacingOccurrencesOfString:@"的个人资料" withString:@""];
        user.username = username;
    }
    
    NSArray *nodes = [parser searchWithXPathQuery:@"//div[@class='pbm mbm bbda cl']"];
    if (nodes.count >= 1) {
        TFHppleElement *profileNode = nodes[0];
        
        NSArray *ulNodes = [profileNode childrenWithTagName:@"ul"];
        if (ulNodes.count >= 4) {
            NSArray *signatureNodes = [(TFHppleElement *)ulNodes[1] childrenWithTagName:@"li"];
            for (TFHppleElement *item in signatureNodes) {
                NSString *sign = [[item firstChildWithTagName:@"em"] firstTextChild].content;
                if ([sign hasPrefix:@"个人签名"]) {
                    NSString *rawSignHtml = [item firstChildWithTagName:@"table"].raw;
                    NSData *signData = [rawSignHtml dataUsingEncoding:NSUTF8StringEncoding];
                    NSAttributedString *attributedSign = [[NSAttributedString alloc] initWithHTMLData:signData options:self.attributedTitleOptions documentAttributes:nil];
                    user.signature = attributedSign.string;
                    break;
                }
            }
            
            NSArray *infoNodes = [(TFHppleElement *)ulNodes[3] childrenWithTagName:@"li"];
            for (TFHppleElement *item in infoNodes) {
                NSString *itemName = [[item firstChildWithTagName:@"em"] firstTextChild].content;
                itemName = [itemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *itemValue = [item firstTextChild].content;
                itemValue = [itemValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if ([@"性别" isEqualToString:itemName]) {
                    if (![itemValue hasPrefix:@"保密"]) {
                        user.gender = itemValue;
                    }
                    continue;
                } else if([@"生日" isEqualToString:itemName]) {
                    if (![itemValue isEqualToString:@"-"] && ![itemValue isEqualToString:@""]) {
                        user.birthdate = itemValue;
                    }
                    continue;
                } else if([@"毕业学校" isEqualToString:itemName]) {
                    user.college = itemValue;
                    continue;
                } else if([@"学历" isEqualToString:itemName]) {
                    user.degree = itemValue;
                    continue;
                } else if([@"目前专业" isEqualToString:itemName]) {
                    user.major = itemValue;
                    continue;
                }
            }
        }
    }
    return user;
}

- (SiteUser *)siteUserWithID:(NSString *)userId {
    SiteUser *user = nil;
    NSManagedObjectContext *context = [DataManager sharedInstance].mainObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SiteUser" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userId == '%@'", userId]]];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    for (SiteUser *item in fetchedObjects) {
        if ([item.userId isEqualToString:userId]) {
            user = item;
            break;
        }
    }
    
    if (!user) {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"SiteUser" inManagedObjectContext:context];
        user.userId = userId;
    }
    
    return user;
}

- (NSOrderedSet *)parsePostsForUser:(NSString *)userId withData:(NSData *)data {
    SiteUser *user = [self siteUserWithID:userId];
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    NSArray *thNodes = [parser searchWithXPathQuery:@"//th"];
    for (TFHppleElement *item in thNodes) {
        TFHppleElement *aNode = [item firstChildWithTagName:@"a"];
        NSString *url = [aNode objectForKey:@"href"];
        NSString *title = [aNode firstTextChild].content;
        if (!aNode || !url || !title) {
            continue;
        } else {
            NSString *articleId = [[InfoURLMapper sharedInstance] getArticleIDfromURL:url];
            if (articleId) {
                Article *article = [self articleWithID:articleId];
                article.shortTitle = title;
                article.author = user;
                [user addPostsObject:article];
            }
        }
    }
    
    return user.posts;
}

- (NSMutableDictionary *)parseReplyFormData:(NSData *)data {
    TFHpple *parser = [TFHpple hppleWithXMLData:data];
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObject:@"true" forKey:@"replysubmit"];
    TFHppleElement *root = [parser peekAtSearchWithXPathQuery:@"//root/text()"];
    if (!root) {
        return nil;
    }
    NSData *rootData = [root.content dataUsingEncoding:NSUTF8StringEncoding];
    parser = [TFHpple hppleWithHTMLData:rootData];
    NSArray *fields = [parser searchWithXPathQuery:@"//input"];
    for (TFHppleElement *field in fields) {
        NSString *name = [field objectForKey:@"name"];
        NSString *value = [field objectForKey:@"value"];
        [formData setValue:value forKey:name];
    }
    return formData;
}

- (Article *)articleWithID:(NSString *)articleID {
    Article *article = nil;
    NSManagedObjectContext *context = [DataManager sharedInstance].mainObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"articleID == '%@'", articleID]]];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    for (Article *item in fetchedObjects) {
        if ([item.articleID isEqualToString:articleID]) {
            article = item;
            break;
        }
    }
    
    if (!article) {
        // add a new row in database
        article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:context];
        article.articleID = articleID;
    }
    
    return article;
}

- (NSOrderedSet *)parseUnreadNotifsWithData:(NSData *)data {
    NSMutableOrderedSet *unreadNotifs = [NSMutableOrderedSet orderedSet];
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    TFHppleElement *nts = [parser peekAtSearchWithXPathQuery:@"//div[@class='nts']"];
    if (!nts) {
        return unreadNotifs;
    }
    InfoURLMapper *urlMapper = [InfoURLMapper sharedInstance];
    NSArray *children = [nts childrenWithTagName:@"dl"];
    for (TFHppleElement *child in children) {
        TFHppleElement *ntc_body = [child firstChildWithClassName:@"ntc_body"];
        NSArray *linkNodes = [ntc_body childrenWithTagName:@"a"];
        if (linkNodes.count < 3) { // <a>Who</a> replied <a>Subject</a> <a>View</a>
            continue;
        }
        TFHppleElement *userLinkNode = linkNodes[0];
        NSString *userLink = [userLinkNode objectForKey:@"href"];
        NSString *userId = [urlMapper getUserIDfromUserLink:userLink];
        if (userId) {
            NSString *notifID = [child objectForKey:@"notice"];
            SiteNotif *notif = [self siteNotifWithID:notifID];
            notif.userId = userId;
            notif.username = userLinkNode.text;
            
            TFHppleElement *postLinkNode = linkNodes[1];
            notif.articleTitle = postLinkNode.text;
            NSString *postLink = [postLinkNode objectForKey:@"href"];
            notif.articleID = [urlMapper getNotifArticleIDfromURL:postLink];
            notif.postID = [urlMapper getNotifPostIDfromURL:postLink];
            
            NSString *notifContent = [ntc_body.raw stringByReplacingOccurrencesOfString:@"查看" withString:@""];
            notif.notifContent = notifContent;
            [unreadNotifs addObject:notif];
        }
    }
    
    return unreadNotifs;
}

- (SiteNotif *)siteNotifWithID:(NSString *)notifID {
    SiteNotif *notif = nil;
    NSManagedObjectContext *context = [DataManager sharedInstance].mainObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SiteNotif" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"notifID == '%@'", notifID]]];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    for (SiteNotif *item in fetchedObjects) {
        if ([item.notifID isEqualToString:notifID]) {
            notif = item;
            break;
        }
    }
    
    if (!notif) {
        // add a new row in database
        notif = [NSEntityDescription insertNewObjectForEntityForName:@"SiteNotif" inManagedObjectContext:context];
        notif.notifID = notifID;
    }
    
    return notif;
}

@end
