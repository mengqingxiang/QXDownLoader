//
//  NSString+QX.m
//  QXDownLoader
//
//  Created by 孟庆祥 on 2017/5/17.
//  Copyright © 2017年 mengqingxiang. All rights reserved.
//

#import "NSString+QX.h"
#import <CommonCrypto/CommonHMAC.h>
@implementation NSString (QX)
- (NSString*)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
