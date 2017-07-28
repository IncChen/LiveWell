//
//  RegisterAccountViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/14.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "RegisterAccountViewController.h"
#import "UserAgreemenViewController.h"
#import "InputPhoneViewController.h"

#define kSpacing ScreenWidth*1.5/26.5
#define WhiteHint RGBA(255, 255, 255, 0.6)

@interface RegisterAccountViewController ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIView *otherView;

@end

@implementation RegisterAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initViews

- (void)initSubViews {
    //设置navigationBar为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.view.backgroundColor = App_Theme_Color;
    
    UIBarButtonItem *toLoginViewBtn = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(toLoginViewAction)];
    self.navigationItem.leftBarButtonItem = toLoginViewBtn;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    _iconIv = [[UIImageView alloc] init];
    _iconIv.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight*20/47.0);
    _iconIv.image = [UIImage imageNamed:@"share_default"];
    [self.view addSubview:_iconIv];
    
    UILabel *welcomeLabel = [[UILabel alloc] init];
    welcomeLabel.frame = CGRectMake(kSpacing, CGRectGetMaxY(_iconIv.frame), 120, 36);
    welcomeLabel.text = @"欢迎入住";
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:welcomeLabel];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerBtn.frame = CGRectMake(kSpacing, CGRectGetMaxY(welcomeLabel.frame)+64, ScreenWidth-kSpacing*2, 40);
    [_registerBtn setTitle:@"创建帐号" forState:UIControlStateNormal];
    [_registerBtn setTintColor:[UIColor whiteColor]];
    _registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_registerBtn setBackgroundColor:[UIColor clearColor]];
    [_registerBtn.layer setCornerRadius:2];
    _registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _registerBtn.layer.borderWidth = 0.6;
    [_registerBtn addTarget:self action:@selector(toRegiseterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    UILabel *userHintLabel = [[UILabel alloc] init];
    userHintLabel.frame = CGRectMake(ScreenWidth/2.0-100+12, CGRectGetMaxY(_registerBtn.frame)+24, 100, 21);
    userHintLabel.text = @"我已阅读并同意";
    userHintLabel.textColor = WhiteHint;
    userHintLabel.font = [UIFont systemFontOfSize:12];
    userHintLabel.textAlignment = NSTextAlignmentRight;
    [userHintLabel sizeToFit];
    [self.view addSubview:userHintLabel];
    
    UIButton *userAgreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userAgreementBtn.frame = CGRectMake(CGRectGetMaxX(userHintLabel.frame)+4, userHintLabel.frame.origin.y-4, 56, 21);
    userAgreementBtn.backgroundColor = [UIColor clearColor];
    userAgreementBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    userAgreementBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [userAgreementBtn setTitleColor:WhiteHint forState:UIControlStateNormal];
    [userAgreementBtn setTitle:@"用户协议" forState:UIControlStateNormal];
    [userAgreementBtn addTarget:self action:@selector(toUserAgreementAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *btnLine=[[UIView alloc]initWithFrame:CGRectMake(0,userAgreementBtn.frame.size.height-1, userAgreementBtn.frame.size.width, 0.6)];
    btnLine.backgroundColor = WhiteHint;
    [userAgreementBtn addSubview:btnLine];
    [self.view addSubview:userAgreementBtn];
    
    //第三方登录
    CGFloat otherViewY = CGRectGetMaxY(userHintLabel.frame)+48;
    _otherView = [[UIView alloc] init];
    _otherView.frame = CGRectMake(kSpacing, otherViewY, ScreenWidth-kSpacing*2, ScreenHeight-otherViewY);
    _otherView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_otherView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _otherView.frame.size.width, 0.6)];
    line.backgroundColor = WhiteHint;
    [_otherView addSubview:line];
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.frame = CGRectMake(40, CGRectGetMaxY(line.frame)+12, _otherView.frame.size.width-40*2, 21);
    hintLabel.text = @"使用第三方账号登录";
    hintLabel.textColor = WhiteHint;
    hintLabel.font = [UIFont systemFontOfSize:12];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [_otherView addSubview:hintLabel];
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(_otherView.frame.size.width/2.0-1, CGRectGetMaxY(hintLabel.frame)+30, 0.6, 16)];
    verticalLine.backgroundColor = [UIColor whiteColor];
    [_otherView addSubview:verticalLine];
    
    CGFloat wechatBtnW = 36;
    CGFloat wechatBtnH = wechatBtnW;
    UIButton *wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatBtn.frame = CGRectMake(verticalLine.frame.origin.x-wechatBtnW-24, verticalLine.frame.origin.y-12, wechatBtnW, wechatBtnH);
    [wechatBtn setImage:[UIImage imageNamed:@"icon_share_wechat"] forState:UIControlStateNormal];
    [wechatBtn setBackgroundColor:[UIColor clearColor]];
    [wechatBtn addTarget:self action:@selector(toWechatLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [_otherView addSubview:wechatBtn];
    
    CGFloat weiboBtnW = wechatBtnW;
    CGFloat weiboBtnH = weiboBtnW;
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(verticalLine.frame.origin.x+24, verticalLine.frame.origin.y-12, weiboBtnW, weiboBtnH);
    [weiboBtn setImage:[UIImage imageNamed:@"icon_share_weibo"] forState:UIControlStateNormal];
    [weiboBtn setBackgroundColor:[UIColor clearColor]];
    [weiboBtn addTarget:self action:@selector(toWeiboLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [_otherView addSubview:weiboBtn];
}

- (void)setNavigationBarType {
    self.navigationController.navigationBar.translucent = YES;
    UIColor *color = [UIColor clearColor];//RGBA(0, 0, 0, 0);//全透明
    CGRect rect = CGRectMake(0, 0, ScreenWidth, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.clipsToBounds = YES;
}

#pragma mark - Actions

- (void)toLoginViewAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toRegiseterAction {
    InputPhoneViewController *viewController = [[InputPhoneViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)toUserAgreementAction {
    UserAgreemenViewController *viewController = [[UserAgreemenViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)toWechatLoginAction {
    
}

- (void)toWeiboLoginAction {
    
}

@end
