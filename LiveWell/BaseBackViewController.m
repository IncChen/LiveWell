//
//  BaseBackViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/19.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "BaseBackViewController.h"

@interface BaseBackViewController ()

@end

@implementation BaseBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStyleDone target:self action:@selector(toBackAction)];
    self.navigationItem.leftBarButtonItem = backBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
