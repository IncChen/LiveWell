//
//  FindStatus.m
//  LiveWell
//
//  Created by Mark on 2017/7/27.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "FindStatus.h"

@implementation FindStatus

- (FindStatus *)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.Id = [dic[@"Id"] longLongValue];
        self.nickname = dic[@"nickname"];
        self.avatar = dic[@"avatar"];
        self.pro = [dic[@"pro"] integerValue];
        self.picUrl = dic[@"picUrl"];
        self.content = dic[@"content"];
        self.type = dic[@"type"];
        self.area = dic[@"area"];
        self.huxing = dic[@"huxing"];
    }
    return self;
}

+ (FindStatus *)statusWithDictionary:(NSDictionary *)dic {
    FindStatus *status = [[FindStatus alloc] initWithDictionary:dic];
    return status;
}

- (NSString *)proUrl{
    int pro = self.pro;
    switch (pro) {
        case 0:
            return @"";
        case 1:
            return @"icon_designer_pro";
        case 2:
            return @"icon_brand_pro";
        default:
            return @"";
    }
}

@end
