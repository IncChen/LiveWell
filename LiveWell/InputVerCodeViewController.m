//
//  InputVerCodeViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/14.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "InputVerCodeViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "JXTAlertManagerHeader.h"
#import "RegexTool.h"
#import "InputPasswordViewController.h"
#import "iToast.h"

#define kSpacing ScreenWidth*1.5/26.5
#define WhiteHint RGBA(255, 255, 255, 0.6)

@interface InputVerCodeViewController ()<UITextFieldDelegate,UNUserNotificationCenterDelegate> {
    int count;
    NSTimer *countdownTimer;
    
    NSString *verCode;
    NSTimer *setupMsgTimer;
}

@property (nonatomic, strong) UITextField *codeTf;
@property (nonatomic, strong) UIButton *codeBtn;

@end

@implementation InputVerCodeViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViews];
    [self toCodeAction];
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
    
    UILabel *codeHintLabel = [[UILabel alloc] init];
    codeHintLabel.frame = CGRectMake(kSpacing, 64+30, 200, 48);
    codeHintLabel.text = @"输入验证码";
    codeHintLabel.textColor = [UIColor whiteColor];
    codeHintLabel.font = [UIFont systemFontOfSize:26];
    [self.view addSubview:codeHintLabel];
    
    NSString *phoneStr = [NSString stringWithFormat:@"我们已向 %@ 发送了验证码", self.phoneNumber];
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.frame = CGRectMake(kSpacing, CGRectGetMaxY(codeHintLabel.frame)+12, ScreenWidth-kSpacing*2, 21);
    phoneLabel.text = phoneStr;
    phoneLabel.textColor = RGBA(255, 255, 255, 0.8);
    phoneLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:phoneLabel];
    
    _codeTf = [[UITextField alloc] init];
    _codeTf.frame = CGRectMake(kSpacing, CGRectGetMaxY(phoneLabel.frame)+24, ScreenWidth-kSpacing*2-60-8, 36);
    _codeTf.font = [UIFont systemFontOfSize:15];
    _codeTf.textColor = [UIColor whiteColor];
    _codeTf.borderStyle = UITextBorderStyleNone;
    _codeTf.keyboardType = UIKeyboardTypeNumberPad;
    _codeTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeTf.returnKeyType = UIReturnKeyDone;
    _codeTf.delegate = self;
    [self.view addSubview:_codeTf];
    
    _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeBtn.frame = CGRectMake(CGRectGetMaxX(_codeTf.frame)+8, _codeTf.frame.origin.y+3, 60, 30);
    [_codeBtn setTitle:@"59" forState:UIControlStateNormal];
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
        NSLog(@"用户关闭了通知功能");
        
        [self jxt_showAlertWithTitle:@"温馨提醒" message:@"请打开通知功能,否则无法收到验证码." appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.
            addActionCancelTitle(@"忽略").
            addActionDestructiveTitle(@"去设置");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if (buttonIndex == 0) {
                NSLog(@"cancel");
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
            // 声音
//            content.sound = [UNNotificationSound soundNamed:@"notification.wav"];
            // 图片
//            NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"msgImg" withExtension:@"png"];
//            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"imageIndetifier" URL:imageUrl options:nil error:nil];
//            content.attachments = @[attachment];
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

/** 当用户处于前台时,消息发送前走这个方法 */
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSLog(@"--------通知即将发出-------");
    // 在前台时,通过此方法监听到消息发出,不让其在通知栏显示,以弹窗的形式展示出来;设置声音提示 UNNotificationPresentationOptionSound
    completionHandler(UNNotificationPresentationOptionAlert);
    
//    // 获取消息内容
//    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
//    [content setObject:notification.request.content.title forKey:@"content"];
//    [content setObject:notification.request.content.body forKey:@"body"];
//    
//    [self jxt_showAlertWithTitle:notification.request.content.title message:notification.request.content.body appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
//        alertMaker.
//        addActionCancelTitle(@"忽略").
//        addActionDestructiveTitle(@"确定");
//    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
//        if (buttonIndex == 0) {
//            NSLog(@"cancel");
//        } else if (buttonIndex == 1) {
//            // 创建通知对象
//            NSNotification *notice = [NSNotification notificationWithName:@"ReadNoticeContent" object:nil userInfo:content];
//            // 发送通知
//            [[NSNotificationCenter defaultCenter] postNotification:notice];
//        }
//    }];
}

/** 不处于前台时,与通知交互走这个方法 */
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
        // 判断为本地通知
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
//        [self jxt_showAlertWithTitle:nil message:@"验证码错误" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
//            alertMaker.toastStyleDuration = 2;
//            [alertMaker setAlertDidShown:^{
//
//            }];
//            alertMaker.alertDidDismiss = ^{
//
//            };
//        } actionsBlock:NULL];
        return;
    }
    InputPasswordViewController *viewController = [[InputPasswordViewController alloc] init];
    viewController.phoneNumber = self.phoneNumber;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)toCodeAction {
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
    // 点击通知查看内容，角标清零,红点消失
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)textDidChange:(NSNotification*)notification {
    UITextField *tf = (UITextField *)[notification object];
    if (tf.text.length == 6) {
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
    [_codeTf resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    BOOL isMatchLength = NO;
    if (newLength > 6) {
        isMatchLength = NO;
    } else {
        isMatchLength = YES;
    }
    
    BOOL isMatchNumber = [RegexTool isNumText:string];
    
    return isMatchLength && isMatchNumber;
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf {
    [self toNextAction];
    return NO;
}

@end
