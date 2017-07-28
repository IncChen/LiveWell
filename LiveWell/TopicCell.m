//
//  TopicCell.m
//  LiveWell
//
//  Created by Mark on 2017/7/27.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "TopicCell.h"

@interface TopicCell ()

@property (nonatomic, strong) UIButton *topicBtn;

@end

@implementation TopicCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化
        [self setup];
        
        // 创建自控制器
        [self setupSubViews];
    }
    return self;
}

#pragma mark - 公共方法
- (void)setTopicUrl:(NSString *)topicUrl {
    _topicUrl = topicUrl;
    [self.topicBtn setImage:[UIImage imageNamed:self.topicUrl] forState:UIControlStateNormal];
}

#pragma mark - 私有方法
#pragma mark - 初始化
- (void)setup {
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundView = backgroundView;
}

#pragma mark - 创建自控制器
- (void)setupSubViews {
    _topicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _topicBtn.frame = CGRectMake(0, 0, topicCellWidth, topicCellHeight);
    _topicBtn.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_topicBtn];
}

@end
