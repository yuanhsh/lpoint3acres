//
//  NSData+Encode.m
//  Galapagos
//
//  Created by 洋 富岡 on 12/05/04.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSData+Encode.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSString+Encode.h"
#include <zlib.h>
#import "CommonCrypto/CommonDigest.h"

@implementation NSData (Encode)

- (NSData *)pkcs5 {
	NSString *data = [[NSString alloc] initWithData:[self subdataWithRange:NSMakeRange(self.length - 1, 1)] encoding:NSASCIIStringEncoding] ;
    int pad = [data characterAtIndex:0];
    if (pad > self.length) return nil;
    return [self subdataWithRange:NSMakeRange(0, self.length - pad)];
}

- (NSData*)AES128EncryptWithKey:(NSString*)key iv:(NSString*)iv {
	const void* keyPtr = [[key scanHex] bytes];
	const void* ivPtr = NULL;
	if (nil != iv) {
		ivPtr = [[iv scanHex] bytes];
	}
    NSUInteger dataLength		= [self length];
    size_t bufferSize			= dataLength + kCCBlockSizeAES128;
    void* buffer				= malloc(bufferSize);
    size_t numBytesEncrypted	= 0;
	
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          ivPtr, /* initialization vector (optional) */
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
	
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
	
    free(buffer); //free the buffer;
    return nil;
}

- (NSData*)AES128DecryptWithKey:(NSString*)key iv:(NSString*)iv {
	const void* keyPtr = [[key scanHex] bytes];
	const void* ivPtr = NULL;
	if (nil != iv) {
		ivPtr = [[iv scanHex] bytes];
	}

    NSUInteger dataLength		= [self length];
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    size_t numBytesDecrypted    = 0;
	
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          ivPtr /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
	
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
	
    free(buffer); //free the buffer;
    return nil;
}

- (NSString*)hex {
	int len = [self length];
	Byte *bytes = (Byte*)[self bytes];

	char str[len*2+1];
	bzero(str, sizeof(str));
    for (int i = 0; i < len; i++) {
        sprintf(str+i*2,"%02X", bytes[i]);
    }
	str[len*2] = '\0';
    return [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
}

- (uint32_t)crc32 {
    uint32_t crc = crc32(0L, Z_NULL, 0);
    crc = crc32(crc, [self bytes], [self length]);
    return crc;
}

- (NSString*)md5 {
    const char *cStr = [self bytes];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, [self length], digest );
    char md5string[CC_MD5_DIGEST_LENGTH*2+1];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        sprintf(md5string+i*2,"%02x", digest[i]);
    }
	md5string[CC_MD5_DIGEST_LENGTH*2] = '\0';
    return [NSString stringWithCString:md5string encoding:NSUTF8StringEncoding];
}

@end
