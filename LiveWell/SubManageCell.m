//
//  SubManageCell.m
//  LiveWell
//
//  Created by Mark on 2017/7/18.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "SubManageCell.h"


@interface SubManageCell ()

@property (nonatomic, strong) UIButton *subBtn;

@end

@implementation SubManageCell

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
    _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _subBtn.titleLabel.font = [UIFont systemFontOfSize:kCellTitleFontSize];
    _subBtn.layer.cornerRadius = 4.0f;
    _subBtn.clipsToBounds = YES;
    [_subBtn addTarget:self action:@selector(didCheckedSubAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_subBtn];
}

#pragma mark - 公共方法

- (void)setTheme:(OptionItem *)theme {
    _theme = theme;
    CGSize titleSize = [theme.title boundingRectWithSize:CGSizeMake(92, 36) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kCellTitleFontSize]} context:nil].size;
    self.subBtn.frame = CGRectMake(0, 0, titleSize.width+12*2+12, titleSize.height+8*2);
    [self.subBtn setTitle:theme.title forState:UIControlStateNormal];
    [self updateSubBtnUI:theme];
}

- (void)updateSubBtnUI:(OptionItem *)theme {
    if (theme.isChecked) {
        [self.subBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.subBtn setBackgroundColor:App_Theme_Color];
    } else {
        [self.subBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        [self.subBtn setBackgroundColor:RGB(245, 245, 245)];
    }
}

#pragma mark - Actions

- (void)didCheckedSubAction:(UIButton *)btn {
    self.theme.isChecked = !self.theme.isChecked;
    [self updateSubBtnUI:self.theme];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCheckedSub:)]) {
        [self.delegate didCheckedSub:self.theme];
    }
}

@end
