//
//  CounterfeitNavBarView.m
//  LiveWell
//
//  Created by Mark on 2017/6/22.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "CounterfeitNavBarView.h"

@implementation CounterfeitNavBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        _backgroundView = [UIView new];
        _backgroundView.frame = CGRectMake(0, 0, ScreenWidth, 56.f);
        _backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backgroundView];
        
        _titleLab = [UILabel new];
        _titleLab.frame = CGRectMake(_backgroundView.frame.size.width*0.5-100*0.5, 28, 100, 21);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(8, 24, 32, 32);
        _leftBtn.backgroundColor = [UIColor clearColor];
        [_leftBtn addTarget:self action:@selector(tapLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBtn];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(_backgroundView.frame.size.width-32-8, 24, 32, 32);
        _rightBtn.backgroundColor = [UIColor clearColor];
        [_rightBtn addTarget:self action:@selector(tapRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
        
        _lineView = [UIView new];
        _lineView.frame = CGRectMake(0, _backgroundView.frame.size.height-1, _backgroundView.frame.size.width, 1);
        _lineView.backgroundColor = RGBA(223, 223, 223, 0.7);
        [self addSubview:_lineView];
        _lineView.hidden = YES;
    }
    
    return self;
}

- (void)tapLeftBtn:(id)sender {
    if (_leftBtnTapAction) {
        _leftBtnTapAction();
    }
}

- (void)tapRightBtn:(id)sender {
    if (_rightBtnTapAction) {
        _rightBtnTapAction();
    }
}

@end
