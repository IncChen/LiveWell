//
//  ArticleDraftViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/28.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "ArticleDraftViewController.h"

@interface ArticleDraftViewController ()

@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation ArticleDraftViewController

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
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleView;
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 100, 18)];
    titleLabel.text = @"文章草稿";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    //detail
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 100, 16)];
    _detailLabel.text = @"0篇";
    _detailLabel.textColor = [UIColor lightGrayColor];
    _detailLabel.font = [UIFont systemFontOfSize:10];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:_detailLabel];
}

@end
