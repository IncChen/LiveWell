//
//  UserSafetyViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/21.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "UserSafetyViewController.h"
#import "UserSection.h"
#import "JXTAlertManagerHeader.h"

#define Text_Color RGB(51, 51, 51)

@interface UserSafetyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation UserSafetyViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViews];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initSubViews

- (void)initSubViews {
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)loadData {
    self.sections = [[NSMutableArray alloc] init];
    
    UserSection *section0 = [[UserSection alloc] init];
    section0.textLabel = @"修改手机号";
    section0.detailTextLabel = @"12345";
    [self.sections addObject:section0];
    UserSection *section1 = [[UserSection alloc] init];
    section1.textLabel = @"修改密码";
    section1.detailTextLabel = @"";
    [self.sections addObject:section1];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UserSafetyCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        //separator
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(12, 43, ScreenWidth-12*2, 1)];
        separatorView.backgroundColor = TableView_Separator;
        [cell addSubview:separatorView];
    }
    
    UserSection *userSection = self.sections[indexPath.row];
    
    cell.textLabel.text = userSection.textLabel;
    cell.textLabel.textColor = RGB(51, 51, 51);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = userSection.detailTextLabel;
    cell.detailTextLabel.textColor = RGB(51, 51, 51);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            [self jxt_showAlertWithTitle:nil message:@"是否更换手机号" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.
                addActionCancelTitle(@"取消").
                addActionDestructiveTitle(@"更换");
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                if (buttonIndex == 0) {
                    //Cancel
                } else if (buttonIndex == 1) {
                    
                }
            }];
        }   break;
        case 1: {
            //修改密码
        }
        default:
            break;
    }
}

@end
