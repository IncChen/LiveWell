//
//  PicStatus.m
//  LiveWell
//
//  Created by Mark on 2017/7/5.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "PicStatus.h"

@implementation PicStatus

- (PicStatus *)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.Id = [dic[@"Id"] longLongValue];
        self.likeModel = [[LikeModel alloc] initWithDictionary:dic[@"like"]];
        self.starModel = [[StarModel alloc] initWithDictionary:dic[@"star"]];
        self.nickname = dic[@"nickname"];
        self.avatar = dic[@"avatar"];
        self.types = dic[@"types"];
        self.content = dic[@"content"];
        self.image = dic[@"image"];
        self.sub = [dic[@"sub"] boolValue];
        self.date = dic[@"date"];
        self.comments = [[NSMutableArray alloc] init];

        NSArray *array = dic[@"comments"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CommentModel *model = [[CommentModel alloc] initWithDictionary:obj];
            if (model.like > 2) {
                //属于热门评论
                model.isHotComment = TRUE;
            } else {
                model.isHotComment = FALSE;
            }
            [self.comments addObject:model];
        }];
    }
    return self;
}

+ (PicStatus *)statusWithDictionary:(NSDictionary *)dic {
    PicStatus *status = [[PicStatus alloc] initWithDictionary:dic];
    return status;
}

- (NSString *)typeText {
    return [self.types componentsJoinedByString:@""];
}

- (NSString *)dateText {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    return [format stringFromDate:self.date];
}

@end
