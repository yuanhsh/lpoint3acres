//
//  SettingManager.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/03/06.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingManager : NSObject

@property (nonatomic, assign) BOOL showStickThread;

+ (SettingManager*)sharedInstance;

@end
