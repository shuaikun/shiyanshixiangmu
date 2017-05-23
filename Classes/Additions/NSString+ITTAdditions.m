//
//  NSString+ITTAdditions.m
//
//  Created by Jack on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "UIFont+ITTAdditions.h"


@implementation NSString (ITTAdditions)

- (NSInteger)numberOfLinesWithFont:(UIFont*)font
                     withLineWidth:(NSInteger)lineWidth
{
    CGSize size = [self sizeWithFont:font
                   constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                       lineBreakMode:NSLineBreakByTruncatingTail];
	NSInteger lines = size.height / [font ittLineHeight];
	return lines;
}

- (CGFloat)heightWithFont:(UIFont*)font
            withLineWidth:(NSInteger)lineWidth
{
    CGSize size = [self sizeWithFont:font
                   constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                       lineBreakMode:NSLineBreakByTruncatingTail];
	return size.height;
	
}

- (NSString *)md5
{
	const char *concat_str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(concat_str, strlen(concat_str), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < 16; i++){
		[hash appendFormat:@"%02X", result[i]];
	}
	return [hash lowercaseString];
	
}

- (NSString*)encodeUrl
{
	NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
	if (newString) {
		return newString;
	}
	return @"";
}

- (BOOL)isStartWithString:(NSString*)start
{
    BOOL result = FALSE;
    NSRange found = [self rangeOfString:start options:NSCaseInsensitiveSearch];
    if (found.location == 0)
    {
        result = TRUE;
    }
    return result;
}

- (BOOL)isEndWithString:(NSString*)end
{
    NSInteger endLen = [end length];
    NSInteger len = [self length];
    BOOL result = TRUE;
    if (endLen <= len) {
        NSInteger index = len - 1;
        for (NSInteger i = endLen - 1; i >= 0; i--) {
            if ([end characterAtIndex:i] != [self characterAtIndex:index]) {
                result = FALSE;
                break;
            }
            index--;
        }
    }
    else {
        result = FALSE;
    }
    return result;
}

+ (NSString*)stringWithFileInMainBundle:(NSString*)fileName ofType:(NSString*)ext
{
	NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
	return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

/*!
 * base64编码用的查表
 */
static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
	52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
	-2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
	15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
	-2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

/*!
 * md5加密
 */
+ (NSString *)encryptPassword:(NSString *)str
{
    // MD5 加密密码
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString  stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4],
            result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12],
            result[13], result[14], result[15]
            ];
}

/*!
 * 对一个二进制数组进行3DES加密或者解密，使用key做为密钥，返回加密或者解密后的二进制结果
 * 3DES算法要求密钥是24字节长，这里要求一个24个字符的字符串做为参数
 */
