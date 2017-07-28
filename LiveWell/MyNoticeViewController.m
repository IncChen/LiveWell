//
//  MyNoticeViewController.m
//  LiveWell
//
//  Created by Mark on 2017/7/20.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "MyNoticeViewController.h"
#import "UserSection.h"
#import <MJRefresh.h>

@interface MyNoticeViewController ()

@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation MyNoticeViewController

#pragma mark - Getter

- (NSMutableArray *)sections {
    if (_sections == nil) {
        _sections = [[NSMutableArray alloc] init];
    }
    return _sections;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(245, 245, 245);
    
//    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSArray *idleImages = @[
                            [UIImage imageNamed:@"loding00"]
                            ];
    NSArray *refreshingImages = @[
                                  [UIImage imageNamed:@"loding01"],
                                  [UIImage imageNamed:@"loding02"],
                                  [UIImage imageNamed:@"loding03"]
                                  ];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(sendRequest)];
    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    [self.sections addObject:[[UserSection alloc] initSectionImage:@"icon_item_comment" text:@"评论" detailText:@"没有新的消息"]];
    [self.sections addObject:[[UserSection alloc] initSectionImage:@"icon_item_sub" text:@"关注" detailText:@"没有新的消息"]];
    [self.sections addObject:[[UserSection alloc] initSectionImage:@"icon_item_like" text:@"点赞" detailText:@"没有新的消息"]];
    [self.sections addObject:[[UserSection alloc] initSectionImage:@"icon_item_coll" text:@"收藏" detailText:@"没有新的消息"]];
    [self.sections addObject:[[UserSection alloc] initSectionImage:@"icon_item_topic" text:@"话题" detailText:@"没有新的消息"]];
}

- (void)sendRequest {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyNoticeCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        //separator
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 46, tableView.frame.size.width, 4)];
        separatorView.backgroundColor = self.view.backgroundColor;
        [cell addSubview:separatorView];
    }
    
    UserSection *userSection = self.sections[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:userSection.imageName];
    
    cell.textLabel.text = userSection.textLabel;
    cell.textLabel.textColor = RGB(51, 51, 51);
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.text = userSection.detailTextLabel;
    cell.detailTextLabel.textColor = RGB(184, 184, 184);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView *arrowIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    arrowIv.image = [UIImage imageNamed:@"icon_right"];
    cell.accessoryView = arrowIv;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
