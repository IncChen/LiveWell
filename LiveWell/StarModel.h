//
//  StarModel.h
//  LiveWell
//
//  Created by Mark on 2017/7/11.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StarModel : NSObject

@property (nonatomic, assign) Boolean *isStar;
@property (nonatomic, assign) NSInteger *num;

- (StarModel *)initWithDictionary:(NSDictionary *)dic;

+ (StarModel *)statusWithDictionary:(NSDictionary *)dic;

@end
