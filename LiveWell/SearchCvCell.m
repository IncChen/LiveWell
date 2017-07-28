//
//  SearchCvCell.m
//  LiveWell
//
//  Created by Mark on 2017/7/24.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "SearchCvCell.h"

@interface SearchCvCell ()

@property (nonatomic, strong) UIButton *optionBtn;

@end

@implementation SearchCvCell

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
    _optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _optionBtn.titleLabel.font = [UIFont systemFontOfSize:kCellTitleFontSize];
    _optionBtn.layer.cornerRadius = 4.0f;
    _optionBtn.clipsToBounds = YES;
    [_optionBtn addTarget:self action:@selector(didSelectedOptionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_optionBtn];
}

#pragma mark - 公共方法
- (void)setOption:(NSString *)option {
    _option = option;
    CGSize titleSize = [option boundingRectWithSize:CGSizeMake(54, 36) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kCellTitleFontSize]} context:nil].size;
    self.optionBtn.frame = CGRectMake(0, 0, titleSize.width+12*2, titleSize.height+8*2);
    [self.optionBtn setTitle:option forState:UIControlStateNormal];
    [self.optionBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    [self.optionBtn setBackgroundColor:RGB(245, 245, 245)];
}

#pragma mark - Actions 

- (void)didSelectedOptionAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedOption:)]) {
        [self.delegate didSelectedOption:self.option];
    }
}

@end
