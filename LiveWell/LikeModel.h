//
//  LikeModel.h
//  LiveWell
//
//  Created by Mark on 2017/7/11.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LikeModel : NSObject

@property (nonatomic, assign) Boolean *isLike;
@property (nonatomic, assign) NSInteger *num;

- (LikeModel *)initWithDictionary:(NSDictionary *)dic;

+ (LikeModel *)statusWithDictionary:(NSDictionary *)dic;

@end
