//
//  NSData+Encryption.h
//  HyLife
//
//  Created by Murphy Zheng on 16/9/13.
//  Copyright © 2016年 Mieasy. All rights reserved.
//  采用AES对图片数据进行加密和解密

#import <Foundation/Foundation.h>

@interface NSData (Encryption)

/**
 *  eg. 对字符串加密
 *  NSData *dt1 = [str dataUsingEncoding:NSUTF8StringEncoding];
 *  NSData *dt2 = [dt1 AES256EncryptWithKey:@"key"];
 *  NSString *str2 = [dt2 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
 */

//加密
- (NSData *)AES256EncryptWithKey:(NSString *)key;
//解密
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
