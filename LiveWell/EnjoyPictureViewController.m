//
//  EnjoyPictureViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/16.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "EnjoyPictureViewController.h"
#import "RecommendViewController.h"
#import "LivingRoomViewController.h"
#import "SearchCvCell.h"

@interface EnjoyPictureViewController ()<LPPageVCDataSource,LPPageVCDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SearchCvCellDelegate>

@property (nonatomic, strong) UIView *accessoryView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray *modes;

@property (nonatomic, strong) NSMutableArray *nameList;//section数组名字

@property (nonatomic, strong) NSMutableArray *firstSections;
@property (nonatomic, strong) NSMutableArray *secondSections;
@property (nonatomic, strong) NSMutableArray *thirdSections;
@property (nonatomic, strong) NSMutableArray *fourthSections;
@property (nonatomic, strong) NSMutableArray *fifthSections;
@property (nonatomic, strong) NSMutableArray *sixthSections;

@end

@implementation EnjoyPictureViewController

#define REUESED_SIZE 6
static NSString *cellEnjoyPicId[REUESED_SIZE] = {nil}; //重用标示
static NSString *headerEnjoyPicId[REUESED_SIZE] = {nil}; //重用标示

+ (void)initialize{
    if (self == [EnjoyPictureViewController class]){
        for (int i = 0; i < REUESED_SIZE; i++) {
            cellEnjoyPicId[i] = [NSString stringWithFormat:@"EnjoyPicCell_%d", i];
            headerEnjoyPicId[i] = [NSString stringWithFormat:@"EnjoyPicHeader_%d", i];
        }
    }
}


#pragma mark - Getter

- (NSMutableArray *)nameList {
    if (_nameList == nil) {
        _nameList = [[NSMutableArray alloc] init];
    }
    return _nameList;
}

- (NSMutableArray *)firstSections {
    if (_firstSections == nil) {
        _firstSections = [[NSMutableArray alloc] init];
    }
    return _firstSections;
}

- (NSMutableArray *)secondSections {
    if (_secondSections == nil) {
        _secondSections = [[NSMutableArray alloc] init];
    }
    return _secondSections;
}

- (NSMutableArray *)thirdSections {
    if (_thirdSections == nil) {
        _thirdSections = [[NSMutableArray alloc] init];
    }
    return _thirdSections;
}

- (NSMutableArray *)fourthSections {
    if (_fourthSections == nil) {
        _fourthSections = [[NSMutableArray alloc] init];
    }
    return _fourthSections;
}

- (NSMutableArray *)fifthSections {
    if (_fifthSections == nil) {
        _fifthSections = [[NSMutableArray alloc] init];
    }
    return _fifthSections;
}

- (NSMutableArray *)sixthSections {
    if (_sixthSections == nil) {
        _sixthSections = [[NSMutableArray alloc] init];
    }
    return _sixthSections;
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
    self.navigationItem.title = @"看图";

    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    self.modes = @[
                   @"推荐",
                   @"客厅",
                   @"卧室",
                   @"卫生室",
                   @"厨房",
                   @"餐厅",
                   @"玄关",
                   @"阳台",
                   @"书房",
                   @"儿童房",
                   @"收纳",
                   @"装修记录",
                   @"小户型",
                   @"家务",
                   ];
    self.delegate = self;
    self.dataSource = self;
    self.segmentStyle = LPPageVCSegmentStyleLineHighlight;
    self.contentStyle = LPPageVCContentStyleEdit;
    self.normalTextColor = RGB(121, 121, 121);    // 标签normal
    self.higlightTextColor = App_Theme_Color;  // 标签higlight
    self.lineBackground = App_Theme_Color;    // 标签背景颜色
    [self reloadData];
    
    [self setupAccessoryView];
}

- (void)setupAccessoryView {
    // 遮盖层
    _accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, ScreenWidth, ScreenHeight-108)];
    [_accessoryView setBackgroundColor:[UIColor whiteColor]];
    [_accessoryView setAlpha:0.0f];
    [self.view addSubview:_accessoryView];
    
    CGFloat height = 40;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, height/2.0-14/2.0, 44, 14)];
    label.text = @"筛选";
    label.textColor = RGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:12];
    [_accessoryView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(_accessoryView.frame.size.width-12-18, height/2.0-20/2.0, 20, 20);
    [btn setImage:[UIImage imageNamed:@"ic_diamond"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toHideAccessoryView) forControlEvents:UIControlEventTouchUpInside];
    [_accessoryView addSubview:btn];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height, _accessoryView.frame.size.width, 0.6)];
    line.backgroundColor = TableView_Separator;
    [_accessoryView addSubview:line];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 40);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), self.accessoryView.frame.size.width, self.accessoryView.frame.size.height-42) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollsToTop = NO;
    collectionView.scrollEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    [_accessoryView addSubview:collectionView];
    self.collectionView = collectionView;
    
    for (int i = 0; i < REUESED_SIZE; i++) {
        [collectionView registerClass:[SearchCvCell class] forCellWithReuseIdentifier:cellEnjoyPicId[i]];
        //注册头视图
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerEnjoyPicId[i]];
    }
    
    [self loadSectionData];
}

