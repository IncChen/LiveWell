//
//  UserViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/16.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "UserViewController.h"
#import "UserSection.h"
#import "UserSettingViewController.h"
#import "CounterfeitNavBarView.h"
#import "UserDynamicViewController.h"
#import "ArticleDraftViewController.h"
#import "CollectionPicViewController.h"
#import "CollectionArticleViewController.h"
#import "CollectionReplyViewController.h"
#import "AttentionTopicViewController.h"
#import "SubManageViewController.h"
#import "DecorationStateViewController.h"
#import "ScanQRCodeViewController.h"
#import "PushTransition.h"
#import "iToast.h"
#import "AboutViewController.h"

#define kSpacing ScreenWidth*1.5/26.5

#define Row_Article_Draft 0

#define Row_Collection_Picture 0
#define Row_Collection_Article 1
#define Row_Collection_Answer  2

#define Row_Attention_Topic 0
#define Row_Sub_Management  1

#define Row_Decoration_State 0
#define Row_Scan_QRcode      1
#define Row_Account_Upgrade  2
#define Row_Share_App        3
#define Row_Help_Feedback    4
#define Row_Clear_Cache      5
#define Row_Encourage        6
#define Row_About_App        7

static const CGFloat kSectionHeaderHeight = 226.f;
static const CGFloat kNavigationBarHeight = 56.f;

@interface UserViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,DecorationStateDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CounterfeitNavBarView *navBarView;
@property (strong, nonatomic) PushTransition *pushAnimation;

@property (nonatomic, strong) NSMutableArray *firstSections;
@property (nonatomic, strong) NSMutableArray *secondSections;
@property (nonatomic, strong) NSMutableArray *thirdSections;
@property (nonatomic, strong) NSMutableArray *fourthSections;

@end

@implementation UserViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViews];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initializes attributes

-(PushTransition *)pushAnimation {
    if (!_pushAnimation) {
        _pushAnimation = [[PushTransition alloc] init];
    }
    return _pushAnimation;
}

#pragma mark - initSubViews

- (void)initSubViews {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_scrollView];
    _scrollView.clipsToBounds = NO;
    _scrollView.delegate = self;
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabBarControllerHeight);
    _tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _navBarView = [[CounterfeitNavBarView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kNavigationBarHeight)];
    _navBarView.titleLab.text = @"";
    _navBarView.titleLab.textColor = [UIColor blackColor];
    _navBarView.titleLab.font = [UIFont systemFontOfSize:15];
    [_navBarView.rightBtn setImage:[UIImage imageNamed:@"icon_white_cog"] forState:UIControlStateNormal];
    __unsafe_unretained UserViewController *weakSelf = self;
    _navBarView.rightBtnTapAction = ^() {
        UserSettingViewController *viewController = [[UserSettingViewController alloc] init];
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    };
    [self.view addSubview:_navBarView];
}

#pragma mark - Private method

