//
//  RegexTool.m
//  LiveWell
//
//  Created by Mark on 2017/6/15.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "RegexTool.h"

@implementation RegexTool


/**
 验证字符串是否为纯数字

 @param str 需要验证的字符串
 @return YES:纯数字 NO:夹带其它字符
 */
+ (BOOL)isNumText:(NSString *)str{
    NSString * regex  = @"(/^[0-9]*$/)";
    NSPredicate * pred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return !isMatch;
}

+ (BOOL)isNumAndLetterText:(NSString *)str{
    NSString * regex  = @"(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]";
    NSPredicate * pred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return !isMatch;
}

/**
 6-30位的英文或数字

 @param str 需要验证的字符串
 @return YES:符合条件 NO:不符合条件
 */
+ (BOOL)isContainPassword:(NSString *)str{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,30}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return !isMatch;
}

/**
 支持数字、字母、符号6-20位,必须包含其中至少两种

 @param str 需要验证的密码字符串
 @return YES:符合条件 NO:不符合条件
 */
+ (BOOL)isContainPwdCondition:(NSString *)str{
    NSString * regex  = @"^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{6,20}$";
    NSPredicate *pred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return !isMatch;
}



@end
