//
//  NSString+Encode.m
//  Galapagos
//
//  Created by YUAN on 12/05/04.
//  Copyright (c) 2012年 YUAN. All rights reserved.
//

#import "NSString+Encode.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (Encode)

- (NSString*)uri {
	NSString *encodedUrl = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, NULL, kCFStringEncodingUTF8);
	return encodedUrl;
}

- (NSString*)uriEncode {
	NSString *encodedUrl =  (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																(CFStringRef)self,
																NULL,
																(CFStringRef)@"!*'();:@&=+$,/?%#[]",
																kCFStringEncodingUTF8) ;
	
	return encodedUrl;
}

- (NSString *)uriDecode
{
    NSString *uri =  (__bridge NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
																								 (CFStringRef)self,
																								 CFSTR(""),
																								 kCFStringEncodingUTF8);
	return uri;
}


- (NSString*)md5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    char md5string[CC_MD5_DIGEST_LENGTH*2+1];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        sprintf(md5string+i*2,"%02X", digest[i]);
    }
	md5string[CC_MD5_DIGEST_LENGTH*2] = '\0';
    return [NSString stringWithCString:md5string encoding:NSUTF8StringEncoding];
}

+ (NSString*)rand8 {
	u_int32_t r = arc4random();
	char str[128];
	sprintf(str, "%016X", r);
	return [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
}

+ (NSString*)rand16 {
	u_int32_t r = arc4random();
	char str[128];
	sprintf(str, "%032X", r);
	return [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
}

- (NSData*)scanHex {
	const char* src= [self cStringUsingEncoding:NSASCIIStringEncoding];
	int len = [self length] / 2;
	Byte value[len+1];
    Byte *ptr = value;
	
	bzero(value, sizeof(value));
    for ( ;*src; src+=2){
        unsigned int hexByte;
        sscanf(src, "%02X", &hexByte);
        *ptr++= (unsigned char)(hexByte & 0x00FF);
    }
    *ptr= '\0';
	return [NSData dataWithBytes:value length:len];
}

- (void)makeDir {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL success = [fileManager fileExistsAtPath:self];
	if (!success) {
		[fileManager createDirectoryAtPath:self withIntermediateDirectories:YES attributes:nil error:NULL];
	}
}

- (NSString*)formatedDate {
	NSDateFormatter* ndf = [[NSDateFormatter alloc]init];
	[ndf setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
	
	[ndf setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss+0900"];
	NSDate* date = [ndf dateFromString:self];
	NSString* day = nil;
	
	[ndf setDateFormat:@"yyyy/MM/dd HH:mm"];
	day = [ndf stringFromDate:date];
	if (day) {
		return day;
	}
	
	[ndf setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss+09:00"];
	date = [ndf dateFromString:self];
	[ndf setDateFormat:@"yyyy/MM/dd HH:mm"];
	day = [ndf stringFromDate:date];
	if (day) {
		return day;
	}
	
	//[ndf setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:9]];
	[ndf setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss z"];
	date = [ndf dateFromString:self];
	[ndf setDateFormat:@"yyyy/MM/dd HH:mm"];
	day = [ndf stringFromDate:date];
	if (day) {
		return day;
	}
	[ndf setDateFormat:@"yyyy/MM/dd HH:mm:ss+09000"];
	date = [ndf dateFromString:self];
	[ndf setDateFormat:@"yyyy/MM/dd HH:mm"];
	day = [ndf stringFromDate:date];
	if (day) {
		return day;
	}
	
	[ndf setDateFormat:@"yyyy-MM-dd"];
	date = [ndf dateFromString:self];
	[ndf setDateFormat:@"yyyy/MM/dd"];
	day = [ndf stringFromDate:date];
	if (day) {
		return day;
	}
	
	[ndf setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
	date = [ndf dateFromString:self];
	[ndf setDateFormat:@"yyyy/MM/dd HH:mm"];
	day = [ndf stringFromDate:date];
	if (day) {
		return day;
	}
	
	return @"";
}

- (NSString*)formatedDateGB {
	NSDateFormatter* ndf = [[NSDateFormatter alloc]init];
	[ndf setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"] ];
	[ndf setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	[ndf setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
	NSDate* date = [ndf dateFromString:self];
	//[ndf setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:60*60*9]];
	[ndf setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"] ];
	[ndf setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:60*60*9]];
	[ndf setDateFormat:@"yyyy/MM/dd HH:mm"];
	
	NSString* day = [ndf stringFromDate:date];
	if (day) {
		return day;
	}
	
	return @"";
}


- (NSString*)formatedServerDate {
	//2012/07/12 15:39:06
	NSDateFormatter* ndf = [[NSDateFormatter alloc]init];
	[ndf setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"] ];
	[ndf setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
	
	NSDate* dt = [ndf dateFromString:self];
	[ndf setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	//[ndf setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
	
	NSString* r = [ndf stringFromDate:dt];
	
	return r;
}

- (NSString*)formatedServerDateJST {
	//2012/07/12 15:39:06
	NSDateFormatter* ndf = [[NSDateFormatter alloc]init];
	[ndf setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"] ];
	[ndf setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
	
	NSDate* dt = [ndf dateFromString:self];
	NSString* r = [ndf stringFromDate:dt];
	
	return r;
}

- (NSDate*)dateWithServerFormat {
	NSDateFormatter* ndf = [[NSDateFormatter alloc]init];
//	[ndf setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"] autorelease]];
	[ndf setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"] ];
	[ndf setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
//	
	NSDate* dt = [ndf dateFromString:self];
//	
//	[ndf setDateFormat:@"yyyy/MM/dd HH:mm"];
//	
	//NSString* r = [ndf stringFromDate:dt];
	
	return dt;
}

- (NSDate*)date {
	NSDateFormatter* ndf = [[NSDateFormatter alloc]init];
	//	[ndf setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"] autorelease]];
	[ndf setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
	[ndf setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
	//	
	NSDate* dt = [ndf dateFromString:self];
	if (dt) {
		return dt;
	}
	
	[ndf setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"] ];
	
	[ndf setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss+0900"];
	NSDate* date = [ndf dateFromString:self];
	if (date) {
		return date;
	}
	
	[ndf setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss+09:00"];
	date = [ndf dateFromString:self];
	if (date) {
		return date;
	}
	
	[ndf setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss z"];
	date = [ndf dateFromString:self];
	if (date) {
		return date;
	}
	
	[ndf setDateFormat:@"yyyy-MM-dd"];
	date = [ndf dateFromString:self];
	if (date) {
		return date;
	}
	
	[ndf setDateFormat:@"yyyy-MM-dd HH:mm:ss+0900"];
	date = [ndf dateFromString:self];
	
	if (date) {
		return date;
	}
	
	[ndf setDateFormat:@"yyyy-MM-dd HH:mm:ss+09:00"];
	date = [ndf dateFromString:self];
	if (date) {
		return date;
	}
	
	[ndf setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
	date = [ndf dateFromString:self];
	if (date) {
		return date;
	}
	
	[ndf setDateFormat:@"yyyyMMddHHmmss"];
	date = [ndf dateFromString:self];
	if (date) {
		return date;
	}
	
	[ndf setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
	date = [ndf dateFromString:self];
	if (date) {
		return date;
	}
	
	return date;
}


- (NSNumber*)intNumber {
	int num = [self intValue];
	return [NSNumber numberWithInt:num];
}

- (NSString*)parseWithParam:(NSString*)param {
	NSString *val = nil;
	NSString *p = [NSString stringWithFormat:@"%@=", param];
	NSRange a = [self rangeOfString:p];
	if (0 < a.length) {
		val = [self substringFromIndex:(a.location + a.length)];
		NSRange b = [val rangeOfString:@"&"];
		if (0 < b.length) {
			val = [val substringToIndex:b.location];
		}
	}
	return val;
}



- (NSString*)seriesIDWithContentId:(NSString*)contentId {
	NSString *val = nil;
	
	NSRange a = [contentId rangeOfString:@"-" options:NSBackwardsSearch];
	if (0 < a.length) {
		val = [contentId substringToIndex:(a.location + a.length - 1)];
	}
	if (val) {
		return [NSString stringWithFormat:@"%@-%@", val, [[NSNumber numberWithLongLong:(long long)[self hash]] stringValue]];
	}
	return [NSString stringWithFormat:@"%@", [[NSNumber numberWithLongLong:(long long)[self hash]] stringValue]];
}

- (NSString*)toritugiId {
	NSString *val = nil;
	
	NSRange a = [self rangeOfString:@"-" options:NSBackwardsSearch];
	if (0 < a.length) {
		val = [self substringToIndex:(a.location + a.length - 1)];
	}
	return val;
}

+ (NSString *) stringFromHex:(NSString *)str {
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [str length] / 2; i++) {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    
    return [[NSString alloc] initWithData:stringData encoding:NSASCIIStringEncoding];
}

- (NSString *) toHexString {
    NSUInteger len = [self length];
    unichar *chars = malloc(len * sizeof(unichar));
    [self getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for(NSUInteger i = 0; i < len; i++ ) {
        [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
    }
    free(chars);
    
    return hexString;
}

@end
