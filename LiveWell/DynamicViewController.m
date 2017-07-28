//
//  DynamicViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/16.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "DynamicViewController.h"
#import "SubManageViewController.h"
#import "AccessoryButton.h"
#import "TopicHeaderView.h"
#import "DynamicCell.h"
#import <MJRefresh.h>
#import "PicDetailViewController.h"
#import "FKGPopOption.h"
#import "OptionItem.h"
#import "NoticeManageViewController.h"
#import "JXTAlertManagerHeader.h"
#import "iToast.h"

@interface DynamicViewController ()<UITableViewDataSource,UITableViewDelegate,DynamicCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FKGPopOption *popOption;

@property (nonatomic, strong) NSMutableArray *optionContents;

@property (nonatomic, strong) NSMutableArray *picStatus;
@property (nonatomic, strong) NSMutableArray *statusCells;//存储cell，用于计算高度

@end

@implementation DynamicViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initSubViews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initSubViews

- (void)initSubViews {
    UIView *titleView = [UIView new];
    titleView.frame = CGRectMake(0, 24, 100, 40);
    titleView.backgroundColor = [UIColor clearColor];
    
    AccessoryButton *titleBtn = [[AccessoryButton alloc] init];
    titleBtn.frame = CGRectMake(10, 0, 80, 40);
    titleBtn.backgroundColor = [UIColor clearColor];
    [titleBtn setTitle:@"全部动态" forState:UIControlStateNormal];
    [titleBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    [titleBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleBtn setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(showPopOption:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:titleBtn];
    
    self.navigationItem.titleView = titleView;
    
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    UIBarButtonItem *subBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStyleDone target:self action:@selector(toSubManageAction)];
    self.navigationItem.leftBarButtonItem = subBtn;
    
    UIBarButtonItem *noticeBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_bell"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStyleDone target:self action:@selector(toNoticeManageAction)];
    self.navigationItem.rightBarButtonItem = noticeBtn;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabBarControllerHeight);
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [self setupRefresh];
}

- (void)setupRefresh {
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
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    self.tableView.mj_footer = footer;
    footer.refreshingTitleHidden = YES;
    // Set title
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
}

#pragma mark - Private method

- (void)initData {
    self.optionContents = [[NSMutableArray alloc] init];
    [self.optionContents addObject:[[OptionItem alloc] initOption:@"全部动态" checked:YES]];
    [self.optionContents addObject:[[OptionItem alloc] initOption:@"我关注的" checked:NO]];
    [self.optionContents addObject:[[OptionItem alloc] initOption:@"我订阅的" checked:NO]];
    
    _picStatus = [[NSMutableArray alloc] init];
    _statusCells = [[NSMutableArray alloc] init];
}

- (void)sendRequest {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pic" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PicStatus *status = [PicStatus statusWithDictionary:obj];
            [_picStatus insertObject:status atIndex:0];
            DynamicCell *cell = [[DynamicCell alloc] init];
            [cell setStatus:status];
            [_statusCells insertObject:cell atIndex:0];
        }];
        
        [self.tableView.mj_header endRefreshing];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    });
}

- (void)loadMore {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pic" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PicStatus *status = [PicStatus statusWithDictionary:obj];
            [_picStatus insertObject:status atIndex:_picStatus.count];
            DynamicCell *cell = [[DynamicCell alloc] init];
            [cell setStatus:status];
            [_statusCells insertObject:cell atIndex:_statusCells.count];
        }];
        
        [self.tableView.mj_footer endRefreshing];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Actions

- (void)showPopOption:(AccessoryButton *)btn {
    // 注意：由convertRect: toView 获取到屏幕上该控件的绝对位置。
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CGRect frame = [btn convertRect:btn.bounds toView:window];
    
    if (!self.popOption) {
        CGRect popFrame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
        self.popOption = [[FKGPopOption alloc] initWithFrame:popFrame];
    }
    
    if (self.popOption.isShow) {
        [self.popOption dismiss];
        [btn setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
    } else {
        [btn setImage:[UIImage imageNamed:@"icon_arrow_up"] forState:UIControlStateNormal];
        self.popOption.option_optionContents = self.optionContents;
        [[self.popOption option_setupPopOption:^(NSInteger index, OptionItem *item) {
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
        } whichFrame:frame animate:YES] option_show];
    }
}

- (void)toSubManageAction {
    SubManageViewController *viewController = [[SubManageViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)toNoticeManageAction {
    NoticeManageViewController *viewController = [[NoticeManageViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)toAllTopicAction {
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.picStatus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"DynamicCell";
    DynamicCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    PicStatus *status = _picStatus[indexPath.row];
    cell.status = status;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicCell *cell = _statusCells[indexPath.row];
    return cell.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 78.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"topic" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    TopicHeaderView *headerView = [TopicHeaderView headerViewWithTableView:tableView];
    headerView.topics = array;
    self.tableView.tableHeaderView = headerView;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PicDetailViewController *viewController = [[PicDetailViewController alloc] init];
    viewController.status = _picStatus[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - DynamicCellDelegate

- (void)didClickSubBtn:(UIButton *)btn picStatus:(PicStatus *)status {
    if (status.sub) {
        [self jxt_showActionSheetWithTitle:nil message:@"确定不再关注？" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.
            addActionCancelTitle(@"取消").
            addActionDefaultTitle(@"确定");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if (buttonIndex != 0) {
                status.sub = !status.sub;
                [btn setTitle:@"关注" forState:UIControlStateNormal];
                [btn setBackgroundColor:UIColorFromRGB(0x57b4b5)];
            }
        }];
    } else {
        status.sub = !status.sub;
        [[iToast makeText:@"关注成功"] show];
        [btn setTitle:@"已关注" forState:UIControlStateNormal];
        [btn setBackgroundColor:RGB(181, 181, 181)];
    }
}

- (void)didClickLikeBtn:(UIButton *)btn picStatus:(PicStatus *)status {
    status.likeModel.isLike = !status.likeModel.isLike;
    int num = status.likeModel.num;
    if (status.likeModel.isLike) {
        num++;
        [btn setImage:[UIImage imageNamed:@"icon_like_s"] forState:UIControlStateNormal];
    } else {
        num--;
        [btn setImage:[UIImage imageNamed:@"icon_like_n"] forState:UIControlStateNormal];
    }
    status.likeModel.num = num;
    NSString *likeStr = [NSString stringWithFormat:@"%ld",status.likeModel.num];
    [btn setTitle:likeStr forState:UIControlStateNormal];
}

- (void)didClickStarBtn:(UIButton *)btn picStatus:(PicStatus *)status {
    status.starModel.isStar = !status.starModel.isStar;
    int num = status.starModel.num;
    if (status.starModel.isStar) {
        num++;
        [btn setImage:[UIImage imageNamed:@"icon_star_s"] forState:UIControlStateNormal];
    } else {
        num--;
        [btn setImage:[UIImage imageNamed:@"icon_star_n"] forState:UIControlStateNormal];
    }
    status.starModel.num = num;
    NSString *starStr = [NSString stringWithFormat:@"%ld",status.starModel.num];
    [btn setTitle:starStr forState:UIControlStateNormal];
}

- (void)didClickComment:(PicStatus *)status {
    PicDetailViewController *viewController = [[PicDetailViewController alloc] init];
    viewController.isTouchComment = YES;
    viewController.status = status;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
