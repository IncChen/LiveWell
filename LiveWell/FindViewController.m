//
//  FindViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/16.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "FindViewController.h"
#import "SearchCvCell.h"
#import "DiscoveryHeaderView.h"
#import <MJRefresh.h>
#import "FindStatus.h"
#import "FindTvCell.h"

static NSString *const cvSearchCellIdentifier = @"SearchCvCell";
static NSString *const cvSearchHeaderIdentifier = @"SearchCvHeader";

@interface FindViewController ()<UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SearchCvCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *accessoryViewBtn;
@property (nonatomic, strong) UICollectionView *searchCollectionView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *searchSections;
@property (nonatomic, strong) NSMutableArray *findSections;
@property (nonatomic, strong) NSMutableArray *findCells;//存储cell，用于计算高度

@end

@implementation FindViewController

#pragma mark - Getter

- (NSMutableArray *)searchSections {
    if (_searchSections == nil) {
        _searchSections = [[NSMutableArray alloc] init];
    }
    return _searchSections;
}

- (NSMutableArray *)findSections {
    if (_findSections == nil) {
        _findSections = [[NSMutableArray alloc] init];
    }
    return _findSections;
}

- (NSMutableArray *)findCells {
    if (_findCells == nil) {
        _findCells = [[NSMutableArray alloc] init];
    }
    return _findCells;
}

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
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self setupSearchBar];
    [self setupTableView];
    [self setupInputAccessoryView];
}

- (void)setupSearchBar {
    UIColor *color = self.navigationController.navigationBar.backgroundColor;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];//allocate titleView
    [titleView setBackgroundColor:color];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.barStyle = UISearchBarStyleMinimal;
    searchBar.frame = CGRectMake(0, 0, 300, 40);
    searchBar.backgroundColor = color;
    [searchBar.layer setBorderWidth:2];
    [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];  //设置边框为白色
    searchBar.placeholder = @"大家都在搜：收纳";
    
    UIView *searchTextField = nil;
    if (SYSTEM_VERSION >= 7.0) {
        searchBar.barTintColor = [UIColor whiteColor];
        searchTextField = [[[searchBar.subviews firstObject] subviews] lastObject];
    }else{// iOS6以下版本searchBar内部子视图的结构不一样
        for(UIView *subview in searchBar.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                searchTextField = subview;
            }
        }
    }
    searchTextField.layer.cornerRadius = 4.0f;
    searchTextField.layer.masksToBounds = YES;
    searchTextField.backgroundColor = RGBA(245, 245, 245, 0.7);
    
    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"取消";
    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].tintColor = [UIColor lightGrayColor];
    
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;

    //Set to titleView
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabBarControllerHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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

- (void)sendRequest {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"find" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FindStatus *status = [FindStatus statusWithDictionary:obj];
            [self.findSections insertObject:status atIndex:0];
            FindTvCell *cell = [[FindTvCell alloc] init];
            [cell setStatus:status];
            [self.findCells insertObject:cell atIndex:0];
        }];
        
        [self.tableView.mj_header endRefreshing];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    });
}

- (void)loadMore {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"find" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FindStatus *status = [FindStatus statusWithDictionary:obj];
            [self.findSections insertObject:status atIndex:self.findSections.count];
            FindTvCell *cell = [[FindTvCell alloc] init];
            [cell setStatus:status];
            [self.findCells insertObject:cell atIndex:self.findCells.count];
        }];
        
        [self.tableView.mj_footer endRefreshing];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)setupInputAccessoryView {
    // 遮盖层
    _accessoryViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 65, ScreenWidth, ScreenHeight)];
    [_accessoryViewBtn setBackgroundColor:RGBA(247, 247, 247, 1.0)];
    [_accessoryViewBtn setAlpha:0.0f];
    [_accessoryViewBtn addTarget:self action:@selector(toClickControlAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_accessoryViewBtn];
    
    [self.searchSections addObject:@"窗帘"];
    [self.searchSections addObject:@"沙发"];
    [self.searchSections addObject:@"橱柜"];
    [self.searchSections addObject:@"餐厅"];
    [self.searchSections addObject:@"衣帽间"];
    [self.searchSections addObject:@"飘窗"];
    [self.searchSections addObject:@"吊顶"];
    [self.searchSections addObject:@"茶几"];
    [self.searchSections addObject:@"隔断"];
    [self.searchSections addObject:@"梳妆台"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 40);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.accessoryViewBtn.frame.size.width, 128) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollsToTop = NO;
    collectionView.scrollEnabled = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.accessoryViewBtn addSubview:collectionView];
    self.searchCollectionView = collectionView;
    
    [collectionView registerClass:[SearchCvCell class] forCellWithReuseIdentifier:cvSearchCellIdentifier];
    //注册头视图
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cvSearchHeaderIdentifier];
}

// 控制遮罩层的透明度
- (void)controlAccessoryView:(float)alphaValue{
    
    [UIView animateWithDuration:0.2 animations:^{
        //动画代码
        [self.accessoryViewBtn setAlpha:alphaValue];
    }completion:^(BOOL finished){
        if (alphaValue<=0) {
            [self.searchBar resignFirstResponder];
            [self.searchBar setShowsCancelButton:NO animated:YES];
        }
    }];
}

#pragma mark - Actions

// 遮罩层（按钮）-点击处理事件
- (void)toClickControlAction:(id)sender{
    [self controlAccessoryView:0];
}

#pragma mark - UISearchBarDelegate

// UISearchBar得到焦点并开始编辑时，执行该方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self controlAccessoryView:1.0];// 显示遮盖层。
    return YES;
}

// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self controlAccessoryView:0];// 隐藏遮盖层。
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];// 放弃第一响应者
    [self controlAccessoryView:0];// 隐藏遮盖层。
}

// 当搜索内容变化时，执行该方法。很有用，可以实现时实搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    NSLog(@"textDidChange---%@",searchBar.text);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchSections.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath  {
    SearchCvCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cvSearchCellIdentifier forIndexPath:indexPath];
    cell.option = self.searchSections[indexPath.row];
    cell.delegate = self;
    return cell;

}

//返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:cvSearchHeaderIdentifier forIndexPath:indexPath];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 100, 20)];
        label.textColor = RGB(51, 51, 51);
        label.font = [UIFont systemFontOfSize:11];
        label.text = @"大家都在搜";
        [header addSubview:label];
        return header;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(4, 12, 4, 12);
}

//设置最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

//设置最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *option = self.searchSections[indexPath.row];
    CGSize titleSize = [option boundingRectWithSize:CGSizeMake(MAXFLOAT, 36) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kCellTitleFontSize]} context:nil].size;
    return CGSizeMake(titleSize.width+12*2, titleSize.height+8*2);
}

#pragma mark - SearchCvCellDelegate

- (void)didSelectedOption:(NSString *)option {
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self controlAccessoryView:0];// 隐藏遮盖层。
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.findSections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"FindCvCell";
    FindTvCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[FindTvCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    FindStatus *status = self.findSections[indexPath.row];
    cell.status = status;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FindTvCell *cell = self.findCells[indexPath.row];
    return cell.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 212.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DiscoveryHeaderView *headerView = [DiscoveryHeaderView headerViewWithTableView:tableView];
    self.tableView.tableHeaderView = headerView;
    return headerView;
}

@end
