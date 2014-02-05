//
//  Article.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/05.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Board, Comment;

@interface Article : NSManagedObject

@property (nonatomic) int32_t articleID;
@property (nonatomic, retain) NSString * articleURL;
@property (nonatomic) int32_t authorID;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic) int32_t commentCount;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * createDate;
@property (nonatomic) BOOL isStick;
@property (nonatomic, retain) NSString * lastCommentDate;
@property (nonatomic, retain) NSString * lastCommenter;
@property (nonatomic) int32_t lastCommenterID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic) int32_t viewCount;
@property (nonatomic, retain) NSData * titleData;
@property (nonatomic, retain) Board *board;
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
