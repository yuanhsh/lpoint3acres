//
//  Comment.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/04.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * articleURL;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * createDate;
@property (nonatomic) int32_t commenterID;
@property (nonatomic, retain) NSString * commenterName;
@property (nonatomic, retain) Article *article;

@end
