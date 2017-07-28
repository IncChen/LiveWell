//
//  ReportViewController.m
//  LiveWell
//
//  Created by Mark on 2017/7/14.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportNoticeViewController.h"

@interface ReportViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSArray *sections;

@end

@implementation ReportViewController

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
    self.navigationItem.title = @"我要举报";
    
    UIBarButtonItem *sendBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(toSendAction)];
    self.navigationItem.rightBarButtonItem = sendBtn;
//    self.navigationItem.rightBarButtonItem.tintColor = Text_Color;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], UITextAttributeFont, RGB(51, 51, 51), UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}

#pragma mark - Private method

- (void)initData {
    self.index = 0;
    self.sections = @[
                      @"图片盗用",
                      @"广告骚扰",
                      @"人身攻击",
                      @"政治敏感",
                      @"侵权举报（诽谤、抄袭、冒用等）",
                      @"违法信息（暴力恐怖、违禁品等）",
                      @"其它"
                      ];
}

#pragma mark - Actions

- (void)toSendAction {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ReportCellIndentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //separator
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(12, 43, ScreenWidth-12*2, 1)];
        separatorView.backgroundColor = TableView_Separator;
        [cell addSubview:separatorView];
    }
    
    if (self.index == indexPath.row) {
        cell.imageView.image = [UIImage imageNamed:@"icon_cog_sex_s"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"icon_cog_sex_n"];
    }
    
    cell.textLabel.text = self.sections[indexPath.row];
    cell.textLabel.textColor = RGB(51, 51, 51);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 58.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    self.tableView.tableHeaderView = view;
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.frame = CGRectMake(12, 14, 100, 40);
    hintLabel.text = @"举报原因：";
    hintLabel.textColor = RGB(181, 181, 181);
    hintLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:hintLabel];
    
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    reportBtn.frame = CGRectMake(ScreenWidth-64-12, 18, 64, 40);
    reportBtn.backgroundColor = [UIColor clearColor];
    [reportBtn setTitle:@"举报须知" forState:UIControlStateNormal];
    [reportBtn setTintColor:App_Theme_Color];
    reportBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [reportBtn addTarget:self action:@selector(toReportNoticeAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:reportBtn];
    
    UIView *separator = [[UIView alloc] init];
    separator.frame = CGRectMake(12, 49, ScreenWidth-12*2, 1);
    separator.backgroundColor = TableView_Separator;
    [view addSubview:separator];
    
    return view;
}

- (void)toReportNoticeAction {
    ReportNoticeViewController *viewController = [[ReportNoticeViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 160.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    
    self.tableView.tableFooterView = view;
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.frame = CGRectMake(12, 18, 100, 40);
    hintLabel.text = @"补充说明：";
    hintLabel.textColor = RGB(181, 181, 181);
    hintLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:hintLabel];
    
    
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.index = indexPath.row;
    [self.tableView reloadData];
}

@end
