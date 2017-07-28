//
//  SexPickerView.m
//  LiveWell
//
//  Created by Mark on 2017/6/20.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "SexPickerView.h"

@interface SexPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, copy) NSString *sex;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) SexOptionBlock optionBlock;

@property (nonnull, strong) UIView *backgroundView;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation SexPickerView

#pragma mark - dealloc

- (void)dealloc {
    self.optionBlock = nil;
}

#pragma mark - init

- (instancetype)initWithSex:(NSString *)sex {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.alpha = 0.0f;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        self.sex = sex;
        self.options = @[
                         @"男",
                         @"女"
                         ];
    }
    return self;
}

- (instancetype)setupOption:(SexOptionBlock)block {
    self.optionBlock = block;
    [self setupSubViews];
    [self changeDefaultSelect];
    return self;
}

- (void)changeDefaultSelect {
    NSInteger count = self.options.count;
    for (int i = 0; i < count; i++) {
        NSString *str = self.options[i];
        if ([str isEqualToString:self.sex]) {
            [self.pickerView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
}

- (void)setupSubViews {
    self.backgroundView = [UIView new];
    self.backgroundView.frame = CGRectMake(0, self.frame.size.height-224, self.frame.size.width, 224);
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backgroundView];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.frame = CGRectMake(0, 0, self.backgroundView.frame.size.width, 2);
    topLine.backgroundColor = App_Theme_Color;
    [self.backgroundView addSubview:topLine];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.frame = CGRectMake(0, 0, self.backgroundView.frame.size.width, 180);
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.backgroundView addSubview:self.pickerView];
    
    UIView *horizontalLine = [[UIView alloc] init];
    horizontalLine.frame = CGRectMake(0, CGRectGetMaxY(self.pickerView.frame)-1, self.backgroundView.frame.size.width, 1);
    horizontalLine.backgroundColor = RGB(233, 235, 241);
    [self.backgroundView addSubview:horizontalLine];
    
    UIView *verticalLine = [[UIView alloc] init];
    verticalLine.frame = CGRectMake(self.backgroundView.frame.size.width/2.0, CGRectGetMaxY(horizontalLine.frame), 1, 44);
    verticalLine.backgroundColor = RGB(233, 235, 241);
    [self.backgroundView addSubview:verticalLine];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(horizontalLine.frame), self.backgroundView.frame.size.width/2.0, 44);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(181, 181, 181) forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn addTarget:self action:@selector(tapGesturePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(CGRectGetMaxX(verticalLine.frame), cancelBtn.frame.origin.y, self.backgroundView.frame.size.width/2.0, 44);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:App_Theme_Color forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor clearColor];
    [sureBtn addTarget:self action:@selector(toPickerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:sureBtn];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)option_show {
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturePressed)];
        [self addGestureRecognizer:tapGesture];
    }];
}

// 点击消失
- (void)tapGesturePressed {
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

#pragma mark - Actions

- (void)toPickerAction {
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    NSString *sexStr = [self.options objectAtIndex:row];
    self.optionBlock(sexStr);
    [self tapGesturePressed];
}

#pragma mark - UIPickerViewDataSource 

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.options.count;
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.textColor = RGB(51, 51, 51);
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
    }
    
    //调用上一个委托方法，获得要展示的title
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.options[row];
}

@end
