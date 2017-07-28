//
//  NewsSettingViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/27.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "NewsSettingViewController.h"
#import "UserSection.h"

@interface NewsSettingViewController ()<UITableViewDataSource,UITableViewDelegate> {
    NSString *userNotification;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *fristSections;
@property (nonatomic, copy) NSArray *secondSections;
@property (nonatomic, strong) NSMutableArray *thirdSections;

@end

@implementation NewsSettingViewController

@synthesize title;

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
        userNotification = @"已关闭";
    } else {
        userNotification = @"已开启";
    }
//    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData

- (void)initData {
    self.fristSections = @[
                           @"接受新消息通知"
                           ];
    self.secondSections = @[
                            @"声音提醒",
                            @"震动提醒"
                            ];
    
    self.thirdSections = [[NSMutableArray alloc] init];

    UserSection *section0 = [[UserSection alloc] init];
    section0.textLabel = @"被关注提醒";
    section0.detailTextLabel = @"任何人";
    [self.thirdSections addObject:section0];
    UserSection *section1 = [[UserSection alloc] init];
    section1.textLabel = @"被点赞提醒";
    section1.detailTextLabel = @"任何人";
    [self.thirdSections addObject:section1];
    UserSection *section2 = [[UserSection alloc] init];
    section2.textLabel = @"被评论提醒";
    section2.detailTextLabel = @"任何人";
    [self.thirdSections addObject:section2];
    UserSection *section3 = [[UserSection alloc] init];
    section3.textLabel = @"被收藏提醒";
    section3.detailTextLabel = @"任何人";
    [self.thirdSections addObject:section3];
}

#pragma mark - initSubViews

- (void)initSubViews {
    self.navigationItem.title = self.title;
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.fristSections.count;
    } else if (section == 1) {
        return self.secondSections.count;
    } else {
        return self.thirdSections.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"NewsCellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIndentifier];
        
        //separator
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(12, 43, ScreenWidth-12*2, 1)];
        separatorView.backgroundColor = TableView_Separator;
        [cell addSubview:separatorView];
    }
    
    NSInteger section = indexPath.section;
    
    cell.textLabel.textColor = RGB(121, 121, 121);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    if (section == 0) {
        cell.textLabel.text = self.fristSections[indexPath.row];
        cell.detailTextLabel.text = userNotification;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (section == 1) {
        cell.textLabel.text = self.secondSections[indexPath.row];
        if (indexPath.row == 0) {
            UISwitch *soundSwitch = [[UISwitch alloc] init];
            soundSwitch.frame = CGRectMake(0, 0, 48, 36);
            soundSwitch.onTintColor = App_Theme_Color;
            cell.accessoryView = soundSwitch;
        } else {
            UISwitch *shockSwitch = [[UISwitch alloc] init];
            shockSwitch.frame = CGRectMake(0, 0, 48, 36);
            shockSwitch.onTintColor = App_Theme_Color;
            cell.accessoryView = shockSwitch;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (section == 2){
        UserSection *userSection = self.thirdSections[indexPath.row];
        cell.textLabel.text = userSection.textLabel;
        cell.detailTextLabel.text = userSection.detailTextLabel;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 44.0;
    } else if (section == 1) {
        return 44.0;
    }
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    if (section == 0) {
        UILabel *hintLabel = [[UILabel alloc] init];
        hintLabel.frame = CGRectMake(12, 0, ScreenWidth-12*2, 44);
        hintLabel.text = @"要开启或停用「好好住」的消息通知，请在iPhone的「设置」-「通知」-「好好住」中进行更改";
        hintLabel.textColor = [UIColor lightGrayColor];
        hintLabel.font = [UIFont systemFontOfSize:12];
        hintLabel.numberOfLines = 0;
        hintLabel.textAlignment = NSTextAlignmentLeft;
        [view addSubview:hintLabel];
    }
    return view;
}

@end
