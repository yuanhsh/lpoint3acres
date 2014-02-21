//
//  DataManager.h
//  BookReader
//
//  Created by 苑　海勝 on 2013/11/29.
//  Copyright (c) 2013年 苑　海勝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+JSON.h"

extern NSString * const DataManagerDidSaveNotification;
extern NSString * const DataManagerDidSaveFailedNotification;

@interface DataManager : NSObject {
}

@property (nonatomic, readonly, strong) NSManagedObjectModel *objectModel;
@property (nonatomic, readonly, strong) NSManagedObjectContext *mainObjectContext;
@property (nonatomic, readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (DataManager*)sharedInstance;
+ (NSString *)UUID;
- (BOOL)save;
- (NSManagedObjectContext*)mainObjectContext;
- (NSManagedObjectContext*)childObjectContext;
//- (NSManagedObjectContext*)managedObjectContext;

@end
