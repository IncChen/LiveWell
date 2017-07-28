//
//  AccessoryButton.m
//  LiveWell
//
//  Created by Mark on 2017/7/17.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "AccessoryButton.h"

#define kImageWidthPercent 0.2

@implementation AccessoryButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self setTitleColor:RGB(194, 194, 194) forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageX = contentRect.size.width * (1- kImageWidthPercent);
    CGFloat imageY = 0;
    CGFloat imageW = contentRect.size.width * kImageWidthPercent;
    CGFloat imageH = contentRect.size.height;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width * (1 - kImageWidthPercent);
    CGFloat height = contentRect.size.height;
    
    return CGRectMake(x, y, width, height);
}

@end
