//
//  CityPickerView.m
//  LiveWell
//
//  Created by Mark on 2017/6/20.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "CityPickerView.h"

@interface CityPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *cities;
@property (nonatomic, strong) CityOptionBlock optionBlock;

@property (nonnull, strong) UIView *backgroundView;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation CityPickerView

#pragma mark - dealloc

- (void)dealloc {
    self.optionBlock = nil;
    self.datas = nil;
    self.cities = nil;
}

#pragma mark - init

- (instancetype)initWithProvince:(NSString *)province city:(NSString *)city {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.alpha = 0.0f;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        self.province = province;
        self.city = city;
    }
    return self;
}

- (instancetype)setupOption:(CityOptionBlock)block {
    self.optionBlock = block;
    [self loadData];
    [self setupSubViews];
    [self changeDefaultSelect];

    return self;
}

- (void)loadData {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"city" ofType:@"plist"];
    self.datas = [NSMutableArray arrayWithContentsOfFile:path];
    
    self.cities = self.datas[0][@"cities"];
}

- (void)changeDefaultSelect {
    NSInteger count = self.datas.count;
    for (int i=0; i<count; i++) {
        NSString *provinceStr = self.datas[i][@"state"];
        if (![provinceStr isEqualToString:self.province]) {
            continue;
        }
        
        self.cities = self.datas[i][@"cities"];
        NSInteger count1 = self.cities.count;
        int j = 0;
        for (j=0; j<count1; j++) {
            NSString *cityStr = self.cities[j];
            if (![cityStr isEqualToString:self.city]) {
                continue;
            }
            break;
        }
        [self.pickerView selectRow:i inComponent:0 animated:NO];
        [self.pickerView reloadComponent:0];
        [self.pickerView selectRow:j inComponent:1 animated:NO];
        [self.pickerView reloadComponent:1];
        break;
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
    NSString *provinceStr = [self.datas objectAtIndex:row][@"state"];
    NSInteger row1 = [self.pickerView selectedRowInComponent:1];
    NSString *cityStr = [self.cities objectAtIndex:row1];
    self.optionBlock([NSString stringWithFormat:@"%@ %@", provinceStr, cityStr]);
    [self tapGesturePressed];
}

#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.datas.count;
    } else {
        return self.cities.count;
    }
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
    if (component == 0) {
        return [NSString stringWithFormat:@"%@", self.datas[row][@"state"]];
    } else {
        return [NSString stringWithFormat:@"%@", self.cities[row]];
    }
}

//当改变省份时，重新加载第2列的数据，部分加载
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.cities = self.datas[row][@"cities"];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:1];
    }
}

@end
