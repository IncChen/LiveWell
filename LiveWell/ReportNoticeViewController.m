//
//  ReportNoticeViewController.m
//  LiveWell
//
//  Created by Mark on 2017/7/14.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "ReportNoticeViewController.h"

@interface ReportNoticeViewController ()

@end

@implementation ReportNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"举报须知";
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 64+18, ScreenWidth, 36);
    titleLabel.text = @"举报须知";
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
