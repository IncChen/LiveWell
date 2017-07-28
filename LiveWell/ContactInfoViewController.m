//
//  ContactInfoViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/30.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "ContactInfoViewController.h"
#import "UserSection.h"
#import "JXTAlertManagerHeader.h"
#import <MessageUI/MessageUI.h>

@interface ContactInfoViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation ContactInfoViewController

#pragma mark - Life cyele

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
    self.sections = [[NSMutableArray alloc] init];
    
    UserSection *section0 = [[UserSection alloc] init];
    section0.textLabel = @"联系电话";
    section0.detailTextLabel = @"400-867-8864";
    [self.sections addObject:section0];
    UserSection *section1 = [[UserSection alloc] init];
    section1.textLabel = @"联系邮箱";
    section1.detailTextLabel = @"hello@haohaozhu.com";
    [self.sections addObject:section1];
}

#pragma mark - initSubViews

- (void)initSubViews {
    self.navigationItem.title = @"联系我们";
    
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
    static NSString *CellIndentifier = @"InfoCellIndentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIndentifier];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(12, 43, ScreenWidth-12*2, 1)];
        separatorView.backgroundColor = TableView_Separator;
        [cell addSubview:separatorView];
    }
    
    UserSection *userSection = self.sections[indexPath.row];
    
    cell.textLabel.text = userSection.textLabel;
    cell.textLabel.textColor = RGB(121, 121, 121);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    cell.detailTextLabel.text = userSection.detailTextLabel;
    cell.detailTextLabel.textColor = App_Theme_Color;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSection *userSection = self.sections[indexPath.row];
    if (indexPath.row == 0) {
        //电话
        [self jxt_showActionSheetWithTitle:@"工作时间：09:00-20:00" message:userSection.detailTextLabel appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.
            addActionCancelTitle(@"我再想想").
            addActionDestructiveTitle(@"立刻联系");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if (buttonIndex == 0) {
                
            } else {
#ifdef test1
                UIWebView *callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:userSection.detailTextLabel]]];
                [self.view addSubview:callWebview];
#endif
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",userSection.detailTextLabel];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

            }
        }];
    } else {
        //邮箱
        MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
        if (!mailPicker) {
            // 在设备还没有添加邮件账户的时候mailViewController为空，下面的present view controller会导致程序崩溃，这里要作出判断
            NSLog(@"设备还没有添加邮件账户");
            return;
        }
        mailPicker.mailComposeDelegate = self;
        [mailPicker setSubject:@""]; //邮件主题
        [mailPicker setToRecipients:[NSArray arrayWithObjects:
                                     userSection.detailTextLabel,
                                     nil]];
        [self presentModalViewController:mailPicker animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    switch (result){
        case MFMailComposeResultCancelled:
            
            break;
        case MFMailComposeResultSaved:
            
            break;
        case MFMailComposeResultSent:
            
            break;
        case MFMailComposeResultFailed:
            
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
}

@end