+ (NSData *)doCipherWithData:(NSData*)data key:(NSString*)key operation:(CCOperation)encryptOrDecrypt
{
	const void * dataIn;
	size_t dataInLength;
	
	dataInLength = [data length];
	dataIn = [data bytes];
	
	CCCryptorStatus ccStatus;
	uint8_t * dataOut = NULL;
	size_t dataOutAvailable = 0;
	size_t dataOutMoved = 0;
	// uint8_t ivkCCBlockSize3DES;
	
	dataOutAvailable = (dataInLength + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
	
	dataOut = malloc(dataOutAvailable * sizeof(uint8_t));
	memset((void *)dataOut, 0x0, dataOutAvailable);
	
	uint8_t iv[kCCBlockSize3DES];
	memset((void *) iv, 0x0, (size_t) sizeof(iv));
	
	const void * vkey = (const void *)[key UTF8String];
	
	ccStatus = CCCrypt(encryptOrDecrypt,
					   kCCAlgorithm3DES,
					   kCCOptionPKCS7Padding,
					   vkey, // 24字节的key
					   kCCKeySize3DES,
					   iv,
					   dataIn, //plainText,
					   dataInLength,
					   (void *)dataOut,
					   dataOutAvailable,
					   &dataOutMoved);
	
	if (ccStatus != kCCSuccess) NSLog(@"cryptor error: ccStatus=%d", ccStatus);
	
	return [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
}


/*!
 * 对一个字符串进行加密，返回base64编码后的结果
 */
- (NSString *)encryptWithKey:(NSString*)key
{
	NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSData * dataout = [NSString doCipherWithData:data key:key operation:kCCEncrypt];
	return [NSString encodeBase64WithData:dataout];
}

/*!
 * 对一个base64编码的字符串进行解密
 */
- (NSString *)decryptBase64WithKey:(NSString*)key
{
	NSData *datain = [NSString decodeBase64WithString:self];
	NSData *dataout = [NSString doCipherWithData:datain key:key operation:kCCDecrypt];
	return [[NSString alloc] initWithData:dataout encoding:NSUTF8StringEncoding];
}

/*!
 * 返回base64编码结果
 */
- (NSString *)base64String
{
	return [NSString encodeBase64WithData:[self dataUsingEncoding:NSUTF8StringEncoding]];
}

/*!
 * 对二进制数据进行base64编码
 */
+ (NSString *)encodeBase64WithData:(NSData *)objData
{
	const unsigned char * objRawData = [objData bytes];
	char * objPointer;
	char * strResult;
	
	// Get the Raw Data length and ensure we actually have data
	int intLength = [objData length];
	if (intLength == 0) return nil;
	
	// Setup the String-based Result placeholder and pointer within that placeholder
	strResult = (char *)calloc(((intLength + 2) / 3) * 4 + 1, sizeof(char));
	objPointer = strResult;
	
	// Iterate through everything
	while (intLength > 2) { // keep going until we have less than 24 bits
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
		*objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
		*objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
		
		// we just handled 3 octets (24 bits) of data
		objRawData += 3;
		intLength -= 3;
	}
	
	// now deal with the tail end of things
	if (intLength != 0) {
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		if (intLength > 1) {
			*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
			*objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
			*objPointer++ = '=';
		} else {
			*objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
			*objPointer++ = '=';
			*objPointer++ = '=';
		}
	}
	
	// Terminate the string-based result
	*objPointer = '\0';
	
	// Return the results as an NSString object
	NSString *result = @(strResult);
	free(strResult);
	return result;
}

/*!
 * 把base64字符串解码成二进制数据
 */
+ (NSData *)decodeBase64WithString:(NSString *)strBase64
{
	const char * objPointer = [strBase64 cStringUsingEncoding:NSASCIIStringEncoding];
	int intLength = strlen(objPointer);
	int intCurrent;
	int i = 0, j = 0, k;
	
	unsigned char * objResult;
	objResult = calloc(intLength, sizeof(char));
	
	// Run through the whole string, converting as we go
	while ( ((intCurrent = *objPointer++) != '\0') && (intLength-- > 0) ) {
		if (intCurrent == '=') {
			if (*objPointer != '=' && ((i % 4) == 1)) {// || (intLength > 0)) {
				// the padding character is invalid at this point -- so this entire string is invalid
				free(objResult);
				return nil;
			}
			continue;
		}
		
		intCurrent = _base64DecodingTable[intCurrent];
		if (intCurrent == -1) {
			// we're at a whitespace -- simply skip over
			continue;
		} else if (intCurrent == -2) {
			// we're at an invalid character
			free(objResult);
			return nil;
		}
		
		switch (i % 4) {
			case 0:
				objResult[j] = intCurrent << 2;
				break;
				
			case 1:
				objResult[j++] |= intCurrent >> 4;
				objResult[j] = (intCurrent & 0x0f) << 4;
				break;
				
			case 2:
				objResult[j++] |= intCurrent >>2;
				objResult[j] = (intCurrent & 0x03) << 6;
				break;
				
			case 3:
				objResult[j++] |= intCurrent;
				break;
		}
		i++;
	}
	
	// mop things up if we ended on a boundary
	k = j;
	if (intCurrent == '=') {
		switch (i % 4) {
			case 1:
				// Invalid state
				free(objResult);
				return nil;
				
			case 2:
				k++;
				// flow through
			case 3:
				objResult[k] = 0;
		}
	}
	
	// Cleanup and setup the return NSData
	NSData * objData = [[NSData alloc] initWithBytes:objResult length:j];
	free(objResult);
	return objData;
}

+ (NSString*)stringFromDeviceToken:(NSData*)data{
    NSString *ret = nil;
    const unsigned* tokenBytes = [data bytes];
    ret = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
           ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
           ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
           ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    return ret;
}

- (NSString*)stringFormatterWithStr:(NSString *)formatterString
{
    NSString *willReplaceStr = @"";
    NSString *hasSuffix = @"";
    if ([self hasSuffix:@".jpg"]) {
        if ([self hasSuffix:@"_b.jpg"]) {
            hasSuffix = @"_b.jpg";
        }else if ([self hasSuffix:@"_s.jpg"]){
            hasSuffix = @"_s.jpg";
        }else if ([self hasSuffix:@".jpg"]){
            hasSuffix = @".jpg";
        }
        willReplaceStr = [NSString stringWithFormat:@"_%@.jpg",formatterString];
    }else if ([self hasSuffix:@".jpeg"]){
        if ([self hasSuffix:@"_b.jpeg"]) {
            hasSuffix = @"_b.jpeg";
        }else if ([self hasSuffix:@"_s.jpeg"]){
            hasSuffix = @"_s.jpeg";
        }else if ([self hasSuffix:@".jpeg"]){
            hasSuffix = @".jpeg";
        }
        willReplaceStr = [NSString stringWithFormat:@"_%@.jpeg",formatterString];
    }else if ([self hasSuffix:@".png"]){
        if ([self hasSuffix:@"_b.png"]) {
            hasSuffix = @"_b.png";
        }else if ([self hasSuffix:@"_s.png"]){
            hasSuffix = @"_s.png";
        }else if ([self hasSuffix:@".png"]){
            hasSuffix = @".png";
        }
        willReplaceStr = [NSString stringWithFormat:@"_%@.png",formatterString];
    }
    return [self stringByReplacingOccurrencesOfString:hasSuffix withString:willReplaceStr];
}
@end

