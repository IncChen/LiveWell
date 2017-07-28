//
//  SearchPwdViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/15.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "SearchPwdViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "JXTAlertManagerHeader.h"
#import "RegexTool.h"
#import "iToast.h"
#import "AccountDao.h"
#import "Account.h"
#import "ResetPasswordViewController.h"

#define kSpacing ScreenWidth*1.5/26.5
#define WhiteHint RGBA(255, 255, 255, 0.6)

@interface SearchPwdViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UNUserNotificationCenterDelegate> {
    int count;
    NSTimer *countdownTimer;
    
    NSString *verCode;
    NSTimer *setupMsgTimer;
}

@property (nonatomic, strong) UIButton *countryCodeBtn;
@property (nonatomic, strong) UITextField *phoneTf;
@property (nonatomic, strong) UITextField *codeTf;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *countryCodes;
@property (nonatomic, strong) NSArray *accounts;

@end

@implementation SearchPwdViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initSubViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self load];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self unload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData

- (void)initData {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"countryCode" ofType:@"plist"];
    self.countryCodes = [NSArray arrayWithContentsOfFile:path];
    
    self.accounts = [AccountDao queryAccounts];
}

#pragma mark - initSubViews

- (void)initSubViews {
    //设置navigationBar为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.view.backgroundColor = App_Theme_Color;
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStyleDone target:self action:@selector(toBackAction)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    UIBarButtonItem *toNextBtn = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(toNextAction)];
    self.navigationItem.rightBarButtonItem = toNextBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.frame = CGRectMake(kSpacing, 64+30, 200, 48);
    hintLabel.text = @"找回密码";
    hintLabel.textColor = [UIColor whiteColor];
    hintLabel.font = [UIFont systemFontOfSize:26];
    [self.view addSubview:hintLabel];
    
    _countryCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _countryCodeBtn.frame = CGRectMake(kSpacing, CGRectGetMaxY(hintLabel.frame)+60, 48, 36);
    _countryCodeBtn.backgroundColor = [UIColor clearColor];
    _countryCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _countryCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_countryCodeBtn setTitle:@"+86" forState:UIControlStateNormal];
    [_countryCodeBtn addTarget:self action:@selector(showCountryCodeAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *btnLine=[[UIView alloc]initWithFrame:CGRectMake(0,_countryCodeBtn.frame.size.height-1, _countryCodeBtn.frame.size.width, 0.6)];
    btnLine.backgroundColor = WhiteHint;
    [_countryCodeBtn addSubview:btnLine];
    [self.view addSubview:_countryCodeBtn];
    
    CGFloat phoneTfX = CGRectGetMaxX(_countryCodeBtn.frame)+8;
    _phoneTf = [[UITextField alloc] init];
    _phoneTf.frame = CGRectMake(phoneTfX, _countryCodeBtn.frame.origin.y, ScreenWidth-phoneTfX-kSpacing, 36);
    _phoneTf.font = [UIFont systemFontOfSize:15];
    _phoneTf.textColor = [UIColor whiteColor];
    _phoneTf.placeholder = @"手机号码";
    [_phoneTf setValue:WhiteHint forKeyPath:@"_placeholderLabel.textColor"];
    _phoneTf.borderStyle = UITextBorderStyleNone;
    _phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTf.returnKeyType = UIReturnKeyDone;
    _phoneTf.delegate = self;
    UIView *phoneLine=[[UIView alloc]initWithFrame:CGRectMake(0,_phoneTf.frame.size.height-1, _phoneTf.frame.size.width, 0.6)];
    phoneLine.backgroundColor = WhiteHint;
    [_phoneTf addSubview:phoneLine];
    [self.view addSubview:_phoneTf];
    
    [_phoneTf becomeFirstResponder];
    
    _codeTf = [[UITextField alloc] init];
    _codeTf.frame = CGRectMake(kSpacing, CGRectGetMaxY(_phoneTf.frame)+20, ScreenWidth-kSpacing*2-60-8, 36);
    _codeTf.font = [UIFont systemFontOfSize:15];
    _codeTf.textColor = [UIColor whiteColor];
    _codeTf.placeholder = @"验证码";
    [_codeTf setValue:WhiteHint forKeyPath:@"_placeholderLabel.textColor"];
    _codeTf.borderStyle = UITextBorderStyleNone;
    _codeTf.keyboardType = UIKeyboardTypeNumberPad;
    _codeTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeTf.returnKeyType = UIReturnKeyDone;
    _codeTf.delegate = self;
    [self.view addSubview:_codeTf];
    
    _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeBtn.frame = CGRectMake(CGRectGetMaxX(_codeTf.frame)+8, _codeTf.frame.origin.y+3, 60, 30);
    [_codeBtn setTitle:@"点击获取" forState:UIControlStateNormal];
    [_codeBtn setTitleColor:App_Theme_Color forState:UIControlStateNormal];
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_codeBtn setBackgroundColor:RGBA(255, 255, 255, 0.4)];
    [_codeBtn.layer setCornerRadius:4];
    [_codeBtn addTarget:self action:@selector(toCodeAction) forControlEvents:UIControlEventTouchUpInside];
    _codeBtn.enabled = NO;
    [self.view addSubview:_codeBtn];
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(kSpacing, CGRectGetMaxY(_codeTf.frame)+8, ScreenWidth-kSpacing*2, 1);
    line.backgroundColor = WhiteHint;
    [self.view addSubview:line];
}


