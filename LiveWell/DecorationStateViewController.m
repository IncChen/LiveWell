//
//  DecorationStateViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/28.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "DecorationStateViewController.h"

@interface DecorationStateViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSArray *sections;

@end

@implementation DecorationStateViewController

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
    self.sections = @[
                      @"暂无装修计划",
                      @"准备装修",
                      @"正在装修",
                      @"已经入住"
                      ];
    for (int i = 0; i < self.sections.count; i++) {
        NSString *section = self.sections[i];
        if (![section isEqualToString:self.state]) {
            continue;
        }
        self.index = i;
        break;
    }
    
}

#pragma mark - initSubViews

- (void)initSubViews {
    self.navigationItem.title = @"我的装修状态";
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return self.sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"StateCellIndentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        
        if (indexPath.row < 3) {
            //separator
            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(12, 43, ScreenWidth-12*2, 1)];
            separatorView.backgroundColor = TableView_Separator;
            [cell addSubview:separatorView];
        }
    }
    
    cell.textLabel.text = self.sections[indexPath.row];
    cell.textLabel.textColor = RGB(121, 121, 121);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == self.index) {
        cell.textLabel.textColor = App_Theme_Color;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UIImageView *markIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        markIv.image = [UIImage imageNamed:@"icon_cell_selected"];
        cell.accessoryView = markIv;
    } else {
        cell.textLabel.textColor = RGB(121, 121, 121);
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    tableView.tableHeaderView = headerView;

    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, 44)];
    hintLabel.text = @"选择现在的装修状态";
    hintLabel.textColor = RGB(121, 121, 121);
    hintLabel.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:hintLabel];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *state = self.sections[indexPath.row];
    if (self.delegate) {
        [self.delegate didSelectState:state];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