- (void)loadSectionData {
    for (int i = 0; i < REUESED_SIZE; i++) {
        [self.nameList addObject:[NSString stringWithFormat:@"cell_%d", i]];
    }
    
    [self.firstSections addObject:@"客厅"];
    [self.firstSections addObject:@"卧室"];
    [self.firstSections addObject:@"卫生间"];
    [self.firstSections addObject:@"厨房"];
    [self.firstSections addObject:@"餐厅"];
    [self.firstSections addObject:@"玄关"];
    [self.firstSections addObject:@"阳台"];
    [self.firstSections addObject:@"书房"];
    [self.firstSections addObject:@"走廊"];
    [self.firstSections addObject:@"儿童房"];
    [self.firstSections addObject:@"衣帽间"];
    [self.firstSections addObject:@"开放式厨房"];
    
    [self.secondSections addObject:@"床"];
    [self.secondSections addObject:@"沙发"];
    [self.secondSections addObject:@"餐桌"];
    [self.secondSections addObject:@"茶几"];
    [self.secondSections addObject:@"书桌"];
    [self.secondSections addObject:@"书柜"];
    [self.secondSections addObject:@"衣柜"];
    [self.secondSections addObject:@"鞋柜"];
    [self.secondSections addObject:@"灯"];
    [self.secondSections addObject:@"吊灯"];
    [self.secondSections addObject:@"落地灯"];
    [self.secondSections addObject:@"窗帘"];
    [self.secondSections addObject:@"地毯"];
    [self.secondSections addObject:@"绿植"];
    [self.secondSections addObject:@"电视柜"];
    [self.secondSections addObject:@"床头柜"];
    [self.secondSections addObject:@"餐边柜"];
    [self.secondSections addObject:@"浴室柜"];
    [self.secondSections addObject:@"置物柜"];
    [self.secondSections addObject:@"梳妆柜"];
    [self.secondSections addObject:@"装饰画"];
    
    [self.thirdSections addObject:@"门"];
    [self.thirdSections addObject:@"窗"];
    [self.thirdSections addObject:@"墙"];
    [self.thirdSections addObject:@"吊顶"];
    [self.thirdSections addObject:@"地板"];
    [self.thirdSections addObject:@"瓷砖"];
    [self.thirdSections addObject:@"马桶"];
    [self.thirdSections addObject:@"浴缸"];
    [self.thirdSections addObject:@"墙漆"];
    [self.thirdSections addObject:@"隔断"];
    [self.thirdSections addObject:@"花砖"];
    [self.thirdSections addObject:@"谷仓门"];
    [self.thirdSections addObject:@"推拉门"];
    [self.thirdSections addObject:@"文化墙"];
    [self.thirdSections addObject:@"踢脚线"];
    
    [self.fourthSections addObject:@"飘窗"];
    [self.fourthSections addObject:@"隔板"];
    [self.fourthSections addObject:@"床头"];
    [self.fourthSections addObject:@"吧台"];
    [self.fourthSections addObject:@"洗衣区"];
    [self.fourthSections addObject:@"黑板墙"];
    [self.fourthSections addObject:@"照片墙"];
    [self.fourthSections addObject:@"榻榻米"];
    [self.fourthSections addObject:@"阅读角"];
    [self.fourthSections addObject:@"电视背景墙"];
    [self.fourthSections addObject:@"沙发背景墙"];
    [self.fourthSections addObject:@"家庭工作区"];
    [self.fourthSections addObject:@"干湿分离"];
    
    [self.fifthSections addObject:@"冰箱"];
    [self.fifthSections addObject:@"空调"];
    [self.fifthSections addObject:@"烤箱"];
    [self.fifthSections addObject:@"电视机"];
    [self.fifthSections addObject:@"投影"];
    [self.fifthSections addObject:@"音响"];
    [self.fifthSections addObject:@"微波炉"];
    [self.fifthSections addObject:@"洗碗机"];
    [self.fifthSections addObject:@"洗衣机"];
    [self.fifthSections addObject:@"油烟机"];
    [self.fifthSections addObject:@"空气净化器"];
    
    [self.sixthSections addObject:@"收纳"];
    [self.sixthSections addObject:@"装修记录"];
    [self.sixthSections addObject:@"小户型"];
    [self.sixthSections addObject:@"家务"];
}

// 控制遮罩层的透明度
- (void)controlAccessoryView:(float)alphaValue{
    
    [UIView animateWithDuration:0.2 animations:^{
        //动画代码
        [self.accessoryView setAlpha:alphaValue];
    }completion:^(BOOL finished){
        
    }];
}

#pragma mark - Actions

- (void)toHideAccessoryView {
    [self controlAccessoryView:0];
}

#pragma mark - LPPageVCDataSource

- (NSInteger)numberOfContentForPageVC:(LPPageVC *)pageVC {
    return self.modes.count;
}

- (NSString *)pageVC:(LPPageVC *)pageVC titleAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"%@", self.modes[index]];
}

