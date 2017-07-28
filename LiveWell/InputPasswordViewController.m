//
//  InputPasswordViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/15.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "InputPasswordViewController.h"
#import "RegexTool.h"
#import "AccountDao.h"
#import "Account.h"
#import "MainViewController.h"

#define kSpacing ScreenWidth*1.5/26.5
#define WhiteHint RGBA(255, 255, 255, 0.6)

@interface InputPasswordViewController ()<UITextFieldDelegate> {
    NSUserDefaults *userDef;
}

@property (nonatomic, strong) UITextField *passwordTf;

@end

@implementation InputPasswordViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark - initSubViews

- (void)initSubViews {
    //设置navigationBar为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.view.backgroundColor = App_Theme_Color;
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStyleDone target:self action:@selector(toBackAction)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    UIBarButtonItem *toDoBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(toDoAction)];
    self.navigationItem.rightBarButtonItem = toDoBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    UILabel *pwdHintLabel = [[UILabel alloc] init];
    pwdHintLabel.frame = CGRectMake(kSpacing, 64+30, 200, 48);
    pwdHintLabel.text = @"设置登录密码";
    pwdHintLabel.textColor = [UIColor whiteColor];
    pwdHintLabel.font = [UIFont systemFontOfSize:26];
    [self.view addSubview:pwdHintLabel];
    
    UILabel *conditionHintLabel = [[UILabel alloc] init];
    conditionHintLabel.frame = CGRectMake(kSpacing, CGRectGetMaxY(pwdHintLabel.frame)+12, ScreenWidth-kSpacing*2, 21);
    conditionHintLabel.text = @"6-30位的英文或数字";
    conditionHintLabel.textColor = RGBA(255, 255, 255, 0.8);
    conditionHintLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:conditionHintLabel];
    
    _passwordTf = [[UITextField alloc] init];
    _passwordTf.frame = CGRectMake(kSpacing, CGRectGetMaxY(conditionHintLabel.frame)+24, ScreenWidth-kSpacing*2, 36);
    _passwordTf.font = [UIFont systemFontOfSize:15];
    _passwordTf.textColor = [UIColor whiteColor];
    _passwordTf.borderStyle = UITextBorderStyleNone;
    _passwordTf.keyboardType = UIKeyboardTypeDefault;
    _passwordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _passwordTf.returnKeyType = UIReturnKeyDone;
    _passwordTf.delegate = self;
    [self.view addSubview:_passwordTf];
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(kSpacing, CGRectGetMaxY(_passwordTf.frame)+8, _passwordTf.frame.size.width, 1);
    line.backgroundColor = WhiteHint;
    [self.view addSubview:line];
}


#pragma mark - Private method

- (void)load  {
    userDef = [NSUserDefaults standardUserDefaults];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name: UITextFieldTextDidChangeNotification object:nil];
}

- (void)unload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void)toBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toDoAction {
    Account *account = [[Account alloc] init];
    account.phone = self.phoneNumber;
    account.password = _passwordTf.text;
    
    [AccountDao insertAccount:account];
    
    [userDef setObject:self.phoneNumber forKey:User_Def_Phone];
    [userDef synchronize];
    MainViewController *viewController = [[MainViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - NSNotification

- (void)textDidChange:(NSNotification*)notification {
    UITextField *tf = (UITextField *)[notification object];
    if (tf.text.length >= 6) {
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
    [_passwordTf resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    BOOL isMatchLength = NO;
    if (newLength > 30) {
        isMatchLength = NO;
    } else {
        isMatchLength = YES;
    }
    
    BOOL isMatchNumber = [RegexTool isNumAndLetterText:string];
    
    return isMatchLength && isMatchNumber;
}

//- (BOOL)textFieldShouldReturn:(UITextField *)tf {
//    [self toDoAction];
//    return NO;
//}

@end
