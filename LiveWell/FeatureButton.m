//
//  FeatureButton.m
//  LiveWell
//
//  Created by Mark on 2017/7/11.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "FeatureButton.h"

#define kImageWidthPercent 0.5

@implementation FeatureButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.font = [UIFont systemFontOfSize:8.0f];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self setTitleColor:RGB(117, 117, 117) forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = contentRect.size.width * kImageWidthPercent;
    CGFloat imageH = contentRect.size.height;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat x = contentRect.size.width * kImageWidthPercent;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width * (1 - kImageWidthPercent);
    CGFloat height = contentRect.size.height * kImageWidthPercent;
    
    return CGRectMake(x, y, width, height);
}

@end
