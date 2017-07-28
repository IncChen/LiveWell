//
//  UserDetailViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/19.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "UserDetailViewController.h"
#import "UserSection.h"
#import "UserNameViewController.h"
#import "SexPickerView.h"
#import "CityPickerView.h"
#import "DatePickerView.h"
#import "UserProfileViewController.h"

@interface UserDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation UserDetailViewController

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
    self.navigationItem.title = self.title;
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}


#pragma mark - Private method

- (void)loadData {
    self.sections = [[NSMutableArray alloc] init];
    
    UserSection *section0 = [[UserSection alloc] init];
    section0.imageName = @"icon_nick";
    section0.textLabel = @"昵称";
    section0.detailTextLabel = @"Tesco";
    [self.sections addObject:section0];
    UserSection *section1 = [[UserSection alloc] init];
    section1.imageName = @"icon_sex";
    section1.textLabel = @"性别";
    section1.detailTextLabel = @"男";
    [self.sections addObject:section1];
    UserSection *section2 = [[UserSection alloc] init];
    section2.imageName = @"icon_location";
    section2.textLabel = @"位置";
    section2.detailTextLabel = @"广东 深圳";
    [self.sections addObject:section2];
    UserSection *section3 = [[UserSection alloc] init];
    section3.imageName = @"icon_birthday";
    section3.textLabel = @"生日";
    section3.detailTextLabel = @"1991-09-09";
    [self.sections addObject:section3];
    UserSection *section4 = [[UserSection alloc] init];
    section4.imageName = @"icon_profile";
    section4.textLabel = @"个人简介";
    section4.detailTextLabel = @"";
    [self.sections addObject:section4];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.sections.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UserDetailCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        if (indexPath.section == 0) {
            UIImageView *avatarIv = [[UIImageView alloc] init];
            avatarIv.frame = CGRectMake(ScreenWidth/2.0-54/2.0, 160/2.0-64/2.0, 64, 64);
            avatarIv.backgroundColor = [UIColor clearColor];
            avatarIv.image = [UIImage imageNamed:@"icon_user_avatar"];
            avatarIv.layer.cornerRadius = avatarIv.frame.size.width/2.0;//裁成圆角
            avatarIv.layer.masksToBounds = YES;//隐藏裁剪掉的部分
            avatarIv.tag = 101;
            [cell addSubview:avatarIv];
        } else {
            //separator
            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(12, 43, ScreenWidth-12*2, 1)];
            separatorView.backgroundColor = TableView_Separator;
            [cell addSubview:separatorView];
        }
    }
    if (indexPath.section == 0) {
        //UIImageView *avatarIv = (UIImageView *)[cell viewWithTag:101];
    } else {
        UserSection *userSection = self.sections[indexPath.row];
        
        cell.imageView.image = [UIImage imageNamed:userSection.imageName];
        
        cell.textLabel.text = userSection.textLabel;
        cell.textLabel.textColor = RGB(51, 51, 51);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.text = userSection.detailTextLabel;
        cell.detailTextLabel.textColor = RGB(51, 51, 51);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *arrowIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        arrowIv.image = [UIImage imageNamed:@"icon_right"];
        cell.accessoryView = arrowIv;
        
        if (indexPath.row == self.sections.count-1) {
            //个人简介
            if ([userSection.detailTextLabel isEqual:[NSNull null]]
                || userSection.detailTextLabel == nil
                || userSection.detailTextLabel.length == 0) {
                cell.detailTextLabel.text = @"未填写";
                cell.detailTextLabel.textColor = RGB(181, 181, 181);
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 160.0;
    } else {
        return 44.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UserSection *userSection = self.sections[indexPath.row];
        switch (indexPath.row) {
            case 0: {
                UserNameViewController *viewController = [[UserNameViewController alloc] init];
                viewController.name = userSection.detailTextLabel;
                [self.navigationController pushViewController:viewController animated:YES];
            }   break;
            case 1: {
                SexPickerView *sexOption = [[SexPickerView alloc] initWithSex:userSection.detailTextLabel];
                [[sexOption setupOption:^(NSString *content) {
                    userSection.detailTextLabel = content;
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }] option_show];
            }   break;
            case 2: {
                NSArray *array = [userSection.detailTextLabel componentsSeparatedByString:@" "];
                NSString *province = nil;
                if (array.count > 0) {
                    province = array[0];
                }
                NSString *city = nil;
                if (array.count > 1) {
                    city = array[1];
                }
                CityPickerView *cityOption = [[CityPickerView alloc] initWithProvince:province city:city];
                [[cityOption setupOption:^(NSString *content) {
                    userSection.detailTextLabel = content;
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }] option_show];
            }   break;
            case 3: {
                NSArray *array = [userSection.detailTextLabel componentsSeparatedByString:@"-"];
                NSString *year = nil;
                if (array.count > 0) {
                    year = array[0];
                }
                NSString *month = nil;
                if (array.count > 1) {
                    month = array[1];
                }
                NSString *day = nil;
                if (array.count > 2) {
                    day = array[2];
                }
                DatePickerView *dateOption = [[DatePickerView alloc] initWithYear:year month:month day:day];
                [[dateOption setupOption:^(NSString *content) {
                    userSection.detailTextLabel = content;
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }] option_show];
            }   break;
            case 4: {
                UserProfileViewController *viewController = [[UserProfileViewController alloc] init];
                viewController.profile = userSection.detailTextLabel;
                [self.navigationController pushViewController:viewController animated:YES];
            }   break;
            default:
                break;
        }

    }
}

@end
