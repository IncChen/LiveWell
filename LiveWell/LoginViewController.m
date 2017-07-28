//
//  LoginViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/9.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterAccountViewController.h"
#import "SearchPwdViewController.h"
#import "MainViewController.h"
#import "iToast.h"
#import "AccountDao.h"
#import "Account.h"


#define kSpacing ScreenWidth*1.5/26.5
#define InfoViewY ScreenHeight*17/47.0
#define WhiteHint RGBA(255, 255, 255, 0.6)


@interface LoginViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    NSUserDefaults *userDef;
}

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *welcomeLabel;
@property (nonatomic, strong) UIButton *countryCodeBtn;
@property (nonatomic, strong) UITextField *phoneTf;
@property (nonatomic, strong) UITextField *passwordTf;
@property (nonatomic, strong) UIButton *forgetPwdBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIView *otherView;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *countryCodes;
@property (nonatomic, strong) NSArray *accounts;

@end

@implementation LoginViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initSubViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData

- (void)initData {
    userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"countryCode" ofType:@"plist"];
    self.countryCodes = [NSArray arrayWithContentsOfFile:path];
    
    self.accounts = [AccountDao queryAccounts];
}

#pragma mark - initViews

- (void)initSubViews {
    //设置navigationBar为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.view.backgroundColor = App_Theme_Color;
    
    UIBarButtonItem *toRegisterViewBtn = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(toRegisterViewAction)];
    self.navigationItem.leftBarButtonItem = toRegisterViewBtn;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    _iconIv = [[UIImageView alloc] init];
    _iconIv.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight*20/47.0);
    _iconIv.image = [UIImage imageNamed:@"share_default"];
    [self.view addSubview:_iconIv];
    
    _infoView = [[UIView alloc] init];
    _infoView.frame = CGRectMake(kSpacing, InfoViewY, ScreenWidth-kSpacing*2, ScreenHeight-InfoViewY);
    _infoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_infoView];
    
    _welcomeLabel = [[UILabel alloc] init];
    _welcomeLabel.frame = CGRectMake(0, 0, 120, 36);
    _welcomeLabel.text = @"欢迎回家";
    _welcomeLabel.textColor = [UIColor whiteColor];
    _welcomeLabel.font = [UIFont systemFontOfSize:24];
    [_infoView addSubview:_welcomeLabel];
    
    CGFloat infoViewW = _infoView.frame.size.width;
    
    _countryCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _countryCodeBtn.frame = CGRectMake(0, 64, 48, 36);
    _countryCodeBtn.backgroundColor = [UIColor clearColor];
    _countryCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _countryCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_countryCodeBtn setTitle:@"+86" forState:UIControlStateNormal];
    [_countryCodeBtn addTarget:self action:@selector(showCountryCodeAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *btnLine=[[UIView alloc]initWithFrame:CGRectMake(0,_countryCodeBtn.frame.size.height-1, _countryCodeBtn.frame.size.width, 0.6)];
    btnLine.backgroundColor = WhiteHint;
    [_countryCodeBtn addSubview:btnLine];
    [_infoView addSubview:_countryCodeBtn];
    
    CGFloat phoneTfX = CGRectGetMaxX(_countryCodeBtn.frame)+10;
    _phoneTf = [[UITextField alloc] init];
    _phoneTf.frame = CGRectMake(phoneTfX, _countryCodeBtn.frame.origin.y, infoViewW-phoneTfX, 36);
    _phoneTf.placeholder = @"手机号码";
    // "通过KVC修改placeholder 占位文字的颜色"
    [_phoneTf setValue:WhiteHint forKeyPath:@"_placeholderLabel.textColor"];
    _phoneTf.font = [UIFont systemFontOfSize:15];
    _phoneTf.textColor = [UIColor whiteColor];
    _phoneTf.borderStyle = UITextBorderStyleNone;
    _phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTf.returnKeyType = UIReturnKeyNext;
    _phoneTf.delegate = self;
    _phoneTf.tag = 101;
    UIView *phoneLine=[[UIView alloc]initWithFrame:CGRectMake(0,_phoneTf.frame.size.height-1, _phoneTf.frame.size.width, 0.6)];
    phoneLine.backgroundColor = [UIColor whiteColor];
    [_phoneTf addSubview:phoneLine];
    [_infoView addSubview:_phoneTf];
    
    _passwordTf = [[UITextField alloc] init];
    _passwordTf.frame = CGRectMake(0, CGRectGetMaxY(_phoneTf.frame)+20, infoViewW-64, 36);
    _passwordTf.placeholder = @"密码";
    [_passwordTf setValue:WhiteHint forKeyPath:@"_placeholderLabel.textColor"];
    _passwordTf.font = [UIFont systemFontOfSize:15];
    _passwordTf.textColor = [UIColor whiteColor];
    _passwordTf.borderStyle = UITextBorderStyleNone;
    _passwordTf.keyboardType = UIKeyboardTypeDefault;
    _passwordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTf.returnKeyType = UIReturnKeyGo;
    _passwordTf.delegate = self;
    _passwordTf.tag = 102;
    UIView *passwordLine=[[UIView alloc]initWithFrame:CGRectMake(0,_passwordTf.frame.size.height-1, _passwordTf.frame.size.width, 0.6)];
    passwordLine.backgroundColor = [UIColor whiteColor];
    [_passwordTf addSubview:passwordLine];
    [_infoView addSubview:_passwordTf];
    //忘记密码 button
    _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgetPwdBtn.frame = CGRectMake(CGRectGetMaxX(_passwordTf.frame), _passwordTf.frame.origin.y, 64, 36);
    _forgetPwdBtn.backgroundColor = [UIColor clearColor];
    _forgetPwdBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPwdBtn addTarget:self action:@selector(forgetPassswordAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *forgetPwdBtnLine=[[UIView alloc]initWithFrame:CGRectMake(0,_forgetPwdBtn.frame.size.height-1, _forgetPwdBtn.frame.size.width, 0.6)];
    forgetPwdBtnLine.backgroundColor=[UIColor whiteColor];
    [_forgetPwdBtn addSubview:forgetPwdBtnLine];
    [_infoView addSubview:_forgetPwdBtn];
    
    //登录 button
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(0, CGRectGetMaxY(_passwordTf.frame)+28, infoViewW, 40);
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTintColor:[UIColor whiteColor]];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_loginBtn setBackgroundColor:[UIColor clearColor]];
    [_loginBtn.layer setCornerRadius:2];
    _loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _loginBtn.layer.borderWidth = 0.6;
    [_loginBtn addTarget:self action:@selector(toLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:_loginBtn];
    
    //第三方登录
    CGFloat otherViewY = CGRectGetMaxY(_loginBtn.frame)+36;
    _otherView = [[UIView alloc] init];
    _otherView.frame = CGRectMake(0, otherViewY, infoViewW, _infoView.frame.size.height-otherViewY);
    _otherView.backgroundColor = [UIColor clearColor];
    [_infoView addSubview:_otherView];
    
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
    
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.frame = CGRectMake(0, ScreenHeight-180, ScreenWidth, 180);
    _pickerView.backgroundColor = App_Theme_Color;
    [self.view addSubview:_pickerView];
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.hidden = YES;
}

//- (void)setNavigationBarType {
//    self.navigationController.navigationBar.translucent = YES;
//    UIColor *color = [UIColor clearColor];//RGBA(0, 0, 0, 0);//全透明
//    CGRect rect = CGRectMake(0, 0, ScreenWidth, 64);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.clipsToBounds = YES;
//}

#pragma mark - Actions

- (void)toRegisterViewAction {
    RegisterAccountViewController *viewController = [[RegisterAccountViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showCountryCodeAction {
    [_phoneTf resignFirstResponder];
    [_passwordTf resignFirstResponder];
    
    _pickerView.hidden = !_pickerView.hidden;
    
    CGFloat infoViewY = InfoViewY;
    if (_pickerView.hidden == NO) {
        infoViewY = ScreenHeight*12/47.0;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.infoView.frame = CGRectMake(self.infoView.frame.origin.x,
                                     infoViewY,
                                     self.infoView.frame.size.width,
                                     self.infoView.frame.size.height);
    [UIView commitAnimations];
}

- (void)forgetPassswordAction {
    SearchPwdViewController *viewController = [[SearchPwdViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)toLoginAction {
    NSString *phone = _phoneTf.text;
    if ([phone isEqual:[NSNull null]] || phone == nil || phone.length == 0) {
        [[iToast makeText:@"请输入手机号码"] show];
        return;
    }
    NSString *password = _passwordTf.text;
    if ([password isEqual:[NSNull null]] || password == nil || password.length == 0) {
        [[iToast makeText:@"请输入密码"] show];
        return;
    }
    BOOL isExist = NO;
    Account *ac = [[Account alloc] init];
    for (Account *account in self.accounts) {
        isExist = NO;
        if ([account.phone isEqualToString:phone]) {
            isExist = YES;
            ac = account;
            break;
        }
    }
    if (!isExist) {
        [[iToast makeText:@"该手机号码未注册"] show];
        return;
    }
    if (![ac.password isEqualToString:password]) {
        [[iToast makeText:@"密码错误，请重新输入"] show];
        return;
    }
    [userDef setObject:phone forKey:User_Def_Phone];
    [userDef synchronize];
    [self toMainViewController];
}

- (void)toMainViewController {
    MainViewController *viewController = [[MainViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)toWechatLoginAction {
    
}

- (void)toWeiboLoginAction {
    
}

#pragma mark - touchesBegan

//点击屏幕空白处调用此函数
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //使虚拟键盘回收，不再做为第一消息响应者
    [_phoneTf resignFirstResponder];
    [_passwordTf resignFirstResponder];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.infoView.frame = CGRectMake(self.infoView.frame.origin.x,
                                 InfoViewY,
                                 self.infoView.frame.size.width,
                                 self.infoView.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)tf {
    NSInteger tag = tf.tag;
    if (tag == 101) {
        [_passwordTf becomeFirstResponder];
    } else if (tag == 102) {
        [self toLoginAction];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)tf {
    _pickerView.hidden = YES;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.infoView.frame = CGRectMake(self.infoView.frame.origin.x,
                                     ScreenHeight*6/47.0,
                                     self.infoView.frame.size.width,
                                     self.infoView.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - UIPickerViewDataSource

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = self.countryCodes.count;
            break;
        case 1:
            result = 1;
            break;
        default:
            break;
    }
    
    return result;
}

#pragma mark - UIPickerViewDelegate

//pickerview设置字体大小和颜色等
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    for(UIView *speartorView in pickerView.subviews) {
        //取出分割线view
        if (speartorView.frame.size.height < 1) {
            speartorView.backgroundColor = [UIColor whiteColor];
        }
    }
    
    //可以通过自定义label达到自定义pickerview展示数据的方式
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.textColor = [UIColor whiteColor];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    //调用上一个委托方法，获得要展示的title
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = nil;
    switch (component) {
        case 0:
            title = self.countryCodes[row][@"Country"];
            break;
        case 1:
            title = self.countryCodes[row][@"Number"];
            break;
        default:
            break;
    }
    
    return title;
}

//选中时回调的委托方法
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0: {
            NSString *number = self.countryCodes[row][@"Number"];
            
            UILabel *labelSelected = (UILabel*)[pickerView viewForRow:0 forComponent:1];
            labelSelected.text = number;
            
            [_countryCodeBtn setTitle:number forState:UIControlStateNormal];
        }   break;
        case 1:

            break;
        default:
            break;
    }
}

@end
