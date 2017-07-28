//
//  UserSettingViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/19.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "UserSettingViewController.h"
#import "LoginViewController.h"
#import "UserDetailViewController.h"
#import "UserSafetyViewController.h"
#import "NewsSettingViewController.h"

@interface UserSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *fristSections;
@property (nonatomic, copy) NSArray *secondSections;

@end

@implementation UserSettingViewController

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

#pragma mark - initData

- (void)initData {
    self.fristSections = @[
                           @"编辑个人资料",
                           @"帐号与安全",
                           @"黑名单",
                           @"消息设置"
                           ];
    self.secondSections = @[
                            @"退出登录"
                            ];
}

#pragma mark - initSubViews

- (void)initSubViews {
    self.navigationItem.title = @"设置";
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.fristSections.count;
    } else {
        return self.secondSections.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"SettingCellIndentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        
        if (indexPath.section == 0) {
            if (indexPath.row < 3) {
                //separator
                UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(12, 43, ScreenWidth-12*2, 1)];
                separatorView.backgroundColor = TableView_Separator;
                [cell addSubview:separatorView];
            }
        }
    }
    
    NSInteger section = indexPath.section;
    if (section == 0) {
        cell.textLabel.text = self.fristSections[indexPath.row];
        cell.textLabel.textColor = RGB(121, 121, 121);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.textLabel.text = self.secondSections[indexPath.row];
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置选中cell时不变色
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 8.0;
    } else {
        return 12.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                //编辑个人资料
                UserDetailViewController *viewController = [[UserDetailViewController alloc] init];
                viewController.title = self.fristSections[indexPath.row];
                [self.navigationController pushViewController:viewController animated:YES];
            }   break;
            case 1: {
                //帐号与安全
                UserSafetyViewController *viewController = [[UserSafetyViewController alloc] init];
                viewController.title = self.fristSections[indexPath.row];
                [self.navigationController pushViewController:viewController animated:YES];
            }   break;
            case 2: {
                //黑名单
            }   break;
            case 3: {
                //消息设置
                NewsSettingViewController *viewController = [[NewsSettingViewController alloc] init];
                viewController.title = self.fristSections[indexPath.row];
                [self.navigationController pushViewController:viewController animated:YES];
            }   break;
            default:
                break;
        }
    } else {
        //退出登录
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setObject:@"" forKey:User_Def_Phone];
        [userDef synchronize];
        
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

@end
