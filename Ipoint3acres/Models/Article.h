//
//  Article.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/06.
//  Copyright (c) 2014年 Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Board, Comment, SiteUser;

@interface Article : NSManagedObject

@property (nonatomic, retain) NSString * articleID;
@property (nonatomic, retain) NSString * articleURL;
@property (nonatomic, retain) NSString * authorID;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * createDate;
@property (nonatomic, retain) NSNumber * isStick;
@property (nonatomic, retain) NSNumber * isViewed;
@property (nonatomic, retain) NSString * lastCommentDate;
@property (nonatomic, retain) NSString * lastCommenter;
@property (nonatomic, retain) NSString * lastCommenterID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSData * titleData;
@property (nonatomic, retain) NSNumber * viewCount;
@property (nonatomic, retain) Board *board;
@property (nonatomic, retain) SiteUser *author;
@property (nonatomic, retain) NSOrderedSet *comments;
@end

@interface Article (CoreDataGeneratedAccessors)

- (void)insertObject:(Comment *)value inCommentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCommentsAtIndex:(NSUInteger)idx;
- (void)insertComments:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCommentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCommentsAtIndex:(NSUInteger)idx withObject:(Comment *)value;
- (void)replaceCommentsAtIndexes:(NSIndexSet *)indexes withComments:(NSArray *)values;
- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSOrderedSet *)values;
- (void)removeComments:(NSOrderedSet *)values;
@end
