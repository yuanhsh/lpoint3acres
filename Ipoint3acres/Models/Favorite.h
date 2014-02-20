//
//  Favorite.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/20.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SiteUser;

@interface Favorite : NSManagedObject

@property (nonatomic, retain) NSString * articleId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * favDate;
@property (nonatomic, retain) SiteUser *user;

@end
