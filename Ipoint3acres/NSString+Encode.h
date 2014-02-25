//
//  NSString+Encode.h
//  Galapagos
//
//  Created by YUAN on 12/05/04.
//  Copyright (c) 2012年 YUAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Encode)
- (NSString*)uri;
- (NSString*)uriEncode;
- (NSString *)uriDecode;
- (NSString*)md5;
+ (NSString*)rand8;
+ (NSString*)rand16;
- (NSData*)scanHex;
- (void)makeDir;
- (NSString*)formatedDate;
- (NSString*)formatedDateGB;
- (NSString*)formatedServerDate;
- (NSString*)formatedServerDateJST;
- (NSNumber*)intNumber;
- (NSDate*)dateWithServerFormat;
- (NSDate*)date;
- (NSString*)parseWithParam:(NSString*)param;
- (NSString*)seriesIDWithContentId:(NSString*)contentId;
- (NSString*)toritugiId;

+ (NSString *) stringFromHex:(NSString *)str;
- (NSString *) toHexString;

@end
