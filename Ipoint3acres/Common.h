//
//  Common.h
//  Ipoint3acres
//
//  Created by YUAN on 14-2-2.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "UIColor+iOS7.h"
#import "Flurry.h"

#define RGBCOLOR(r,g,b) RGBACOLOR(r,g,b,1.0f)
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#define DocumentsDirectory  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define LibraryDirectory    [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
#define CachesDirectory     [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define DataDirectory       [LibraryDirectory stringByAppendingPathComponent:@"Datas"]

#define isIOS7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define kDefaultContentFontSize 16.0f
#define kDefaultQuoteFontSize 14.0f

#define kCommentSuccessNotification @"PostCommentSuccessNotification"
#define kBoardReorderNotification   @"BoardConfigReorderNotification"

#define kShowStickThreadKey @"ShowStickThreadKey"