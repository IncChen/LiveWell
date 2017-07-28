//
//  UserDynamicViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/28.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "UserDynamicViewController.h"
#import "CounterfeitNavBarView.h"

static const CGFloat kNavigationBarHeight = 56.f;

@interface UserDynamicViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CounterfeitNavBarView *navBarView;
@property (nonatomic, strong) UIImageView *iconIv;

@end

@implementation UserDynamicViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initSubViews

- (void)initSubViews {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_scrollView];
    _scrollView.clipsToBounds = NO;
    _scrollView.delegate = self;
    
    _navBarView = [[CounterfeitNavBarView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kNavigationBarHeight)];
    _navBarView.titleLab.text = @"";
    _navBarView.titleLab.textColor = [UIColor blackColor];
    _navBarView.titleLab.font = [UIFont systemFontOfSize:15];
    [_navBarView.leftBtn setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    __unsafe_unretained UserDynamicViewController *weakSelf = self;
    _navBarView.leftBtnTapAction = ^() {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [_navBarView.rightBtn setImage:[UIImage imageNamed:@"icon_white_cog"] forState:UIControlStateNormal];
    _navBarView.rightBtnTapAction = ^() {
        
    };
    [self.view addSubview:_navBarView];
    
    _iconIv = [[UIImageView alloc] init];
    _iconIv.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight*20/47.0);
    _iconIv.image = [UIImage imageNamed:@"share_default"];
    [_scrollView addSubview:_iconIv];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetY = scrollView.contentOffset.y;
    
    if (offSetY<=0.f && offSetY>= -80.f) {
        _scrollView.contentOffset = CGPointMake(0, offSetY/2);
    } else if (offSetY < -80.f) {
//        [_tableView setContentOffset:CGPointMake(0, -80.f)];
    } else if (offSetY>0 && offSetY<220.f) {
        _scrollView.contentOffset = CGPointMake(0, offSetY);
    }
    
    if (offSetY <= 0) {
        _navBarView.backgroundView.backgroundColor = RGBA(255, 255, 255, 0.f);
    }else {
        CGFloat alpha = offSetY/(_tableView.tableHeaderView.frame.size.height-56.f);
        if (alpha < 1.0) {
            _navBarView.lineView.hidden = YES;
            _navBarView.titleLab.text = @"";
        } else {
            _navBarView.lineView.hidden = NO;
            _navBarView.titleLab.text = @"昵称";
        }
        _navBarView.backgroundView.backgroundColor = RGBA(255, 255, 255, alpha);
    }
}

@end
