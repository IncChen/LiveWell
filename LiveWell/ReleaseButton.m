//
//  ReleaseButton.m
//  LiveWell
//
//  Created by Mark on 2017/7/26.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "ReleaseButton.h"

#define RImageHeightPercent 0.8

@implementation ReleaseButton


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self setTitleColor:RGB(116, 116, 116) forState:UIControlStateHighlighted];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * RImageHeightPercent;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat x = 0;
    CGFloat y = contentRect.size.height * RImageHeightPercent;
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height * (1 - RImageHeightPercent);
    
    return CGRectMake(x, y+8, width, height);
}

@end
