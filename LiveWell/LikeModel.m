//
//  LikeModel.m
//  LiveWell
//
//  Created by Mark on 2017/7/11.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "LikeModel.h"

@implementation LikeModel

- (LikeModel *)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.isLike = [dic[@"isLike"] boolValue];
        self.num = [dic[@"num"] integerValue];
    }
    return self;
}

+ (LikeModel *)statusWithDictionary:(NSDictionary *)dic {
    LikeModel *model = [[LikeModel alloc] initWithDictionary:dic];
    return model;
}

@end
