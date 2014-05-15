//
//  NSData+IllegalChar.h
//  Ipoint3acres
//
//  Created by YUAN on 14-5-15.
//  Copyright (c) 2014年 Haisheng Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (IllegalChar)

- (NSString*) UTF8String;
- (NSData*) dataByHealingUTF8Stream;

@end
