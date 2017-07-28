//
//  HappeningViewController.m
//  LiveWell
//
//  Created by Mark on 2017/7/20.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "HappeningViewController.h"

@interface HappeningViewController ()

@end

@implementation HappeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 100, ScreenWidth, 21);
    label.text = @"这页不(ˇˍˇ) 想～写了";
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}


@end
