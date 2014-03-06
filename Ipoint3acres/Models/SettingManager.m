//
//  SettingManager.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/03/06.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import "SettingManager.h"

@interface SettingManager ()

@property (nonatomic, strong) NSNumber *showStickDefault;

@end

@implementation SettingManager

@synthesize showStickThread = _showStickThread;

+ (SettingManager*)sharedInstance {
    static dispatch_once_t pred;
	static SettingManager *sharedInstance = nil;
	dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
	return sharedInstance;
}

- (BOOL)showStickThread {
    if (!self.showStickDefault) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.showStickDefault = [defaults objectForKey:kShowStickThreadKey];
        if (self.showStickDefault) {
            _showStickThread = [self.showStickDefault boolValue];
        } else {
            _showStickThread = YES;
            [self setShowStickThread:YES];
        }
    }
    return _showStickThread;
}

- (void)setShowStickThread:(BOOL)showStickThread {
    _showStickThread = showStickThread;
    self.showStickDefault = @(_showStickThread);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(_showStickThread) forKey:kShowStickThreadKey];
    [defaults synchronize];
}

@end
