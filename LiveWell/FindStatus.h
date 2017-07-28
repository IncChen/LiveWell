//
//  FindStatus.h
//  LiveWell
//
//  Created by Mark on 2017/7/27.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindStatus : NSObject

@property (nonatomic, assign) long long Id;//图片属性Id
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger *pro;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *huxing;

//根据字典初始化对象
- (FindStatus *)initWithDictionary:(NSDictionary *)dic;

//初始化对象（静态方法）
+ (FindStatus *)statusWithDictionary:(NSDictionary *)dic;

- (NSString *)proUrl;

@end
