//
//  AppDelegate.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/01/30.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import "AppDelegate.h"
#import "DataManager.h"
#import "Common.h"
#import <Crashlytics/Crashlytics.h>
#import "Appirater.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//#if !TARGET_IPHONE_SIMULATOR
    [Crashlytics startWithAPIKey:@"ee4a474b359556a7b49c6ece60bcc4d954b89063"];
    [Flurry startSession:@"JPR4T5DXMX2V3TQG2X49"];
//#endif
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [Appirater setAppId:@"840772542"];
    [Appirater setDaysUntilPrompt:2];
    [Appirater setUsesUntilPrompt:3];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setOpenInAppStore:YES];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (isIOS7) {
        [[UINavigationBar appearance] setBarTintColor:RGBCOLOR(0,122,255)];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    __block UIBackgroundTaskIdentifier backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void) {
        [application endBackgroundTask:backgroundTaskIdentifier];
//        [[DownloadManager sharedInstance] cancelAllOperations];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[DataManager sharedInstance] save];
        });
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[DataManager sharedInstance] save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[DataManager sharedInstance] save];
}

@end
