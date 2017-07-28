//
//  PicDetailViewController.m
//  LiveWell
//
//  Created by Mark on 2017/7/7.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "PicDetailViewController.h"
#import "FeatureButton.h"
#import "CommentStatusCell.h"
#import "FeatureButton.h"
#import "iToast.h"
#import "JXTAlertManagerHeader.h"
#import "TouchTableView.h"
#import "ReportViewController.h"

#define kStatusCellControlSpacing 12 //控件间距
#define kStatusCellFeatureBtnHeight 24

#define kStatusCellUserNameFontSize 11
#define kStatusCellCreateAtFontSize 10
#define kStatusCellContentFontSize 14

@interface PicDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,TouchTableViewDelegate> {
    BOOL isTouchReply;
}

@property (nonatomic, strong) TouchTableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UITextView *inputTv;
@property (nonatomic, strong) UILabel *inputHint;

@property (nonatomic, strong) NSMutableArray *nameList;//section数组名字
@property (nonatomic, strong) NSMutableArray *hotCommentCells;//存储cell，用于计算高度
@property (nonatomic, strong) NSMutableArray *hotComments;//热门评论合集
@property (nonatomic, strong) NSMutableArray *normalCommentCells;//存储cell，用于计算高度
@property (nonatomic, strong) NSMutableArray *normalComments;//普通评论合集

@end

@implementation PicDetailViewController

#define REUESED_SIZE 3
static NSString *reUsedStr[REUESED_SIZE] = {nil}; //重用标示

+ (void)initialize{
    if (self == [PicDetailViewController class]){
        for (int i = 0; i < REUESED_SIZE; i++) {
            reUsedStr[i] = [NSString stringWithFormat:@"PicDetail_%d", i];
        }
    }
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViews];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isTouchComment) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        [self.tableView setContentOffset:CGPointMake(0, self.headerView.frame.size.height-50)];

        [UIView commitAnimations];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initSubViews 

- (void)initSubViews {
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.navigationItem.title = @"图片详情";
    
    UIBarButtonItem *moreBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStyleDone target:self action:@selector(toMoreAction)];
    self.navigationItem.rightBarButtonItem = moreBtn;
    
    [self setupHeaderView];
    
    TouchTableView *tableView = [[TouchTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.touchDelegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //底部编辑界面
    _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-36, ScreenWidth, 36)];
    _inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_inputView];
    //编辑框
    UITextView *inputTv = [[UITextView alloc] init];
    inputTv.frame = CGRectMake(8, 4, _inputView.frame.size.width-8*2, _inputView.frame.size.height-4*2);
    inputTv.font = [UIFont systemFontOfSize:12];
    inputTv.backgroundColor = RGBA(223, 223, 223, 0.7);
    inputTv.delegate = self;
    inputTv.layer.cornerRadius = 5;
    inputTv.layer.masksToBounds = YES;
    [_inputView addSubview:inputTv];
    self.inputTv = inputTv;
    //提示语
    UILabel *inputHint = [[UILabel alloc] init];
    inputHint.frame = CGRectMake(inputTv.frame.origin.x+4, inputTv.frame.origin.y, 100, inputTv.frame.size.height);
    inputHint.text = @"评论";
    inputHint.textColor = RGB(181, 181, 181);
    inputHint.font = [UIFont systemFontOfSize:12];
    [_inputView addSubview:inputHint];
    self.inputHint = inputHint;
}