- (UIViewController *)pageVC:(LPPageVC *)pageVC viewControllerAtIndex:(NSInteger)index {
    UIViewController *viewController = nil;
    switch (index) {
        case 0:
            //推荐
            viewController = [[RecommendViewController alloc] init];
            break;
        case 1:
            //客厅
            viewController = [[LivingRoomViewController alloc] init];
            break;
        case 2:
            //卧室
            viewController = [[LivingRoomViewController alloc] init];
            break;
        case 3:
            //卫生间
            viewController = [[LivingRoomViewController alloc] init];
            break;
        case 4:
            //厨房
            viewController = [[LivingRoomViewController alloc] init];
            break;
        case 5:
            //餐厅
            viewController = [[LivingRoomViewController alloc] init];
            break;
        case 6:
            //玄关
            viewController = [[LivingRoomViewController alloc] init];
            break;
        case 7:
            //阳台
            viewController = [[LivingRoomViewController alloc] init];
            break;
        case 8:
            //书房
            viewController = [[LivingRoomViewController alloc] init];
            break;
        case 9:
            //儿童房
            viewController = [[LivingRoomViewController alloc] init];
            break;
        case 10:
            //收纳
            viewController = [[LivingRoomViewController alloc] init];
            break;
        case 11:
            //装修记录
            viewController = [[LivingRoomViewController alloc] init];
            break;
        case 12:
            //小户型
            viewController = [[LivingRoomViewController alloc] init];
            break;
        case 13:
            //家务
            viewController = [[LivingRoomViewController alloc] init];
            break;
        default:
            break;
    }
    return viewController;
}

#pragma mark - LPPageVCDelegate

- (void)pageVC:(LPPageVC *)pageVC didChangeToIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex {
//    NSLog(@"LPPageVC - index %ld - fromIndex %ld",(long)toIndex,(long)fromIndex);
}

- (void)pageVC:(LPPageVC *)pageVC didClickEditMode:(LPPageVCEditMode)mode {
    [self controlAccessoryView:1.0];// 显示遮盖层。
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.nameList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.nameList[section] isEqualToString:@"cell_0"]) {
        return self.firstSections.count;
    } else if ([self.nameList[section] isEqualToString:@"cell_1"]) {
        return self.secondSections.count;
    } else if ([self.nameList[section] isEqualToString:@"cell_2"]) {
        return self.thirdSections.count;
    } else if ([self.nameList[section] isEqualToString:@"cell_3"]) {
        return self.fourthSections.count;
    } else if ([self.nameList[section] isEqualToString:@"cell_4"]) {
        return self.fifthSections.count;
    } else if ([self.nameList[section] isEqualToString:@"cell_5"]) {
        return self.sixthSections.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchCvCell *cell;
    if ([self.nameList[indexPath.section] isEqualToString:@"cell_0"]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellEnjoyPicId[indexPath.section] forIndexPath:indexPath];
        cell.option = self.firstSections[indexPath.item];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_1"]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellEnjoyPicId[indexPath.section] forIndexPath:indexPath];
        cell.option = self.secondSections[indexPath.item];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_2"]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellEnjoyPicId[indexPath.section] forIndexPath:indexPath];
        cell.option = self.thirdSections[indexPath.item];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_3"]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellEnjoyPicId[indexPath.section] forIndexPath:indexPath];
        cell.option = self.fourthSections[indexPath.item];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_4"]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellEnjoyPicId[indexPath.section] forIndexPath:indexPath];
        cell.option = self.fifthSections[indexPath.item];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_5"]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellEnjoyPicId[indexPath.section] forIndexPath:indexPath];
        cell.option = self.sixthSections[indexPath.item];
    }
    cell.delegate = self;
    
    return cell;
}

//返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerEnjoyPicId[indexPath.section] forIndexPath:indexPath];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 60, 20)];
        label.textColor = RGB(51, 51, 51);
        label.font = [UIFont systemFontOfSize:11];
        [header addSubview:label];
        
        if ([self.nameList[indexPath.section] isEqualToString:@"cell_0"]) {
            label.text = @"空间";
        } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_1"]) {
            label.text = @"软装";
        } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_2"]) {
            label.text = @"硬装";
        } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_3"]) {
            label.text = @"局部";
        } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_4"]) {
            label.text = @"家电";
        } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_5"]) {
            label.text = @"其他";
        }
        
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
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *theme;
    if ([self.nameList[indexPath.section] isEqualToString:@"cell_0"]) {
        theme = self.firstSections[indexPath.row];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_1"]) {
        theme = self.secondSections[indexPath.row];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_2"]) {
        theme = self.thirdSections[indexPath.row];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_3"]) {
        theme = self.fourthSections[indexPath.row];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_4"]) {
        theme = self.fifthSections[indexPath.row];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_5"]) {
        theme = self.sixthSections[indexPath.row];
    }
    CGSize titleSize = [theme boundingRectWithSize:CGSizeMake(MAXFLOAT, 36) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kCellTitleFontSize]} context:nil].size;
    return CGSizeMake(titleSize.width+12*2, titleSize.height+8*2);
}

#pragma mark - SearchCvCellDelegate

- (void)didSelectedOption:(NSString *)option{
    [self controlAccessoryView:0];// 隐藏遮盖层。
}

@end
