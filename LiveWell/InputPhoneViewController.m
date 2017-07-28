//
//  InputPhoneViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/14.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "InputPhoneViewController.h"
#import "JXTAlertManagerHeader.h"
#import "InputVerCodeViewController.h"
#import "RegexTool.h"

#define kSpacing ScreenWidth*1.5/26.5
#define WhiteHint RGBA(255, 255, 255, 0.6)

@interface InputPhoneViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIButton *countryCodeBtn;
@property (nonatomic, strong) UITextField *phoneTf;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *countryCodes;

@end

@implementation InputPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initSubVeiws];
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
}

#pragma mark - InitSubViews

- (void)initSubVeiws {
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
    
    UILabel *phoneHintLabel = [[UILabel alloc] init];
    phoneHintLabel.frame = CGRectMake(kSpacing, 64+30, 200, 48);
    phoneHintLabel.text = @"你的手机号码";
    phoneHintLabel.textColor = [UIColor whiteColor];
    phoneHintLabel.font = [UIFont systemFontOfSize:26];
    [self.view addSubview:phoneHintLabel];
    
    _countryCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _countryCodeBtn.frame = CGRectMake(kSpacing, CGRectGetMaxY(phoneHintLabel.frame)+60, 48, 36);
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
    _phoneTf.placeholder = @"手机号码";
    [_phoneTf setValue:WhiteHint forKeyPath:@"_placeholderLabel.textColor"];
    _phoneTf.font = [UIFont systemFontOfSize:15];
    _phoneTf.textColor = [UIColor whiteColor];
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
    
    UIButton *problemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    problemBtn.frame = CGRectMake(ScreenWidth-74-kSpacing, CGRectGetMaxY(_phoneTf.frame)+16, 74, 21);
    problemBtn.backgroundColor = [UIColor clearColor];
    [problemBtn setTitle:@"遇到问题？" forState:UIControlStateNormal];
    problemBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    problemBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [problemBtn.titleLabel sizeToFit];
    [problemBtn addTarget:self action:@selector(toProblemAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:problemBtn];
    
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.frame = CGRectMake(0, ScreenHeight-180, ScreenWidth, 180);
    _pickerView.backgroundColor = App_Theme_Color;
    [self.view addSubview:_pickerView];
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.hidden = YES;
}

#pragma mark - Private method

- (void)load  {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name: UITextFieldTextDidChangeNotification object:nil];
}

- (void)unload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void)toBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toNextAction {
    NSString *phoneNumber = _phoneTf.text;
    InputVerCodeViewController *viewController = [[InputVerCodeViewController alloc] init];
    viewController.phoneNumber = phoneNumber;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)toProblemAction {
    [self jxt_showAlertWithTitle:@"联系我们" message:@"发送邮件至\nhello@fanghaohaozhu.com" appearanceProcess:^(JXTAlertController *_Nonnull alertMaker) {
        alertMaker.
        addActionDestructiveTitle(@"好");
    }actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        [_phoneTf becomeFirstResponder];
    }];
}

- (void)showCountryCodeAction {
    [_phoneTf resignFirstResponder];
    
    _pickerView.hidden = !_pickerView.hidden;
}

#pragma mark - NSNotification

- (void)textDidChange:(NSNotification*)notification {
    UITextField *tf = (UITextField *)[notification object];
    if (tf.text.length > 0) {
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
