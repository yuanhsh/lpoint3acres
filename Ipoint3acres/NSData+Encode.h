//
//  NSData+Encode.h
//  Galapagos
//
//  Created by YUAN on 12/05/04.
//  Copyright (c) 2012年 YUAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encode)
- (NSData *)pkcs5;
- (NSData*)AES128EncryptWithKey:(NSString*)key iv:(NSString*)iv;
- (NSData*)AES128DecryptWithKey:(NSString*)key iv:(NSString*)iv;
- (NSString*)hex;
//- (uint32_t)crc32;
- (NSString*)md5;
@end
