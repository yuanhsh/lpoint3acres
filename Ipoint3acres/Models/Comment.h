//
//  Comment.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/03.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * articleURL;
@property (nonatomic, retain) NSString * content;
@property (nonatomic) NSTimeInterval createDate;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) Article *article;

@end