#pragma mark - Private method

- (void)load  {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name: UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmReadNoticeContent:) name:@"ReadNoticeContent" object:nil];
}

- (void)unload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changeCount {
    if (count == 0) {
        if (countdownTimer != nil) {
            [countdownTimer invalidate];
            countdownTimer = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _codeBtn.enabled = YES;
            [_codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            [_codeBtn setBackgroundColor:RGBA(255, 255, 255, 1.0)];
        });
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_codeBtn setTitle:[NSString stringWithFormat:@"%d",count--] forState:UIControlStateNormal];
    });
}

// 检查用户对通知功能的设置状态
- (BOOL)isPermissionedPushNotification {
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
        
        [self jxt_showAlertWithTitle:@"温馨提醒" message:@"请打开通知功能,否则无法收到验证码." appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.
            addActionCancelTitle(@"忽略").
            addActionDestructiveTitle(@"去设置");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if (buttonIndex == 0) {
                //Cancel
            } else if (buttonIndex == 1) {
                // 点击跳转至设置中心
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }];
        
        return false;
    } else {
        NSLog(@"可以进行推送");
        return true;
    }
}

- (void)setupUnreadTradeMsg {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        // 生成 "000000-999999" 6位验证码
        int num = (arc4random() % 1000000);
        NSString *randomNumber = [NSString stringWithFormat:@"%.6d", num];
        verCode = randomNumber;
        NSString *title = @"1069092029210";
        NSString *content = [NSString stringWithFormat:@"【好好住】你的验证码是：%@，2分钟内有效。如非你本人操作，可忽悠本消息。", randomNumber];
        
        [params setObject:title forKey:@"title"];
        [params setObject:content forKey:@"content"];
        NSLog(@"randomNumber:%@",randomNumber);
        // 发起推送
        [self pushNotificationOfTradeMsg:params];
    });
}

// 配置推送内容
- (void)pushNotificationOfTradeMsg:(NSDictionary *)params {
    // 1、创建通知对象
    UNUserNotificationCenter *center  = [UNUserNotificationCenter currentNotificationCenter];
    // 必须设置代理，否则无法收到通知
    center.delegate = self;
    // 权限
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            // 2、创建通知内容
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            // 标题
            content.title = params[@"title"];
            content.body = params[@"content"];

            // 标识符
            content.categoryIdentifier = @"categoryIndentifier";
            
            // 3、创建通知触发时间
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.0 repeats:NO];
            // 4、创建通知请求
            UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"KFGroupNotification" content:content trigger:trigger];
            // 5、将请求加入通知中心
            [center addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"已成功加入通知请求");
                } else {
                    NSLog(@"出错啦%@", [error localizedDescription]);
                }
            }];
        } else {
            NSLog(@"无权限");
        }
    }];
}

#pragma mark - UNUserNotificationCenterDelegate

//当用户处于前台时,消息发送前走这个方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSLog(@"--------通知即将发出-------");

    completionHandler(UNNotificationPresentationOptionAlert);
}

//不处于前台时,与通知交互走这个方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    completionHandler(UIBackgroundFetchResultNewData);
    // 获取消息内容
    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
    [content setObject:response.notification.request.content.title forKey:@"content"];
    [content setObject:response.notification.request.content.body forKey:@"body"];
    
    // 判断是否为本地通知
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"收到远程通知");
    } else {
        //判断为本地通知
        //创建通知对象
        NSNotification *notice = [NSNotification notificationWithName:@"ReadNoticeContent" object:nil userInfo:content];
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notice];
    }
}

#pragma mark - Actions

- (void)toBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toNextAction {
    if (![_codeTf.text isEqualToString:verCode]) {
        self.view.backgroundColor = UIColorFromRGB(0xff4149);
        [[iToast makeText:@"验证码错误"] show];
        return;
    }
    
    ResetPasswordViewController *viewController = [[ResetPasswordViewController alloc] init];
    viewController.phoneNumber = _phoneTf.text;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showCountryCodeAction {
    [_phoneTf resignFirstResponder];
    
    _pickerView.hidden = !_pickerView.hidden;
}

- (void)toCodeAction {
    NSString *phone = _phoneTf.text;
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
    
    if ([self isPermissionedPushNotification]) {
        _codeBtn.enabled = NO;
        [_codeBtn setBackgroundColor:RGBA(255, 255, 255, 0.4)];
        count = 59;
        countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeCount) userInfo:nil repeats:YES];
        
        setupMsgTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(setupUnreadTradeMsg) userInfo:nil repeats:NO];
    }
}

#pragma mark - NSNotification

- (void)confirmReadNoticeContent:(NSDictionary *)content {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)textDidChange:(NSNotification*)notification {
    if (_phoneTf.text.length > 0) {
        _codeBtn.enabled = YES;
    } else {
        _codeBtn.enabled = NO;
    }
    if (_phoneTf.text.length > 0 && _codeTf.text.length == 6) {
        if (self.navigationItem.rightBarButtonItem.isEnabled == NO) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    } else {
        if (self.navigationItem.rightBarButtonItem.isEnabled == YES) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
}

#pragma mark - touchesBegan

//点击屏幕空白处调用此函数
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_phoneTf resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)tf {
    [self toNextAction];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)tf {
    if (_pickerView.isHidden != YES) {
        _pickerView.hidden = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [RegexTool isNumText:string];
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
