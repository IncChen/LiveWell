//
//  TopicHeaderView.m
//  LiveWell
//
//  Created by Mark on 2017/7/17.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "TopicHeaderView.h"
#import "AccessoryButton.h"
#import "TopicCell.h"

#define kStatusCellControlSpacing 12
#define topicCellControlSpacing 10

static NSString *const reuseIdentifier = @"TopicCell";


@interface TopicHeaderView ()<UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UILabel *topicLabel;
@property (nonatomic, weak) AccessoryButton *allTopicBtn;

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation TopicHeaderView

+ (instancetype)topicHeaderView {
    return [[self alloc] init];
}

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TopicHeader";
    TopicHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
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

#pragma mark - 公共方法
- (void)setTopics:(NSArray *)topics {
    _topics = topics;
    [self.collectionView reloadData];
}

#pragma mark - 私有方法
#pragma mark - 初始化
- (void)setup {
    self.contentView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 创建自控制器
- (void)setupSubViews {
    
    UILabel *topicLabel = [[UILabel alloc] init];
    topicLabel.frame = CGRectMake(kStatusCellControlSpacing, kStatusCellControlSpacing, 80, 20);
    topicLabel.text = @"热门话题";
    topicLabel.textColor = RGB(136, 136, 136);
    topicLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:topicLabel];
    self.topicLabel = topicLabel;
    
    AccessoryButton *allTopicBtn = [[AccessoryButton alloc] init];
    allTopicBtn.frame = CGRectMake(ScreenWidth-64-kStatusCellControlSpacing, kStatusCellControlSpacing, 70, 20);
    allTopicBtn.backgroundColor = [UIColor clearColor];
    [allTopicBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    [allTopicBtn setImage:[UIImage imageNamed:@"icon_right"] forState:UIControlStateNormal];
//    [allTopicBtn addTarget:self action:@selector(toAllTopicAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:allTopicBtn];
    self.allTopicBtn = allTopicBtn;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topicLabel.frame), ScreenWidth, topicCellHeight+kStatusCellControlSpacing*2) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollsToTop = NO;
    collectionView.scrollEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView registerClass:[TopicCell class] forCellWithReuseIdentifier:reuseIdentifier];
}


#pragma mark - UICollectionViewDataSource

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.topics.count;
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TopicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.topicUrl = self.topics[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets top = UIEdgeInsetsMake(4, 12, 4, 12);
    return top;
}

//设置最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return topicCellControlSpacing;
}

//设置最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(topicCellWidth, topicCellHeight);
}


@end
