//
//  User.h
//  LiveWell
//
//  Created by Mark on 2017/6/20.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

#pragma mark - 属性

//手机号
@property (nonatomic, copy) NSString *phone;
//昵称
@property (nonatomic, copy) NSString *name;
//性别
@property (nonatomic, copy) NSString *sex;
//位置
@property (nonatomic, copy) NSString *location;
//生日
@property (nonatomic, copy) NSString *birthday;
//个人简介
@property (nonatomic, copy) NSString *profile;

#pragma mark - 方法

- (User *)initWithDictionary:(NSDictionary *)dic;

+ (User *)userWithDictionary:(NSDictionary *)dic;

@end
