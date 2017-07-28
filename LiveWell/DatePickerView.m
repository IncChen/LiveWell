//
//  DatePickerView.m
//  LiveWell
//
//  Created by Mark on 2017/6/21.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView ()

@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, strong) DateOptionBlock optionBlock;

@property (nonnull, strong) UIView *backgroundView;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation DatePickerView

#pragma mark - dealloc

- (void)dealloc {
    self.optionBlock = nil;
}

#pragma mark - init

- (instancetype)initWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.alpha = 0.0f;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        self.year = year;
        self.month = month;
        self.day = day;
    }
    return self;
}

- (instancetype)setupOption:(DateOptionBlock)block {
    self.optionBlock = block;
    [self setupSubViews];
    [self changeDefaultSelect];
    return self;
}

- (void)changeDefaultSelect {
    NSString *lastTime = [NSString stringWithFormat:@"%@-%@-%@", self.year,self.month,self.day];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:lastTime];
    if (!lastTime) {
        date = [NSDate date];
    }
    
    [self.datePicker setDate:date];
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
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.frame = CGRectMake(0, 0, self.backgroundView.frame.size.width, 180);
    self.datePicker.backgroundColor = [UIColor clearColor];
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.backgroundView addSubview:self.datePicker];
    
    UIView *horizontalLine = [[UIView alloc] init];
    horizontalLine.frame = CGRectMake(0, CGRectGetMaxY(self.datePicker.frame)-1, self.backgroundView.frame.size.width, 1);
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
    NSDate *date = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [[NSString alloc]init];
    string = [dateFormatter stringFromDate:date];
    self.optionBlock(string);
    [self tapGesturePressed];
}

@end
