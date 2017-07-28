//
//  CommentModel.m
//  LiveWell
//
//  Created by Mark on 2017/7/12.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (CommentModel *)initWithDictionary:(NSDictionary *)dic {
    if (self == [super init]) {
        self.Id = [dic[@"Id"] longLongValue];
        self.date = dic[@"date"];
        self.comment = dic[@"comment"];
        self.nickname = dic[@"nickname"];
        self.avatar = dic[@"avatar"];
        self.isLike = [dic[@"isLike"] boolValue];
        self.like = [dic[@"like"] integerValue];
        self.linked = [dic[@"linked"] integerValue];
    }
    return self;
}

+ (CommentModel *)statusWithDictionary:(NSDictionary *)dic {
    CommentModel *model = [[CommentModel alloc] initWithDictionary:dic];
    return model;
}

- (NSString *)dateText {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    return [format stringFromDate:self.date];
}

- (BOOL)isLinked {
    if (self.linked >= 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}

@end
