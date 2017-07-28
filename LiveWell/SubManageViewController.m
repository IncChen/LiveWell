//
//  SubManageViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/28.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "SubManageViewController.h"
#import "SubManageCell.h"
#import "OptionItem.h"

static NSString *const reuseIdentifier = @"SubManageCell";

@interface SubManageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SubManageCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *nameList;//section数组名字
@property (nonatomic, strong) NSMutableArray *firstSections;
@property (nonatomic, strong) NSMutableArray *secondSections;
@property (nonatomic, strong) NSMutableArray *thirdSections;
@property (nonatomic, strong) NSMutableArray *fourthSections;

@end

@implementation SubManageViewController

#define REUESED_SIZE 4
static NSString *cellUsedStr[REUESED_SIZE] = {nil}; //重用标示
static NSString *cellHeaderStr[REUESED_SIZE] = {nil}; //重用标示

+ (void)initialize{
    if (self == [SubManageViewController class]){
        for (int i = 0; i < REUESED_SIZE; i++) {
            cellUsedStr[i] = [NSString stringWithFormat:@"SubManage_%d", i];
            cellHeaderStr[i] = [NSString stringWithFormat:@"Header_%d", i];
        }
    }
}

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

#pragma mark - initSubViews

- (void)initSubViews {
    self.navigationItem.title = @"订阅管理";
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(toSaveAction)];
    self.navigationItem.leftBarButtonItem = saveBtn;
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], UITextAttributeFont, [UIColor blackColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 40);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollsToTop = NO;
    collectionView.scrollEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    for (int i = 0; i < REUESED_SIZE; i++) {
        [collectionView registerClass:[SubManageCell class] forCellWithReuseIdentifier:cellUsedStr[i]];
        //注册头视图
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellHeaderStr[i]];
    }
}

#pragma mark - Private method

- (void)initData {
    for (int i = 0; i < REUESED_SIZE; i++) {
        [self.nameList addObject:[NSString stringWithFormat:@"cell_%d", i]];
    }
    
    [self.firstSections addObject:[[OptionItem alloc] initOption:@"客厅" checked:YES]];
    [self.firstSections addObject:[[OptionItem alloc] initOption:@"卫生间" checked:YES]];
    [self.firstSections addObject:[[OptionItem alloc] initOption:@"厨房" checked:YES]];
    [self.firstSections addObject:[[OptionItem alloc] initOption:@"卧室" checked:YES]];
    [self.firstSections addObject:[[OptionItem alloc] initOption:@"阳台" checked:YES]];
    [self.firstSections addObject:[[OptionItem alloc] initOption:@"玄关" checked:YES]];
    [self.firstSections addObject:[[OptionItem alloc] initOption:@"餐厅" checked:YES]];

    [self.secondSections addObject:[[OptionItem alloc] initOption:@"瓷砖" checked:YES]];
    [self.secondSections addObject:[[OptionItem alloc] initOption:@"门" checked:YES]];
    [self.secondSections addObject:[[OptionItem alloc] initOption:@"橱柜" checked:NO]];
    [self.secondSections addObject:[[OptionItem alloc] initOption:@"地板" checked:YES]];
    [self.secondSections addObject:[[OptionItem alloc] initOption:@"吧台" checked:NO]];
    [self.secondSections addObject:[[OptionItem alloc] initOption:@"洗漱台" checked:YES]];
    
    [self.thirdSections addObject:[[OptionItem alloc] initOption:@"窗帘" checked:YES]];
    [self.thirdSections addObject:[[OptionItem alloc] initOption:@"绿值" checked:NO]];
    [self.thirdSections addObject:[[OptionItem alloc] initOption:@"衣柜" checked:YES]];
    [self.thirdSections addObject:[[OptionItem alloc] initOption:@"床" checked:YES]];
    [self.thirdSections addObject:[[OptionItem alloc] initOption:@"沙发" checked:YES]];
    [self.thirdSections addObject:[[OptionItem alloc] initOption:@"吊灯" checked:YES]];
    [self.thirdSections addObject:[[OptionItem alloc] initOption:@"装饰画" checked:YES]];
    [self.thirdSections addObject:[[OptionItem alloc] initOption:@"地毯" checked:NO]];
    
    [self.fourthSections addObject:[[OptionItem alloc] initOption:@"收纳" checked:YES]];
    [self.fourthSections addObject:[[OptionItem alloc] initOption:@"小户型" checked:YES]];
    [self.fourthSections addObject:[[OptionItem alloc] initOption:@"电视背景墙" checked:NO]];
    [self.fourthSections addObject:[[OptionItem alloc] initOption:@"飘窗" checked:NO]];
    [self.fourthSections addObject:[[OptionItem alloc] initOption:@"榻榻米" checked:YES]];
    [self.fourthSections addObject:[[OptionItem alloc] initOption:@"家庭工作区" checked:NO]];
    [self.fourthSections addObject:[[OptionItem alloc] initOption:@"装修经验" checked:NO]];
    [self.fourthSections addObject:[[OptionItem alloc] initOption:@"生活技能" checked:NO]];
    [self.fourthSections addObject:[[OptionItem alloc] initOption:@"大家的家" checked:NO]];
}

#pragma mark - Actions

- (void)toSaveAction {
    [self.navigationController popViewControllerAnimated:YES];
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
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SubManageCell *cell;
    if ([self.nameList[indexPath.section] isEqualToString:@"cell_0"]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellUsedStr[indexPath.section] forIndexPath:indexPath];
        cell.theme = self.firstSections[indexPath.item];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_1"]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellUsedStr[indexPath.section] forIndexPath:indexPath];
        cell.theme = self.secondSections[indexPath.item];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_2"]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellUsedStr[indexPath.section] forIndexPath:indexPath];
        cell.theme = self.thirdSections[indexPath.item];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_3"]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellUsedStr[indexPath.section] forIndexPath:indexPath];
        cell.theme = self.fourthSections[indexPath.item];
    }
    cell.delegate = self;

    return cell;
}

//返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:cellHeaderStr[indexPath.section] forIndexPath:indexPath];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, 60, 20)];
        label.textColor = RGB(51, 51, 51);
        label.font = [UIFont systemFontOfSize:12];
        [header addSubview:label];
        
        if ([self.nameList[indexPath.section] isEqualToString:@"cell_0"]) {
            label.text = @"空间";
        } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_1"]) {
            label.text = @"硬装";
        } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_2"]) {
            label.text = @"软装";
        } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_3"]) {
            label.text = @"热门";
        }
        
        return header;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

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
    OptionItem *theme;
    if ([self.nameList[indexPath.section] isEqualToString:@"cell_0"]) {
        theme = self.firstSections[indexPath.row];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_1"]) {
        theme = self.secondSections[indexPath.row];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_2"]) {
        theme = self.thirdSections[indexPath.row];
    } else if ([self.nameList[indexPath.section] isEqualToString:@"cell_3"]) {
        theme = self.fourthSections[indexPath.row];
    }
    CGSize titleSize = [theme.title boundingRectWithSize:CGSizeMake(MAXFLOAT, 36) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kCellTitleFontSize]} context:nil].size;
    return CGSizeMake(titleSize.width+12*2+12, titleSize.height+8*2);
}

#pragma mark - SubManageCellDelegate

- (void)didCheckedSub:(OptionItem *)theme {
    NSLog(@"%@ %@", theme.isChecked==true?@"订阅":@"取消订阅",theme.title);
}

@end
