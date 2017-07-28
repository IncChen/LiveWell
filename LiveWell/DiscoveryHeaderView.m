//
//  DiscoveryHeaderView.m
//  LiveWell
//
//  Created by Mark on 2017/7/27.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "DiscoveryHeaderView.h"
#import "TopicCell.h"
#import "SDCycleScrollView.h"
#import "UserSection.h"
#import "DiscoveryCvCell.h"

#define kStatusCellControlSpacing 12

static NSString *const cvDiscoveryCellIdentifier = @"DiscoveryCvCell";
static NSString *const cvTopicCellIdentifier = @"TopicCvCell";

static const NSInteger sTagDiscoveryCv = 101;
static const NSInteger sTagTopicCv = 102;

@interface DiscoveryHeaderView ()<SDCycleScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *discoveryCollectionView;
@property (nonatomic, strong) UICollectionView *topicCollectionView;

@property (nonatomic, strong) NSMutableArray *discoverySections;
@property (nonatomic, strong) NSMutableArray *topicSections;

@end

@implementation DiscoveryHeaderView

+ (instancetype)discoveryHeaderView {
    return [[self alloc] init];
}

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    static NSString *ID = @"DiscoveryHeader";
    DiscoveryHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        // 缓存池中没有, 自己创建
        header = [[self alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        // 初始化
        [self setup];
        
        // 创建自控制器
        [self setupSubViews];
    }
    return self;
}

#pragma mark - Getter

- (NSMutableArray *)discoverySections {
    if (_discoverySections == nil) {
        _discoverySections = [[NSMutableArray alloc] init];
    }
    return _discoverySections;
}

- (NSMutableArray *)topicSections {
    if (_topicSections == nil) {
        _topicSections = [[NSMutableArray alloc] init];
    }
    return _topicSections;
}

#pragma mark - 私有方法
#pragma mark - 初始化
- (void)setup {
    self.contentView.backgroundColor = [UIColor clearColor];
}

#pragma mark - 创建自控制器
- (void)setupSubViews {
    
    //图片轮播
    NSArray *imageNames = @[@"pic_discovery_top0.png",
                            @"pic_discovery_top1.png",
                            @"pic_discovery_top2.png",
                            @"pic_discovery_top3.png"
                            ];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 160) shouldInfiniteLoop:YES imageNamesGroup:imageNames];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [self.contentView addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cycleScrollView.autoScrollTimeInterval = 3.0;
    cycleScrollView.pageControlDotSize = CGSizeMake(8, 8);
    
    //discovery
    [self.discoverySections addObject:[[UserSection alloc] initSectionImage:@"icon_discovery_allhouse" text:@"整屋案例"]];
    [self.discoverySections addObject:[[UserSection alloc] initSectionImage:@"icon_discovery_guide" text:@"居住指南"]];
    [self.discoverySections addObject:[[UserSection alloc] initSectionImage:@"icon_discovery_topic" text:@"话题"]];
    [self.discoverySections addObject:[[UserSection alloc] initSectionImage:@"icon_discovery_activity" text:@"大家的家"]];
    [self.discoverySections addObject:[[UserSection alloc] initSectionImage:@"icon_discovery_recommend" text:@"今日推荐"]];
    [self.discoverySections addObject:[[UserSection alloc] initSectionImage:@"icon_discovery_finddesign" text:@"找设计师"]];
    
    UICollectionViewFlowLayout *discoveryFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    discoveryFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _discoveryCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cycleScrollView.frame), ScreenWidth, 160) collectionViewLayout:discoveryFlowLayout];
    _discoveryCollectionView.dataSource = self;
    _discoveryCollectionView.delegate = self;
    _discoveryCollectionView.scrollsToTop = NO;
    _discoveryCollectionView.scrollEnabled = NO;
    _discoveryCollectionView.showsVerticalScrollIndicator = NO;
    _discoveryCollectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_discoveryCollectionView];
    _discoveryCollectionView.tag = sTagDiscoveryCv;
    
    [_discoveryCollectionView registerClass:[DiscoveryCvCell class] forCellWithReuseIdentifier:cvDiscoveryCellIdentifier];
    
    //topic
    NSString *path = [[NSBundle mainBundle] pathForResource:@"discovery" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    [self.topicSections addObjectsFromArray:array];
    
    UICollectionViewFlowLayout *topicFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [topicFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _topicCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_discoveryCollectionView.frame), ScreenWidth, topicCellHeight+kStatusCellControlSpacing*2) collectionViewLayout:topicFlowLayout];
    _topicCollectionView.dataSource = self;
    _topicCollectionView.delegate = self;
    _topicCollectionView.scrollsToTop = NO;
    _topicCollectionView.scrollEnabled = YES;
    _topicCollectionView.showsHorizontalScrollIndicator = NO;
    _topicCollectionView.showsVerticalScrollIndicator = NO;
    _topicCollectionView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_topicCollectionView];
    _topicCollectionView.tag = sTagTopicCv;
    
    [_topicCollectionView registerClass:[TopicCell class] forCellWithReuseIdentifier:cvTopicCellIdentifier];
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"---点击了第%ld张图片", (long)index);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == sTagDiscoveryCv) {
        return self.discoverySections.count;
    } else if (collectionView.tag == sTagTopicCv) {
        return self.topicSections.count;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath  {
    if (collectionView.tag == sTagDiscoveryCv) {
        DiscoveryCvCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cvDiscoveryCellIdentifier forIndexPath:indexPath];
        cell.section = self.discoverySections[indexPath.row];
        return cell;
    } else if (collectionView.tag == sTagTopicCv) {
        TopicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cvTopicCellIdentifier forIndexPath:indexPath];
        cell.topicUrl = self.topicSections[indexPath.row];
        return cell;
    }
    return nil;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == sTagDiscoveryCv) {
        return UIEdgeInsetsMake(16, 24, 16, 24);
    } else if (collectionView.tag == sTagTopicCv) {
        return UIEdgeInsetsMake(4, 12, 4, 12);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == sTagDiscoveryCv) {
        return 24;
    } else if (collectionView.tag == sTagTopicCv) {
        return 10;
    }
    return 0;
}

//设置最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == sTagDiscoveryCv) {
        return 48;
    } else if (collectionView.tag == sTagTopicCv) {
        return 0;
    }
    return 0;
}

//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == sTagDiscoveryCv) {
        return CGSizeMake(48, 48);
    } else if (collectionView.tag == sTagTopicCv) {
        return CGSizeMake(topicCellWidth, topicCellHeight);
    }
    return CGSizeMake(0, 0);
}

@end