- (void)loadData {
    self.firstSections = [[NSMutableArray alloc] init];
    
    UserSection *section0_0 = [[UserSection alloc] init];
    section0_0.row = Row_Article_Draft;
    section0_0.textLabel = @"文章草稿";
    section0_0.detailTextLabel = @"0";
    [self.firstSections addObject:section0_0];
    
    self.secondSections = [[NSMutableArray alloc] init];
    
    UserSection *section1_0 = [[UserSection alloc] init];
    section1_0.row = Row_Collection_Picture;
    section1_0.textLabel = @"收藏的图片";
    section1_0.detailTextLabel = @"0";
    [self.secondSections addObject:section1_0];
    UserSection *section1_1 = [[UserSection alloc] init];
    section1_1.row = Row_Collection_Article;
    section1_1.textLabel = @"收藏的文章";
    section1_1.detailTextLabel = @"0";
    [self.secondSections addObject:section1_1];
    UserSection *section1_2 = [[UserSection alloc] init];
    section1_2.row = Row_Collection_Answer;
    section1_2.textLabel = @"收藏的回答";
    section1_2.detailTextLabel = @"0";
    [self.secondSections addObject:section1_2];
    
    self.thirdSections = [[NSMutableArray alloc] init];
    
    UserSection *section2_0 = [[UserSection alloc] init];
    section2_0.row = Row_Attention_Topic;
    section2_0.textLabel = @"关注的话题";
    section2_0.detailTextLabel = @"0";
    [self.thirdSections addObject:section2_0];
    UserSection *section2_1 = [[UserSection alloc] init];
    section2_1.row = Row_Sub_Management;
    section2_1.textLabel = @"订阅管理";
    section2_1.detailTextLabel = @"";
    [self.thirdSections addObject:section2_1];
    
    self.fourthSections = [[NSMutableArray alloc] init];
    
    UserSection *section3_0 = [[UserSection alloc] init];
    section3_0.row = Row_Decoration_State;
    section3_0.textLabel = @"我的装修状态";
    section3_0.detailTextLabel = @"暂无装修计划";
    [self.fourthSections addObject:section3_0];
    UserSection *section3_1 = [[UserSection alloc] init];
    section3_1.row = Row_Scan_QRcode;
    section3_1.textLabel = @"扫一扫";
    section3_1.detailTextLabel = @"";
    [self.fourthSections addObject:section3_1];
    UserSection *section3_2 = [[UserSection alloc] init];
    section3_2.row = Row_Account_Upgrade;
    section3_2.textLabel = @"帐号升级";
    section3_2.detailTextLabel = @"";
    [self.fourthSections addObject:section3_2];
    UserSection *section3_3 = [[UserSection alloc] init];
    section3_3.row = Row_Share_App;
    section3_3.textLabel = @"推荐「好好住」给好友";
    section3_3.detailTextLabel = @"";
    [self.fourthSections addObject:section3_3];
    UserSection *section3_4 = [[UserSection alloc] init];
    section3_4.row = Row_Help_Feedback;
    section3_4.textLabel = @"帮助与反馈";
    section3_4.detailTextLabel = @"";
    [self.fourthSections addObject:section3_4];
    UserSection *section3_5 = [[UserSection alloc] init];
    section3_5.row = Row_Clear_Cache;
    section3_5.textLabel = @"清除缓存";
    section3_5.detailTextLabel = @"739KB";
    [self.fourthSections addObject:section3_5];
    UserSection *section3_6 = [[UserSection alloc] init];
    section3_6.row = Row_Encourage;
    section3_6.textLabel = @"喜欢我们，打分鼓励一下";
    section3_6.detailTextLabel = @"";
    [self.fourthSections addObject:section3_6];
    UserSection *section3_7 = [[UserSection alloc] init];
    section3_7.row = Row_About_App;
    section3_7.textLabel = @"关于好好住";
    section3_7.detailTextLabel = @"";
    [self.fourthSections addObject:section3_7];
}

#pragma mark - Actions

