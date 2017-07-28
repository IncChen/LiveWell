//
//  ComNormsViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/30.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "ComNormsViewController.h"

@interface ComNormsViewController ()

@end

@implementation ComNormsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 64+18, ScreenWidth, 36);
    titleLabel.text = @"好好住社区规范";
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
