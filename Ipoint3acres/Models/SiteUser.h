//
//  SiteUser.h
//  Ipoint3acres
//
//  Created by YUAN on 14-2-19.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article;

@interface SiteUser : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) Article *posts;
@property (nonatomic, retain) Article *favorites;

@end