- (void)setupHeaderView {
    UIView *view = [[UIView alloc] init];
    //头像
    CGFloat avatarX = 12;
    CGFloat avatarY = 12;
    CGRect avatarRect = CGRectMake(avatarX, avatarY, 28, 28);
    UIImageView *avatarIv = [[UIImageView alloc] init];
    avatarIv.image = [UIImage imageNamed:self.status.avatar];
    avatarIv.frame = avatarRect;
    avatarIv.layer.cornerRadius = avatarIv.frame.size.width/2.0;
    avatarIv.layer.masksToBounds = YES;
    [view addSubview:avatarIv];
    //用户名
    UILabel *userName = [[UILabel alloc] init];
    userName.textColor = RGB(117, 117, 117);
    userName.font = [UIFont systemFontOfSize:kStatusCellUserNameFontSize];
    CGFloat userNameX = CGRectGetMaxX(avatarIv.frame)+6;
    CGFloat userNameY = avatarY;
    //根据文本内容取得文本占用空间大小
    CGSize userNameSize = [self.status.nickname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusCellUserNameFontSize]}];
    userName.frame = CGRectMake(userNameX, userNameY, userNameSize.width, userNameSize.height);
    userName.text = self.status.nickname;
    [userName sizeToFit];
    [view addSubview:userName];
    //发布日期
    UILabel *createAt = [[UILabel alloc] init];
    createAt.textColor = RGB(181, 181, 181);
    createAt.font = [UIFont systemFontOfSize:kStatusCellCreateAtFontSize];
    CGFloat createAtX = userNameX;
    CGFloat createAtY = CGRectGetMaxY(userName.frame)+2;
    NSString *createAtStr = [NSString stringWithFormat:@"%@ 发布图片", [self.status dateText]];
    CGSize createAtSize = [createAtStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusCellCreateAtFontSize]}];
    createAt.frame = CGRectMake(createAtX, createAtY, createAtSize.width, createAtSize.height);
    createAt.text = createAtStr;
    [createAt sizeToFit];
    [view addSubview:createAt];
    //订阅
    UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat subBtnW = 42;
    CGFloat subBtnH = avatarIv.frame.size.height;
    CGFloat subBtnX = ScreenWidth-subBtnW-8;
    CGFloat subBtnY = avatarY;
    subBtn.frame = CGRectMake(subBtnX, subBtnY, subBtnW, subBtnH);
    if (self.status.sub) {
        [subBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [subBtn setBackgroundColor:RGB(181, 181, 181)];
    } else {
        [subBtn setTitle:@"关注" forState:UIControlStateNormal];
        [subBtn setBackgroundColor:UIColorFromRGB(0x57b4b5)];
    }
    [subBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    subBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    subBtn.layer.cornerRadius = 4;
    subBtn.layer.masksToBounds = YES;
    [subBtn addTarget:self action:@selector(didSubAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:subBtn];
    //图片
    UIImageView *picIv = [[UIImageView alloc] init];
    UIImage *picImage = [UIImage imageNamed:self.status.image];
    CGFloat picIvW = picImage.size.width;
    CGFloat picIvH = picImage.size.height;
    picIv.image = picImage;
    picIv.frame = CGRectMake(ScreenWidth/2.0-picIvW/2.0, CGRectGetMaxY(avatarIv.frame)+kStatusCellControlSpacing, picIvW, picIvH);
    [view addSubview:picIv];
    //内容
    UILabel *content = [[UILabel alloc] init];
    content.textColor = RGB(117, 117, 117);
    content.font = [UIFont systemFontOfSize:kStatusCellContentFontSize];
    content.numberOfLines = 0;
    NSString *typeStr = [self.status typeText];
    NSString *contentStr = [NSString stringWithFormat:@"%@ %@", self.status.content, typeStr];
    
    CGFloat contentW = ScreenWidth - kStatusCellControlSpacing * 2;
    CGSize contentSize = [contentStr boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusCellContentFontSize]} context:nil].size;
    content.frame = CGRectMake(kStatusCellControlSpacing, CGRectGetMaxY(picIv.frame)+kStatusCellControlSpacing, contentSize.width, contentSize.height);
    //设置指定文字颜色
    NSMutableAttributedString *contentNSStr = [[NSMutableAttributedString alloc] initWithString:contentStr attributes:nil];
    NSRange range = NSMakeRange([[contentNSStr string] rangeOfString:typeStr].location, [[contentNSStr string] rangeOfString:typeStr].length);
    [contentNSStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x57b4b5) range:range];
    
    [content setAttributedText:contentNSStr];
    [view addSubview:content];
    //分割线
    UIView *separator = [[UIView alloc] init];
    separator.frame = CGRectMake(kStatusCellControlSpacing, CGRectGetMaxY(content.frame)+kStatusCellControlSpacing, ScreenWidth-kStatusCellControlSpacing*2, 0.6);
    separator.backgroundColor = TableView_Separator;
    [view addSubview:separator];
    //点赞按键
    FeatureButton *likeBtn = [[FeatureButton alloc] init];
    NSString *likeStr = [NSString stringWithFormat:@"%ld",self.status.likeModel.num];
    CGSize likeSize = [likeStr boundingRectWithSize:CGSizeMake(48, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8.0f]} context:nil].size;
    likeBtn.frame = CGRectMake(kStatusCellControlSpacing, CGRectGetMaxY(separator.frame)+kStatusCellControlSpacing, likeSize.width+24, kStatusCellFeatureBtnHeight);
    [likeBtn setTitle:likeStr forState:UIControlStateNormal];
    if (self.status.likeModel.isLike) {
        [likeBtn setImage:[UIImage imageNamed:@"icon_like_s"] forState:UIControlStateNormal];
    } else {
        [likeBtn setImage:[UIImage imageNamed:@"icon_like_n"] forState:UIControlStateNormal];
    }
    [view addSubview:likeBtn];
    //收藏按键
    FeatureButton *starBtn = [[FeatureButton alloc] init];
    NSString *starStr = [NSString stringWithFormat:@"%ld",self.status.starModel.num];
    CGSize starSize = [starStr boundingRectWithSize:CGSizeMake(48, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8.0f]} context:nil].size;
    starBtn.frame = CGRectMake(CGRectGetMaxX(likeBtn.frame)+kStatusCellControlSpacing, likeBtn.frame.origin.y, starSize.width+24, kStatusCellFeatureBtnHeight);
    [starBtn setTitle:starStr forState:UIControlStateNormal];
    if (self.status.starModel.isStar) {
        [starBtn setImage:[UIImage imageNamed:@"icon_star_s"] forState:UIControlStateNormal];
    } else {
        [starBtn setImage:[UIImage imageNamed:@"icon_star_n"] forState:UIControlStateNormal];
    }
    [view addSubview:starBtn];
    //评论按键
    FeatureButton *commentBtn = [[FeatureButton alloc] init];
    NSString *commentStr = [NSString stringWithFormat:@"%ld", self.status.comments.count];
    CGSize commnetSize = [starStr boundingRectWithSize:CGSizeMake(48, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8.0f]} context:nil].size;
    commentBtn.frame = CGRectMake(CGRectGetMaxX(starBtn.frame)+kStatusCellControlSpacing, likeBtn.frame.origin.y, commnetSize.width+24, kStatusCellFeatureBtnHeight);
    [commentBtn setTitle:commentStr forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateNormal];
    [view addSubview:commentBtn];
    //分享按键
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(ScreenWidth-kStatusCellFeatureBtnHeight-kStatusCellControlSpacing, likeBtn.frame.origin.y, kStatusCellFeatureBtnHeight, kStatusCellFeatureBtnHeight);
    [shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [view addSubview:shareBtn];
    
    view.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(shareBtn.frame)+kStatusCellControlSpacing);
    view.backgroundColor = [UIColor whiteColor];
    
    self.headerView = view;
}

