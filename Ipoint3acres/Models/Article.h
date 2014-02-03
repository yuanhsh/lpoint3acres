//
//  Article.h
//  Ipoint3acres
//
//  Created by YUAN on 14-2-4.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Board, Comment;

@interface Article : NSManagedObject

@property (nonatomic, retain) NSString * articleURL;
@property (nonatomic) int32_t commentCount;
@property (nonatomic, retain) NSString * content;
@property (nonatomic) NSTimeInterval createDate;
@property (nonatomic) NSTimeInterval lastCommentDate;
@property (nonatomic, retain) NSString * lastCommenter;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic) int32_t viewCount;
@property (nonatomic, retain) NSString * articleID;
@property (nonatomic) BOOL isStick;
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
