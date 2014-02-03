//
//  Board.h
//  Ipoint3acres
//
//  Created by YUAN on 14-2-4.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article;

@interface Board : NSManagedObject

@property (nonatomic) BOOL hidden;
@property (nonatomic) int32_t index;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSOrderedSet *articles;
@end

@interface Board (CoreDataGeneratedAccessors)

- (void)insertObject:(Article *)value inArticlesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromArticlesAtIndex:(NSUInteger)idx;
- (void)insertArticles:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeArticlesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInArticlesAtIndex:(NSUInteger)idx withObject:(Article *)value;
- (void)replaceArticlesAtIndexes:(NSIndexSet *)indexes withArticles:(NSArray *)values;
- (void)addArticlesObject:(Article *)value;
- (void)removeArticlesObject:(Article *)value;
- (void)addArticles:(NSOrderedSet *)values;
- (void)removeArticles:(NSOrderedSet *)values;
@end
