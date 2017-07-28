//
//  LevyViewController.m
//  LiveWell
//
//  Created by Mark on 2017/7/20.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "LevyViewController.h"
#import <MJRefresh.h>
#import "LevySection.h"
#import "LevyCell.h"


@interface LevyViewController () {
    BOOL isNotificationTypeNone;
}

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *sectionCells;//存储cell，用于计算高度

@end

@implementation LevyViewController

#pragma mark - Getter

- (NSMutableArray *)sections {
    if (_sections == nil) {
        _sections = [[NSMutableArray alloc] init];
    }
    return _sections;
}

- (NSMutableArray *)sectionCells {
    if (_sectionCells == nil) {
        _sectionCells = [[NSMutableArray alloc] init];
    }
    return _sectionCells;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(245, 245, 245);
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSArray *idleImages = @[
                            [UIImage imageNamed:@"loding00"]
                            ];
    NSArray *refreshingImages = @[
                                  [UIImage imageNamed:@"loding01"],
                                  [UIImage imageNamed:@"loding02"],
                                  [UIImage imageNamed:@"loding03"]
                                  ];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(sendRequest)];
    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
        //已关闭
        isNotificationTypeNone = YES;
    } else {
        //已开启
        isNotificationTypeNone = NO;
    }
    
    [self setupHeaderView];
}

- (void)sendRequest {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.sections.count == 0) {
            LevySection *section0 = [[LevySection alloc] init];
            section0.imageName = @"pic_levy0";
            section0.detailTextLabel = @"还没发过图？福利来了：抬起手机拍一张你家的美照，赢好好住精美周边。";
            section0.dateLabel = @"07年20日 20:09";
            [self.sections addObject:section0];
            
            LevySection *section1 = [[LevySection alloc] init];
            section1.textLabel = @"正在征集：我的剁手战利品";
            section1.detailTextLabel = @"快来晒晒过去半年，你家新添的家居品吧！";
            section1.dateLabel = @"07年07日 09:02";
            [self.sections addObject:section1];
            
            LevySection *section2 = [[LevySection alloc] init];
            section2.textLabel = @"有奖征集：快来晒出你的第一张图！";
            section2.detailTextLabel = @"你在好好住潜水多久啦？参与本次征集，晒出你家任何一处，就有机会获得好好住精美周边，快来参与吧！";
            section2.dateLabel = @"06年22日 12:31";
            [self.sections addObject:section2];
            
            LevySection *section3 = [[LevySection alloc] init];
            section3.imageName = @"pic_levy1";
            section3.detailTextLabel = @"记得点❤️收藏，有空拿来做参考，列出最适合自己的装修预算表。";
            section3.dateLabel = @"04年25日 14:30";
            [self.sections addObject:section3];
            
            for (LevySection *section in self.sections) {
                LevyCell *cell = [[LevyCell alloc] init];
                [cell setLevy:section];
                [self.sectionCells addObject:cell];
            }
            [self.tableView reloadData];
        }
        
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)setupHeaderView {
    if (isNotificationTypeNone) {

    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 8)];
        view.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = view;
        [self.tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

#pragma mark - UIApplication Delegate

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
        //已关闭
        isNotificationTypeNone = YES;
    } else {
        //已开启
        isNotificationTypeNone = NO;
    }
    
    [self setupHeaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)toCancelShowNotification {
    isNotificationTypeNone = NO;
    [self setupHeaderView];
    [self.tableView reloadData];
}

- (void)toOpenNotificationUrl {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//    NSURL *url = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"LevyCellId";
    LevyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[LevyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.levy = self.sections[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LevyCell *cell = self.sectionCells[indexPath.row];
    return cell.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return isNotificationTypeNone == YES ? 78.0 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (isNotificationTypeNone) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        tableView.tableHeaderView = view;
        
        UIView *separator = [[UIView alloc] init];
        separator.frame = CGRectMake(0, 1, tableView.frame.size.width, 0.8);
        separator.backgroundColor = RGB(245, 245, 245);
        [view addSubview:separator];
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(12, 18, 120, 21);
        textLabel.text = @"打开推送通知";
        textLabel.textColor = RGB(66, 66, 66);
        textLabel.font = [UIFont systemFontOfSize:15];
        [textLabel sizeToFit];
        [view addSubview:textLabel];
        
        UILabel *detailTextLabel = [[UILabel alloc] init];
        detailTextLabel.frame = CGRectMake(textLabel.frame.origin.x, CGRectGetMaxY(textLabel.frame)+2, 140, 18);
        detailTextLabel.text = @"不错过任何一个家装妙计";
        detailTextLabel.textColor = RGB(199, 199, 199);
        detailTextLabel.font = [UIFont systemFontOfSize:12];
        [detailTextLabel sizeToFit];
        [view addSubview:detailTextLabel];
        
        CGFloat cancelBtnW = 18;
        CGFloat cancelBtnH = 18;
        CGFloat cancelBtnX = tableView.frame.size.width-12-cancelBtnW;
        CGFloat cancelBtnY = 12;
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(cancelBtnX, cancelBtnY, cancelBtnW, cancelBtnH);
        [cancelBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(toCancelShowNotification) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancelBtn];
        
        CGFloat openBtnW = 64;
        CGFloat openBtnH = 24;
        CGFloat openBtnX = tableView.frame.size.width-12-openBtnW;
        CGFloat openBtnY = CGRectGetMaxY(cancelBtn.frame)+10;
        UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        openBtn.frame = CGRectMake(openBtnX, openBtnY, openBtnW, openBtnH);
        openBtn.backgroundColor = App_Theme_Color;
        [openBtn setTitle:@"立即打开" forState:UIControlStateNormal];
        [openBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [openBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        openBtn.layer.cornerRadius = 4.0f;
        openBtn.layer.masksToBounds = YES;
        [openBtn addTarget:self action:@selector(toOpenNotificationUrl) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:openBtn];
        
        UIView *cellSeparator = [[UIView alloc] init];
        cellSeparator.frame = CGRectMake(0, 70, tableView.frame.size.width, 8);
        cellSeparator.backgroundColor = RGB(245, 245, 245);
        [view addSubview:cellSeparator];
        
        return view;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
//    tableView.tableFooterView = view;
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake(0, 0, tableView.frame.size.width, 20);
    textLabel.text = @"——·END·——";
    textLabel.textColor = RGB(199, 199, 199);
    textLabel.font = [UIFont systemFontOfSize:11];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:textLabel];
    
    return view;
}

@end