#pragma mark - Private method

- (void)initData {
    isTouchReply = false;
    
    _nameList = [[NSMutableArray alloc] init];
    [_nameList addObject:@"ModelOneCell"];
    [_nameList addObject:@"ModelTwoCell"];
    [_nameList addObject:@"ModelThreeCell"];
    
    self.hotComments = [[NSMutableArray alloc] init];
    self.normalComments = [[NSMutableArray alloc] init];
    
    if (!self.hotCommentCells) {
        self.hotCommentCells = [[NSMutableArray alloc] init];
    }
    if (!self.normalCommentCells) {
        self.normalCommentCells = [[NSMutableArray alloc] init];
    }
    
    for (CommentModel *model in self.status.comments) {
        CommentStatusCell *cell = [[CommentStatusCell alloc] init];
        if ([model isLinked]) {
            cell.target = [self linkedComment:model.linked];
        }
        [cell setComment:model];
        
        if (model.isHotComment) {
            [self.hotComments addObject:model];
            [self.hotCommentCells addObject:cell];
        } else {
            [self.normalComments addObject:model];
            [self.normalCommentCells addObject:cell];
        }
    }
}

- (CommentModel *)linkedComment:(long long)commentId {
    for (CommentModel *model in self.status.comments) {
        if (commentId == model.Id) {
            return model;
        }
    }
    return nil;
}

