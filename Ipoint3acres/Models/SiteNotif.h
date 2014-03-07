//
//  SiteNotif.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/03/07.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SiteNotif : NSManagedObject

@property (nonatomic, retain) NSString * notifID;
@property (nonatomic, retain) NSString * notifTime;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * articleID;
@property (nonatomic, retain) NSString * articleTitle;
@property (nonatomic, retain) NSString * notifContent;
@property (nonatomic, retain) NSString * postID;
@property (nonatomic, retain) NSNumber * viewed;

@end
