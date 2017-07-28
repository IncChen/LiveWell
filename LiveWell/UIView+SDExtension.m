//
//  UIView+SDExtension.m
//  LiveWell
//
//  Created by Mark on 2017/6/29.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "UIView+SDExtension.h"

@implementation UIView (SDExtension)

- (CGFloat)sd_height
{
    return self.frame.size.height;
}

- (void)setSd_height:(CGFloat)sd_height
{
    CGRect temp = self.frame;
    temp.size.height = sd_height;
    self.frame = temp;
}

- (CGFloat)sd_width
{
    return self.frame.size.width;
}

- (void)setSd_width:(CGFloat)sd_width
{
    CGRect temp = self.frame;
    temp.size.width = sd_width;
    self.frame = temp;
}


- (CGFloat)sd_y
{
    return self.frame.origin.y;
}

- (void)setSd_y:(CGFloat)sd_y
{
    CGRect temp = self.frame;
    temp.origin.y = sd_y;
    self.frame = temp;
}

- (CGFloat)sd_x
{
    return self.frame.origin.x;
}

- (void)setSd_x:(CGFloat)sd_x
{
    CGRect temp = self.frame;
    temp.origin.x = sd_x;
    self.frame = temp;
}

- (void)setSd_centerX:(CGFloat)sd_centerX {
    CGPoint center = self.center;
    center.x = sd_centerX;
    self.center = center;
}

- (CGFloat)sd_centerX {
    return self.center.x;
}

@end