#pragma mark - UITextViewDelegate

- (void)tableView:(TouchTableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //touch结束后的处理
    if ([self.inputTv isFirstResponder]) {
        if (isTouchReply) {
            isTouchReply = false;
            self.inputHint.text = @"评论";
        }
        [self.inputTv resignFirstResponder];
    }
}

-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.inputHint.hidden = NO;
    } else {
        self.inputHint.hidden = YES;
    }
}

#pragma mark - NSNotification

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.inputView.frame = CGRectMake(self.inputView.frame.origin.x,
                                            ScreenHeight-self.inputView.frame.size.height-height,
                                            self.inputView.frame.size.width,
                                            self.inputView.frame.size.height);
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.inputView.frame = CGRectMake(self.inputView.frame.origin.x,
                                            ScreenHeight-self.inputView.frame.size.height,
                                            self.inputView.frame.size.width,
                                            self.inputView.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - Actions

- (void)toMoreAction {
    
}

- (void)didSubAction:(UIButton *)btn {
    if (self.status.sub) {
        [self jxt_showActionSheetWithTitle:nil message:@"确定不再关注？" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.
            addActionCancelTitle(@"取消").
            addActionDefaultTitle(@"确定");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if (buttonIndex != 0) {
                self.status.sub = !self.status.sub;
                [btn setTitle:@"关注" forState:UIControlStateNormal];
                [btn setBackgroundColor:UIColorFromRGB(0x57b4b5)];
            }
        }];
    } else {
        self.status.sub = !self.status.sub;
        [[iToast makeText:@"关注成功"] show];
        [btn setTitle:@"已关注" forState:UIControlStateNormal];
        [btn setBackgroundColor:RGB(181, 181, 181)];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_nameList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_nameList[section] isEqualToString:@"ModelOneCell"]) {
        return 0;
    } else if ([_nameList[section] isEqualToString:@"ModelTwoCell"]) {
        return [self.hotComments count];
    } else {
        return [self.normalComments count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //根据section区域获取几种cell的公共父类
    CommentStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:reUsedStr[indexPath.section]];
    //根据不同的区域对应创建出该区域的cell
    if (cell == nil) {
        if ([_nameList[indexPath.section] isEqualToString:@"ModelTwoCell"]) {
            cell = [[CommentStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUsedStr[indexPath.section]];
        } else if ([_nameList[indexPath.section] isEqualToString:@"ModelThreeCell"]) {
            cell = [[CommentStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUsedStr[indexPath.section]];
        }
    }
    
    //对cell进行设置
    if ([_nameList[indexPath.section] isEqualToString:@"ModelTwoCell"]) {
        CommentModel *model = self.hotComments[indexPath.row];
        if ([model isLinked]) {
            cell.target = [self linkedComment:model.linked];
        }
        cell.comment = model;
    } else if ([_nameList[indexPath.section] isEqualToString:@"ModelThreeCell"]) {
        CommentModel *model = self.normalComments[indexPath.row];
        if ([model isLinked]) {
            cell.target = [self linkedComment:model.linked];
        }
        cell.comment = model;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_nameList[indexPath.section] isEqualToString:@"ModelTwoCell"]) {
        CommentStatusCell *cell = self.hotCommentCells[indexPath.row];
        return cell.height;
    } else if ([_nameList[indexPath.section] isEqualToString:@"ModelThreeCell"]) {
        CommentStatusCell *cell = self.normalCommentCells[indexPath.row];
        return cell.height;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([_nameList[section] isEqualToString:@"ModelOneCell"]) {
        return self.headerView.frame.size.height;
    } else if ([_nameList[section] isEqualToString:@"ModelTwoCell"]) {
        return 40.f;
    } else {
        return 40.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([_nameList[section] isEqualToString:@"ModelOneCell"]) {
        UIView *view = [UIView new];
        view = self.headerView;
        return view;
    } else if ([_nameList[section] isEqualToString:@"ModelTwoCell"]) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        //
        UILabel *hotComment = [[UILabel alloc] init];
        hotComment.frame = CGRectMake(kStatusCellControlSpacing, 40/2.0-20/2.0, 100, 20);
        hotComment.text = @"热门评论";
        hotComment.textColor = RGB(117, 117, 117);
        hotComment.font = [UIFont systemFontOfSize:13];
        hotComment.textAlignment = NSTextAlignmentLeft;
        [view addSubview:hotComment];
        //
        UIView *separator = [[UIView alloc] init];
        separator.frame = CGRectMake(hotComment.frame.origin.x, 40, ScreenWidth-kStatusCellControlSpacing*2, 1);
        separator.backgroundColor = TableView_Separator;
        [view addSubview:separator];

//        self.tableView.tableHeaderView = view;
        return view;
    } else if ([_nameList[section] isEqualToString:@"ModelThreeCell"]) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        //
        UILabel *newComment = [[UILabel alloc] init];
        newComment.frame = CGRectMake(kStatusCellControlSpacing, 40/2.0-20/2.0, 100, 20);
        newComment.text = @"最新评论";
        newComment.textColor = RGB(117, 117, 117);
        newComment.font = [UIFont systemFontOfSize:13];
        newComment.textAlignment = NSTextAlignmentLeft;
        [view addSubview:newComment];
        //
        UIView *separator = [[UIView alloc] init];
        separator.frame = CGRectMake(newComment.frame.origin.x, 40, ScreenWidth-kStatusCellControlSpacing*2, 1);
        separator.backgroundColor = TableView_Separator;
        [view addSubview:separator];

        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([_nameList[section] isEqualToString:@"ModelOneCell"]) {
        return 10.0f;
    } else if ([_nameList[section] isEqualToString:@"ModelTwoCell"]) {
        return 10.0f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([_nameList[section] isEqualToString:@"ModelOneCell"]) {
        UIView *footerView = [UIView new];
        footerView.backgroundColor = [UIColor clearColor];
        return footerView;
    }else if ([_nameList[section] isEqualToString:@"ModelTwoCell"]) {
        UIView *footerView = [UIView new];
        footerView.backgroundColor = [UIColor clearColor];
        return footerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![_nameList[indexPath.section] isEqualToString:@"ModelOneCell"]) {
        [self jxt_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.
            addActionCancelTitle(@"取消").
            addActionDefaultTitle(@"回复").
            addActionDefaultTitle(@"复制").
            addActionDefaultTitle(@"举报");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            
            if ([action.title isEqualToString:@"取消"]) {
                
            }
            else if ([action.title isEqualToString:@"回复"]) {
                isTouchReply = true;
                
                NSString *userName = nil;
                if ([_nameList[indexPath.section] isEqualToString:@"ModelTwoCell"]) {
                    CommentModel *model = self.hotComments[indexPath.row];
                    userName = model.nickname;
                } else {
                    CommentModel *model = self.normalComments[indexPath.row];
                    userName = model.nickname;
                }
                NSString *hintText = [NSString stringWithFormat:@"回复 %@",userName];
                self.inputHint.text = hintText;
                [self.inputTv becomeFirstResponder];
            }
            else if ([action.title isEqualToString:@"复制"]) {
                
            }
            else if ([action.title isEqualToString:@"举报"]) {
                ReportViewController *viewController = [[ReportViewController alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }];
    }
}

@end
