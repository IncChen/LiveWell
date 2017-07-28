//
//  CommentModel.h
//  LiveWell
//
//  Created by Mark on 2017/7/12.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic, assign) long long Id;//评论Id
@property (nonatomic, strong) NSDate *date;//发布日期
@property (nonatomic, copy) NSString *comment;//评论内容
@property (nonatomic, copy) NSString *nickname;//昵称
@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, assign) Boolean *isLike;//自己有没有点赞
@property (nonatomic, assign) NSInteger *like;//点赞数
@property (nonatomic, assign) NSInteger *linked;//关联Id
@property (nonatomic, assign) BOOL *isHotComment;

- (CommentModel *)initWithDictionary:(NSDictionary *)dic;

+ (CommentModel *)statusWithDictionary:(NSDictionary *)dic;

- (NSString *)dateText;
- (BOOL)isLinked;

@end
