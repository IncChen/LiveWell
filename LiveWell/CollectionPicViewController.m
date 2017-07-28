//
//  CollectionPicViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/28.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "CollectionPicViewController.h"

@interface CollectionPicViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CollectionPicViewController

#pragma mark - Life cycle

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
    self.navigationItem.title = @"收藏的图片";
    
//    _tableView = [[UITableView alloc] init];
//    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    _tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
//    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
//    [self.view addSubview:_tableView];
}

@end
