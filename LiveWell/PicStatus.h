//
//  PicStatus.h
//  LiveWell
//
//  Created by Mark on 2017/7/5.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LikeModel.h"
#import "StarModel.h"
#import "CommentModel.h"


@interface PicStatus : NSObject

#pragma mark - 属性

@property (nonatomic, assign) long long Id;//图片属性Id
@property (nonatomic, strong) LikeModel *likeModel;//被收藏的个数
@property (nonatomic, strong) StarModel *starModel;//被喜欢的个数
@property (nonatomic, copy) NSString *nickname;//用户昵称
@property (nonatomic, copy) NSString *avatar;//用户头像
@property (nonatomic, copy) NSArray *types;//房屋类型或家具类型
@property (nonatomic, copy) NSString *content;//详细说明
@property (nonatomic, copy) NSString *image;//图片内容
@property (nonatomic, assign) Boolean *sub;//订阅
@property (nonatomic, strong) NSDate *date;//发布日期
@property (nonatomic, strong) NSMutableArray *comments;//评论合集

#pragma mark - 方法

//根据字典初始化对象
- (PicStatus *)initWithDictionary:(NSDictionary *)dic;

//初始化对象（静态方法）
+ (PicStatus *)statusWithDictionary:(NSDictionary *)dic;

- (NSString *)typeText;

- (NSString *)dateText;

@end
