//
//  UserNameViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/19.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "UserNameViewController.h"

#define Text_Color RGB(51, 51, 51)

@interface UserNameViewController ()

@property (nonatomic, strong) UITextField *nameTf;

@end

@implementation UserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initSubVeiws

- (void)initSubViews {
    self.navigationItem.title = @"修改昵称";
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(toCancelAction)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    self.navigationItem.leftBarButtonItem.tintColor = Text_Color;
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], UITextAttributeFont, Text_Color, UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(toCancelAction)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    self.navigationItem.rightBarButtonItem.tintColor = Text_Color;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], UITextAttributeFont, Text_Color, UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    _nameTf = [[UITextField alloc] init];
    _nameTf.frame = CGRectMake(12, 64+8, ScreenWidth-12*2, 32);
    _nameTf.text = self.name;
    _nameTf.textColor = Text_Color;
    _nameTf.font = [UIFont systemFontOfSize:14];
    _nameTf.borderStyle = UITextBorderStyleNone;
    UIView *nameLine=[[UIView alloc]initWithFrame:CGRectMake(0,_nameTf.frame.size.height-1, _nameTf.frame.size.width, 0.6)];
    nameLine.backgroundColor = RGB(181, 181, 181);
    [_nameTf addSubview:nameLine];
    [self.view addSubview:_nameTf];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(_nameTf.frame.origin.x, CGRectGetMaxY(_nameTf.frame)+4, _nameTf.frame.size.width, 16);
    label.text = @"昵称可以是中文，数字的任意组合，30天内只能修改一次哦。";
    label.textColor = RGB(181, 181, 181);
    label.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:label];
}

#pragma mark - Actions

- (void)toCancelAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
