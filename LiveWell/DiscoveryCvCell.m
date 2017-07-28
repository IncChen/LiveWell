//
//  DiscoveryCvCell.m
//  LiveWell
//
//  Created by Mark on 2017/7/26.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "DiscoveryCvCell.h"
#import "ReleaseButton.h"

@interface DiscoveryCvCell ()

@property (nonatomic, strong) ReleaseButton *discoveryBtn;

@end

@implementation DiscoveryCvCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self setupSubViews];
    }
    return self;
}

#pragma mark - 私有方法
#pragma mark - 初始化
- (void)setup {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundView = backgroundView;
}

#pragma mark - 创建自控制器
- (void)setupSubViews {
    _discoveryBtn = [[ReleaseButton alloc] init];
    _discoveryBtn.frame = CGRectMake(0, 0, 48, 48);
    [_discoveryBtn setTitleColor:RGB(118, 118, 118) forState:UIControlStateNormal];
    [_discoveryBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [self.contentView addSubview:_discoveryBtn];
}

#pragma mark - 公共方法
- (void)setSection:(UserSection *)section {
    _section = section;
    [self.discoveryBtn setTitle:section.textLabel forState:UIControlStateNormal];
    [self.discoveryBtn setImage:[UIImage imageNamed:section.imageName] forState:UIControlStateNormal];
}

@end
