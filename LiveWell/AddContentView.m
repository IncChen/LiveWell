//
//  AddContentView.m
//  LiveWell
//
//  Created by Mark on 2017/7/25.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "AddContentView.h"
#import "ReleaseButton.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AddContentView ()

@property (nonatomic, strong) OptionBlock optionBlock;
@property (nonnull, strong) UIView *backgroundView;

@end

@implementation AddContentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.frame = frame;
        self.alpha = 0.0f;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    }
    return self;
}

- (instancetype)setupOption:(OptionBlock)block {
    self.optionBlock = block;
    [self initSubVeiws];
    return self;
}

- (void)initSubVeiws {
    self.backgroundView = [UIView new];
    self.backgroundView.frame = self.frame;
    [self addSubview:self.backgroundView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGB(0, 206, 181).CGColor, (__bridge id)RGB(0, 196, 181).CGColor, (__bridge id)RGB(9, 181, 184).CGColor];
    gradientLayer.locations = @[@0.0, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(1.0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = self.backgroundView.frame;
    [self.backgroundView.layer addSublayer:gradientLayer];
    
    CGFloat cancelBtnW = 58;
    CGFloat cancelBtnH = cancelBtnW;
    CGFloat cancelBtnX = self.backgroundView.frame.size.width/2.0-cancelBtnW/2.0;
    CGFloat cancelBtnY = self.backgroundView.frame.size.height-cancelBtnH-1;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(cancelBtnX, cancelBtnY, cancelBtnW, cancelBtnH);
    [cancelBtn setImage:[UIImage imageNamed:@"nav_cancel"] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn addTarget:self action:@selector(toCancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:cancelBtn];
    
    CGFloat picBtnW = 72;
    CGFloat picBtnH = picBtnW;
    CGFloat picBtnX = self.backgroundView.frame.size.width/2.0-picBtnW/2.0;
    CGFloat picBtnY = self.backgroundView.frame.size.height/2.0-36;
    ReleaseButton *picBtn = [[ReleaseButton alloc] init];
    picBtn.frame = CGRectMake(picBtnX, picBtnY, picBtnW, picBtnH);
    [picBtn setImage:[UIImage imageNamed:@"icon_release_pic"] forState:UIControlStateNormal];
    [picBtn setTitle:@"发布图片" forState:UIControlStateNormal];
    [picBtn addTarget:self action:@selector(toClickAction:) forControlEvents:UIControlEventTouchUpInside];
    picBtn.tag = 0;
    [self.backgroundView addSubview:picBtn];
    
    CGFloat articleBtnW = picBtnW;
    CGFloat articleBtnH = articleBtnW;
    CGFloat articleBtnX = self.backgroundView.frame.size.width/2.0-articleBtnW/2.0;
    CGFloat articleBtnY = CGRectGetMaxY(picBtn.frame)+48;
    ReleaseButton *articleBtn = [[ReleaseButton alloc] init];
    articleBtn.frame = CGRectMake(articleBtnX, articleBtnY, articleBtnW, articleBtnH);
    [articleBtn setImage:[UIImage imageNamed:@"icon_release_article"] forState:UIControlStateNormal];
    [articleBtn setTitle:@"发布图片" forState:UIControlStateNormal];
    [articleBtn addTarget:self action:@selector(toClickAction:) forControlEvents:UIControlEventTouchUpInside];
    articleBtn.tag = 1;
    [self.backgroundView addSubview:articleBtn];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

#pragma mark - show & dismiss

- (void)show{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Actions

- (void)toCancelAction {
    [self playSoundEffect:@"beep-beep.aiff"];
    [self dismiss];
}

- (void)playSoundEffect:(NSString *)name {
    //获取音效文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    //创建音效文件URL
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    //音效声音的唯一标示ID
    SystemSoundID soundID = 0;
    //将音效加入到系统音效服务中，NSURL需要桥接成CFURLRef，会返回一个长整形ID，用来做音效的唯一标示
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //设置音效播放完成后的回调C语言函数
    AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL,NULL,NULL);
    //开始播放音效
    AudioServicesPlaySystemSound(soundID);
}

- (void)toClickAction:(ReleaseButton *)btn {
    self.optionBlock(btn.tag);
    [self dismiss];
}

@end
