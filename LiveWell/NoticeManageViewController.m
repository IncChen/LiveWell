//
//  NoticeManageViewController.m
//  LiveWell
//
//  Created by Mark on 2017/7/20.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "NoticeManageViewController.h"
#import "NewsSettingViewController.h"
#import "HappeningViewController.h"
#import "MyNoticeViewController.h"
#import "LevyViewController.h"
#import "UIView+SDExtension.h"

@interface NoticeManageViewController ()<UIScrollViewDelegate>

/** 标签栏底部的红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 顶部的所有标签 */
@property (nonatomic, weak) UIView *titlesView;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation NoticeManageViewController

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
    self.navigationItem.title = @"消息";
    
    UIBarButtonItem *settingBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_setting_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStyleDone target:self action:@selector(toSettingAction)];
    self.navigationItem.rightBarButtonItem = settingBtn;
    
    [self setupChildController];
    [self setupTitlesView];
    [self setupContentView];
}

#pragma mark - 初始化子控制器
- (void)setupChildController {
    HappeningViewController *heppen = [[HappeningViewController alloc] init];
    heppen.title = @"正在发生";
    [self addChildViewController:heppen];
    
    MyNoticeViewController *mynotice = [[MyNoticeViewController alloc] init];
    mynotice.title = @"关于我";
    [self addChildViewController:mynotice];
    
    LevyViewController *levy = [[LevyViewController alloc] init];
    levy.title = @"通知";
    [self addChildViewController:levy];
}

/**
 设置顶部的标签栏
 */
- (void)setupTitlesView {
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    titlesView.sd_width = self.view.sd_width;
    titlesView.sd_height = 40.0;
    titlesView.sd_y = 64.0;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = App_Theme_Color;
    indicatorView.sd_height = 2;
    indicatorView.tag = -1;
    indicatorView.sd_y = titlesView.sd_height - indicatorView.sd_height;
    self.indicatorView = indicatorView;
    
    // 内部的子标签
    CGFloat width = titlesView.sd_width / self.childViewControllers.count;
    CGFloat height = titlesView.sd_height;
    NSInteger count = self.childViewControllers.count;
    for (NSInteger i = 0; i < count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.sd_height = height;
        button.sd_width = width;
        button.sd_x = i * width;
        UIViewController *vc = self.childViewControllers[i];
        [button setTitle:vc.title forState:UIControlStateNormal];
        // 强制布局(强制更新子控件的frame)
        //[button layoutIfNeeded];
        [button setTitleColor:RGB(121, 121, 121) forState:UIControlStateNormal];
        [button setTitleColor:App_Theme_Color forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [button addTarget:self action:@selector(toTitleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
//            self.indicatorView.sd_width = button.titleLabel.sd_width;
            self.indicatorView.sd_width = button.sd_width-24;
            self.indicatorView.sd_centerX = button.sd_centerX;
        }
    }
    
    [titlesView addSubview:indicatorView];
}


/**
 底部的scrollView
 */
- (void)setupContentView {
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    
    contentView.contentSize = CGSizeMake(contentView.sd_width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

#pragma mark - Actions

- (void)toTitleClick:(UIButton *)button {
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        if (button.tag == 0 || button.tag == self.childViewControllers.count-1) {
            self.indicatorView.sd_width = button.sd_width-24;
        } else {
            self.indicatorView.sd_width = button.sd_width;
        }
        
        self.indicatorView.sd_centerX = button.sd_centerX;
    }];
    
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.sd_width;
    [self.contentView setContentOffset:offset animated:YES];
}

- (void)toSettingAction {
    NewsSettingViewController *viewController =[[NewsSettingViewController alloc] init];
    viewController.title = @"消息设置";
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.sd_width;
    // 取出子控制器
    UIViewController *willShowVc = self.childViewControllers[index];
    
    // 如果当前位置的位置已经显示过了，就直接返回，这里是小细节，其实同一个view被添加N次 == 添加一次
    if ([willShowVc isViewLoaded]) return;
    
    willShowVc.view.sd_x = scrollView.contentOffset.x;
    willShowVc.view.sd_y = 44; // 设置控制器view的y值为0(默认是20)
    willShowVc.view.sd_height = scrollView.sd_height-104; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    [scrollView addSubview:willShowVc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.sd_width;
    [self toTitleClick:self.titlesView.subviews[index]];
}


@end
