//
//  VerPasswordViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/21.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "VerPasswordViewController.h"

@interface VerPasswordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *passwordTf;
@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation VerPasswordViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self iniSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initSubViews

- (void)iniSubViews {
    self.navigationItem.title = @"验证密码";
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.frame = CGRectMake(12, 12, ScreenWidth-12, 21);
    hintLabel.text = @"请输入登录密码，以验证身份";
    hintLabel.textColor = RGB(51, 51, 51);
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [hintLabel sizeToFit];
    [self.view addSubview:hintLabel];
    
    _passwordTf = [[UITextField alloc] init];
    _passwordTf.frame = CGRectMake(24, CGRectGetMaxY(hintLabel.frame)+36, ScreenWidth-24*2, 36);
    _passwordTf.backgroundColor = [UIColor clearColor];
    _passwordTf.placeholder = @"密码";
    [_passwordTf setValue:RGB(181, 181, 181) forKeyPath:@"_placeholderLabel.textColor"];
    _passwordTf.borderStyle = UITextBorderStyleNone;
    _passwordTf.keyboardType = UIKeyboardTypeDefault;
    _passwordTf.delegate = self;
    UIView *passwordLine=[[UIView alloc]initWithFrame:CGRectMake(0,_passwordTf.frame.size.height-1, _passwordTf.frame.size.width, 0.6)];
    passwordLine.backgroundColor = RGBA(181, 181, 181, 0.7);
    [_passwordTf addSubview:passwordLine];
    [self.view addSubview:_passwordTf];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(_passwordTf.frame.origin.x, CGRectGetMaxY(_passwordTf.frame)+24, _passwordTf.frame.size.width, 40);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setBackgroundImage:[self createImageWithColor:App_Theme_Color] forState:UIControlStateNormal];
    [_nextBtn setBackgroundImage:[self createImageWithColor:RGBA(239, 239, 239, 1.0)] forState:UIControlStateDisabled];
    [_nextBtn addTarget:self action:@selector(toChangePhoneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    _nextBtn.enabled = NO;
}

- (UIImage*)createImageWithColor:(UIColor*)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - Actions

- (void)toChangePhoneAction {
    
}

@end
