//
//  FKGPopOption
//  FKGPopOption
//
//  Created by forkingghost on 16/4/13.
//  Copyright © 2016年 forkingghost. All rights reserved.
//

#import "FKGPopOption.h"

@interface FKGPopOption ()
@property (nonnull, strong) UIView *backgroundView;
@property (nonatomic, strong) FKGPopOptionBlock optionBlock;
@end

@implementation FKGPopOption

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.alpha = 0.0f;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    }
    return self;
}

- (instancetype) option_setupPopOption:(FKGPopOptionBlock)block whichFrame:(CGRect)frame animate:(BOOL)animate {
    self.optionBlock = block;
    [self _setupParams:animate];
    [self _setupBackgourndview:frame];
    return self;
}

- (void) option_show {
    self.isShow = YES;
    [UIView animateWithDuration:self.option_animateTime animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapGesturePressed)];
        [self addGestureRecognizer:tapGesture];
    }];
}


#pragma mark - private

-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void) _setupParams:(BOOL)animate {
    if (self.option_lineHeight == 0) {
        self.option_lineHeight = 40.0f;
    }
    if (self.option_mutiple == 0) {
        self.option_mutiple = 0.7f;
    }
    if (animate) {
        if (self.option_animateTime == 0) {
            self.option_animateTime = 0.2f;
        }
    } else {
        self.option_animateTime = 0;
    }
}

// 创建背景
- (void) _setupBackgourndview:(CGRect)whichFrame {
    self.backgroundView = [UIView new];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView.layer.cornerRadius = 2;
    self.backgroundView.layer.masksToBounds = YES;
    [self addSubview:self.backgroundView];
    [self _setupOption];
    [self _tochangeBackgroudViewFrame:whichFrame];
}

- (void) _setupOption {
    if ((self.option_optionContents&&self.option_optionContents.count>0)) {
        for (NSInteger i = 0; i < self.option_optionContents.count; i++) {
            UIButton *optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            optionButton.frame = CGRectMake(0,
                                            self.option_lineHeight*i,
                                            self.frame.size.width*self.option_mutiple,
                                            self.option_lineHeight);
            optionButton.tag = i;
//            [optionButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:247/255.0 green:181/255.0 blue:44/255.0 alpha:1.0]] forState:UIControlStateNormal];
//            [optionButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:225/255.0 green:226/255.0 blue:44/255.0 alpha:0.7]] forState:UIControlStateHighlighted];
            
            OptionItem *item = self.option_optionContents[i];
            
            [optionButton setTitle:item.title forState:UIControlStateNormal];
            if (item.isChecked) {
                [optionButton setTitleColor:App_Theme_Color forState:UIControlStateNormal];
            } else {
                [optionButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
            }
            [optionButton setTitleColor:App_Theme_Color forState:UIControlStateHighlighted];
            [optionButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
            
            [optionButton addTarget:self action:@selector(_buttonSelectPressed:)
                   forControlEvents:UIControlEventTouchUpInside];
            [self.backgroundView addSubview:optionButton];
            
            UIView *lineView = [UIView new];
            lineView.backgroundColor = [RGB(247, 248, 251) colorWithAlphaComponent:1.0];
            lineView.frame = CGRectMake(0,
                                        self.option_lineHeight*i,
                                        self.frame.size.width*self.option_mutiple,
                                        1);
            [self.backgroundView addSubview:lineView];
            
        }
    }
}


- (void) _tochangeBackgroudViewFrame:(CGRect)whichFrame {
    CGFloat self_w = self.frame.size.width;
    
    CGFloat which_x = whichFrame.origin.x;
    CGFloat which_w = whichFrame.size.width;
    CGFloat which_h = whichFrame.size.height;
    
    CGFloat background_x = which_x-((self_w*self.option_mutiple/2)-which_w/2);
    CGFloat background_y = whichFrame.origin.y-12;
    CGFloat background_w = self_w * self.option_mutiple;
    CGFloat background_h = self.option_lineHeight*self.option_optionContents.count;
    
    if (background_x < 10) {
        background_x = 10;
    }
    if (self_w-(which_x+which_w)<=10||
        ((self_w*self.option_mutiple/2)-which_w/2>=(self_w-(which_x+which_w)))) {
        background_x = self_w-(self_w*self.option_mutiple)-10;
    }
    
    self.backgroundView.frame = CGRectMake(background_x, background_y, background_w, background_h);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_drop_up"]];
    [self addSubview:imageView];
    imageView.frame = CGRectMake(which_x+which_w/2-12,
                                 background_y-16,
                                 24,
                                 20);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

// 点击消失
- (void) _tapGesturePressed {
    [self dismiss];
}

- (void)dismiss {
    self.isShow = NO;
    [UIView animateWithDuration:self.option_animateTime animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:self.option_animateTime animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

#pragma mark - inside outside down

- (void) _buttonSelectPressed:(UIButton *)button {
    for (int i = 0 ; i < self.option_optionContents.count; i++) {
        OptionItem *item = self.option_optionContents[i];
        if (i == button.tag) {
            item.isChecked = YES;
        } else {
            item.isChecked = NO;
        }
    }
    
    self.optionBlock(button.tag, self.option_optionContents[button.tag]);
    [self _tapGesturePressed];
}

#pragma mark - dealloc

- (void)dealloc {
    self.optionBlock = nil;
}

@end
