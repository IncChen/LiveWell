//
//  StarModel.m
//  LiveWell
//
//  Created by Mark on 2017/7/11.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "StarModel.h"

@implementation StarModel

- (StarModel *)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.isStar = [dic[@"isStar"] boolValue];
        self.num = [dic[@"num"] integerValue];
    }
    return self;
}

+ (StarModel *)statusWithDictionary:(NSDictionary *)dic {
    StarModel *model = [[StarModel alloc] initWithDictionary:dic];
    return model;
}

@end
