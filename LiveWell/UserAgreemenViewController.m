//
//  UserAgreemenViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/14.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "UserAgreemenViewController.h"

@interface UserAgreemenViewController ()

@end

@implementation UserAgreemenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initSubViews

- (void)initSubViews {
    self.navigationItem.title = @"用户协议";
    
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStyleDone target:self action:@selector(toBackAction)];
//    self.navigationItem.leftBarButtonItem = backBtn;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 64+18, ScreenWidth, 36);
    titleLabel.text = @"好好住服务使用协议";
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}

//#pragma mark - Actions
//
//- (void)toBackAction {
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end
