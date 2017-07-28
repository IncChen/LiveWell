//
//  RegexTool.h
//  LiveWell
//
//  Created by Mark on 2017/6/15.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegexTool : NSObject

+ (BOOL)isNumText:(NSString *)str;
+ (BOOL)isNumAndLetterText:(NSString *)str;
+ (BOOL)isContainPassword:(NSString *)str;
+ (BOOL)isContainPwdCondition:(NSString *)str;

@end
