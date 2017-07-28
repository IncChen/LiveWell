//
//  AboutViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/30.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "AboutViewController.h"
#import "UserAgreemenViewController.h"
#import "ComNormsViewController.h"
#import "ContactInfoViewController.h"

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *sections;

@end

@implementation AboutViewController

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
                      @"用户协议",
                      @"社区规范",
                      @"联系我们"
                      ];
}

#pragma mark - initSubViews

- (void)initSubViews {
    self.navigationItem.title = @"关于好好住";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"AboutCellIndentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(12, 43, ScreenWidth-12*2, 1)];
        separatorView.backgroundColor = TableView_Separator;
        [cell addSubview:separatorView];
    }
    
    cell.textLabel.text = self.sections[indexPath.row];
    cell.textLabel.textColor = RGB(121, 121, 121);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 120.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *logoIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_logo"]];
    CGFloat logoIvW = logoIv.image.size.width*0.8;
    CGFloat logoIvH = logoIv.image.size.height*0.8;
    logoIv.frame = CGRectMake(ScreenWidth/2.0-logoIvW/2.0, 20, logoIvW, logoIvH);
    [footerView addSubview:logoIv];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(logoIv.frame)+6, ScreenWidth-40, 18)];
    versionLabel.text = [NSString stringWithFormat:@"Version %@", appCurVersion];
    versionLabel.textColor = [UIColor lightGrayColor];
    versionLabel.font = [UIFont systemFontOfSize:10];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.numberOfLines = 1;
    [footerView addSubview:versionLabel];
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            //用户协议
            UserAgreemenViewController *viewController = [[UserAgreemenViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }   break;
        case 1: {
            //社区规范
            ComNormsViewController *viewController = [[ComNormsViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }   break;
        case 2: {
            //联系我们
            ContactInfoViewController *viewController = [[ContactInfoViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }   break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
