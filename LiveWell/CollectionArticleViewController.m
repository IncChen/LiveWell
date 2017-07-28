//
//  CollectionArticleViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/28.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "CollectionArticleViewController.h"

@interface CollectionArticleViewController ()

@end

@implementation CollectionArticleViewController

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
    titleLabel.text = @"收藏的文章";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    //detail
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 100, 16)];
    detailLabel.text = @"0篇";
    detailLabel.textColor = [UIColor lightGrayColor];
    detailLabel.font = [UIFont systemFontOfSize:10];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:detailLabel];
}

@end
