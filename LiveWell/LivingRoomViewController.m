//
//  LivingRoomViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/30.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "LivingRoomViewController.h"
#import <MJRefresh.h>
#import "WaterFlowLayout.h"
#import "PicStatus.h"
#import "PicStatusCollectionViewCell.h"
#import "PicDetailViewController.h"

static NSString *const ShopId = @"livingShop";

@interface LivingRoomViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,WaterFlowLayoutDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *picStatus;
@property (nonatomic, strong) NSMutableArray *statusCells;//存储cell，用于计算高度

@end

@implementation LivingRoomViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViews];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initSubViews

- (void)initSubViews {
    WaterFlowLayout *layout = [[WaterFlowLayout alloc] init];
    layout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, 10, self.view.bounds.size.width, self.view.bounds.size.height-156) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView registerClass:[PicStatusCollectionViewCell class] forCellWithReuseIdentifier:ShopId];
    
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
    self.collectionView.mj_header = header;
    [self.collectionView.mj_header beginRefreshing];
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    self.collectionView.mj_footer = footer;
    footer.refreshingTitleHidden = YES;
    // Set title
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
}

#pragma mark - Private method

- (void)initData {
    _picStatus = [[NSMutableArray alloc] init];
    _statusCells = [[NSMutableArray alloc] init];
}

-(NSArray *)randomArray {
    //随机数从这里边产生
    NSMutableArray *startArray = self.picStatus;
    //随机数产生结果
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
    //随机数个数
    NSInteger m=8;
    for (int i=0; i<m; i++) {
        int t=arc4random()%startArray.count;
        resultArray[i]=startArray[t];
        startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    return resultArray;
}

- (void)sendRequest {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pic" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *startArray = [[NSMutableArray alloc] init];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PicStatus *status = [PicStatus statusWithDictionary:obj];
            [startArray addObject:status];
        }];
        
        //随机数产生结果
        NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
        //随机数个数
        NSInteger m = startArray.count;
        for (int i = 0; i < m; i++) {
            int t = arc4random() % startArray.count;
            resultArray[i] = startArray[t];
            startArray[t] = [startArray lastObject]; //为更好的乱序，故交换下位置
            [startArray removeLastObject];
        }
        
        for (PicStatus *status in resultArray) {
            PicStatusCollectionViewCell *cell = [[PicStatusCollectionViewCell alloc] init];
            [_picStatus insertObject:status atIndex:0];
            [cell setStatus:status];
            [_statusCells insertObject:cell atIndex:0];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
        [self.collectionView.mj_header endRefreshing];
    });
}

- (void)loadMore {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pic" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PicStatus *status = [PicStatus statusWithDictionary:obj];
            [_picStatus insertObject:status atIndex:_picStatus.count];
            PicStatusCollectionViewCell *cell = [[PicStatusCollectionViewCell alloc] init];
            [cell setStatus:status];
            [_statusCells insertObject:cell atIndex:_statusCells.count];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.picStatus.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PicStatusCollectionViewCell *cell = (PicStatusCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ShopId forIndexPath:indexPath];
    
    PicStatus *status = _picStatus[indexPath.row];
    cell.status = status;
    return cell;
}

#pragma mark -  UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        PicDetailViewController *viewController = [[PicDetailViewController alloc] init];
        viewController.status = _picStatus[indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - WaterFlowLayoutDelegate

- (CGFloat)waterflowLayout:(WaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    
    PicStatusCollectionViewCell *cell = (PicStatusCollectionViewCell *)_statusCells[index];
    return cell.height;
}

- (CGFloat)rowMarginInWaterflowLayout:(WaterFlowLayout *)waterflowLayout {
    return 12;
}

- (CGFloat)columnCountInWaterflowLayout:(WaterFlowLayout *)waterflowLayout {
    return 2;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterFlowLayout *)waterflowLayout {
    return UIEdgeInsetsMake(12, 12, 12, 12);
}

@end