- (void)toSettingAction {
    UserSettingViewController *viewController = [[UserSettingViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)toUserDynamicAction {
    UserDynamicViewController *viewController = [[UserDynamicViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetY = scrollView.contentOffset.y;
    
    if (offSetY<=0.f && offSetY>= -80.f) {
        _scrollView.contentOffset = CGPointMake(0, offSetY/2);
    } else if (offSetY < -80.f) {
        [_tableView setContentOffset:CGPointMake(0, -80.f)];
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
            [_navBarView.rightBtn setImage:[UIImage imageNamed:@"icon_white_cog"] forState:UIControlStateNormal];
        } else {
            _navBarView.lineView.hidden = NO;
            _navBarView.titleLab.text = @"我的";
            [_navBarView.rightBtn setImage:[UIImage imageNamed:@"icon_setting_black"] forState:UIControlStateNormal];
        }
        _navBarView.backgroundView.backgroundColor = RGBA(255, 255, 255, alpha);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.firstSections.count;
    } else if (section == 1) {
        return self.secondSections.count;
    } else if (section == 2) {
        return self.thirdSections.count;
    } else {
        return self.fourthSections.count;
    }
}

- (UIView *)drawSeparator {
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(12, 43, ScreenWidth-12*2, 1)];
    separatorView.backgroundColor = TableView_Separator;
    return separatorView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UserCellIndentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        if (indexPath.section == 1) {
            if (indexPath.row != Row_Collection_Answer) {
                [cell addSubview:[self drawSeparator]];
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row != Row_Sub_Management) {
                [cell addSubview:[self drawSeparator]];
            }
        } else if (indexPath.section == 3) {
            if (indexPath.row != Row_About_App) {
                [cell addSubview:[self drawSeparator]];
            }
        }
    }
    
    cell.textLabel.textColor = RGB(121, 121, 121);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    NSInteger section = indexPath.section;
    if (section == 0) {
        UserSection *userSection = self.firstSections[indexPath.row];
        cell.textLabel.text = userSection.textLabel;
        cell.detailTextLabel.text = userSection.detailTextLabel;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (section == 1) {
        UserSection *userSection = self.secondSections[indexPath.row];
        cell.textLabel.text = userSection.textLabel;
        cell.detailTextLabel.text = userSection.detailTextLabel;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (section == 2) {
        UserSection *userSection = self.thirdSections[indexPath.row];
        cell.textLabel.text = userSection.textLabel;
        cell.detailTextLabel.text = userSection.detailTextLabel;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (section == 3) {
        UserSection *userSection = self.fourthSections[indexPath.row];
        cell.textLabel.text = userSection.textLabel;
        if (indexPath.row == Row_Decoration_State
            || indexPath.row == Row_Clear_Cache) {
            cell.detailTextLabel.text = userSection.detailTextLabel;
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.detailTextLabel.textColor = RGB(181, 181, 181);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置选中cell时不变色
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? kSectionHeaderHeight : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    tableView.tableHeaderView = headerView;//防止上滑时headerView盖住cell
    
    UIView *colorVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kSectionHeaderHeight-10)];
    colorVeiw.backgroundColor = App_Theme_Color;
    [headerView addSubview:colorVeiw];
    
    //用户头像
    UIImageView *avatarIv = [[UIImageView alloc] init];
    avatarIv.frame = CGRectMake(kSpacing, 56, 64, 64);
    avatarIv.backgroundColor = [UIColor clearColor];
    avatarIv.image = [UIImage imageNamed:@"icon_user_avatar"];
    avatarIv.layer.cornerRadius = avatarIv.frame.size.width/2.0;//裁成圆角
    avatarIv.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    [headerView addSubview:avatarIv];
    //用户昵称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(CGRectGetMaxX(avatarIv.frame)+6, avatarIv.frame.origin.y+12, 200, 21);
    nameLabel.text = @"用户昵称";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:nameLabel];
    //关注
    UILabel *idolLabel = [[UILabel alloc] init];
    idolLabel.frame = CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+4, 72, 18);
    idolLabel.text = @"关注 4";
    idolLabel.textColor = [UIColor whiteColor];
    idolLabel.font = [UIFont systemFontOfSize:13];
    [idolLabel sizeToFit];
    [headerView addSubview:idolLabel];
    //被关注
    UILabel *fansLabel = [[UILabel alloc] init];
    fansLabel.frame = CGRectMake(CGRectGetMaxX(idolLabel.frame)+16, idolLabel.frame.origin.y, 72, 18);
    fansLabel.text = @"被关注 0";
    fansLabel.textColor = [UIColor whiteColor];
    fansLabel.font = [UIFont systemFontOfSize:13];
    [fansLabel sizeToFit];
    [headerView addSubview:fansLabel];
    //箭头button
    UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowBtn.frame = CGRectMake(ScreenWidth-kSpacing-36, avatarIv.frame.origin.y+avatarIv.frame.size.height/2.0-12, 24, 24);
    arrowBtn.backgroundColor = [UIColor clearColor];
    [arrowBtn setImage:[UIImage imageNamed:@"icon_arrow_white"] forState:UIControlStateNormal];
    [arrowBtn addTarget:self action:@selector(toUserDynamicAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:arrowBtn];
    
    //分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kSpacing, CGRectGetMaxY(avatarIv.frame)+20, ScreenWidth-kSpacing*2, 0.6)];
    line.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:line];
    
    //图片
    UIButton *pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pictureBtn.frame = CGRectMake(kSpacing+20, CGRectGetMaxY(line.frame)+6, 48, 50);
    pictureBtn.backgroundColor = [UIColor clearColor];
    [pictureBtn setTitle:@"0" forState:UIControlStateNormal];
    [pictureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pictureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:pictureBtn];
    //
    UILabel *pictureLabel = [[UILabel alloc] init];
    pictureLabel.frame = CGRectMake(pictureBtn.frame.origin.x, CGRectGetMaxY(pictureBtn.frame)-18+8, pictureBtn.frame.size.width, 18);
    pictureLabel.text = @"图片";
    pictureLabel.textColor = [UIColor whiteColor];
    pictureLabel.font = [UIFont systemFontOfSize:12];
    pictureLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:pictureLabel];
    
    //文章
    UIButton *articleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    articleBtn.frame = CGRectMake(ScreenWidth/2.0-48/2.0, pictureBtn.frame.origin.y, 48, 50);
    articleBtn.backgroundColor = [UIColor clearColor];
    [articleBtn setTitle:@"0" forState:UIControlStateNormal];
    [articleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    articleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:articleBtn];
    //
    UILabel *articleLabel = [[UILabel alloc] init];
    articleLabel.frame = CGRectMake(articleBtn.frame.origin.x, CGRectGetMaxY(articleBtn.frame)-18+8, articleBtn.frame.size.width, 18);
    articleLabel.text = @"文章";
    articleLabel.textColor = [UIColor whiteColor];
    articleLabel.font = [UIFont systemFontOfSize:12];
    articleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:articleLabel];
    
    //回答
    UIButton *answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    answerBtn.frame = CGRectMake(ScreenWidth-48-20-kSpacing, pictureBtn.frame.origin.y, 48, 50);
    answerBtn.backgroundColor = [UIColor clearColor];
    [answerBtn setTitle:@"0" forState:UIControlStateNormal];
    [answerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    answerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:answerBtn];
    //
    UILabel *answerLabel = [[UILabel alloc] init];
    answerLabel.frame = CGRectMake(answerBtn.frame.origin.x, CGRectGetMaxY(answerBtn.frame)-18+8, answerBtn.frame.size.width, 18);
    answerLabel.text = @"回答";
    answerLabel.textColor = [UIColor whiteColor];
    answerLabel.font = [UIFont systemFontOfSize:12];
    answerLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:answerLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView* )tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            //文章草稿
            ArticleDraftViewController *viewController = [[ArticleDraftViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }   break;
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    //收藏的图片
                    CollectionPicViewController *viewController = [[CollectionPicViewController alloc] init];
                    [self.navigationController pushViewController:viewController animated:YES];
                }   break;
                case 1: {
                    //收藏的文章
                    CollectionArticleViewController *viewController = [[CollectionArticleViewController alloc] init];
                    [self.navigationController pushViewController:viewController animated:YES];
                }   break;
                case 2: {
                    //收藏的回答
                    CollectionReplyViewController *viewController = [[CollectionReplyViewController alloc] init];
                    [self.navigationController pushViewController:viewController animated:YES];
                }   break;
                default:
                    break;
            }
        }   break;
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    //关注的话题
                    AttentionTopicViewController *viewController = [[AttentionTopicViewController alloc] init];
                    [self.navigationController pushViewController:viewController animated:YES];
                }   break;
                case 1: {
                    //订阅管理
                    SubManageViewController *viewController = [[SubManageViewController alloc] init];
                    [self.navigationController pushViewController:viewController animated:YES];
                }   break;
                default:
                    break;
            }
        }   break;
        case 3: {
            UserSection *userSection = self.fourthSections[indexPath.row];
            switch (indexPath.row) {
                case 0: {
                    //我的装修状态
                    DecorationStateViewController *viewController = [[DecorationStateViewController alloc] init];
                    viewController.state = userSection.detailTextLabel;
                    viewController.delegate = self;
                    [self.navigationController pushViewController:viewController animated:YES];
                }   break;
                case 1: {
                    //扫一扫
                    ScanQRCodeViewController *viewController = [[ScanQRCodeViewController alloc] init];
                    [self presentViewController:viewController animated:YES completion:nil];
                }   break;
                case 2: {
                    //帐号升级
                    [[iToast makeText:userSection.textLabel] show];
                }   break;
                case 3: {
                    //推荐给好友
                    [[iToast makeText:userSection.textLabel] show];
                }   break;
                case 4: {
                    //帮助与反馈
                    [[iToast makeText:userSection.textLabel] show];
                }   break;
                case 5: {
                    //清除缓存
                    
                }   break;
                case 6: {
                    //打分鼓励
                    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/%E5%A5%BD%E5%A5%BD%E4%BD%8F-%E4%BD%A0%E7%9A%84%E5%AE%B6%E5%B1%85%E8%A3%85%E4%BF%AE%E6%8C%87%E5%8D%97/id1063631937?mt=8"];
                    [[UIApplication sharedApplication] openURL:url];
                }   break;
                case 7: {
                    //关于
                    AboutViewController *viewController = [[AboutViewController alloc] init];
                    [self.navigationController pushViewController:viewController animated:YES];
                }   break;
                default:
                    break;
            }
        }   break;
        default:
            break;
    }
}

#pragma mark - DecorationStateDelegate

- (void)didSelectState:(NSString *)state {
    UserSection *userSection = self.fourthSections[0];
    userSection.detailTextLabel = state;
    [self.fourthSections replaceObjectAtIndex:0 withObject:userSection];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:3], nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UINavigationControllerDelegate
/** 返回转场动画实例*/
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if ([toVC isKindOfClass:[ScanQRCodeViewController class]]) {
        if (operation == UINavigationControllerOperationPush) {
            return self.pushAnimation;
        }
    }

    return nil;
}

@end
