//
//  ContentTypeViewController.m
//  LiveWell
//
//  Created by Mark on 2017/7/26.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "ContentTypeViewController.h"
#import "PushTransition.h"
#import "PopTransition.h"
#import "InteractionTransitionAnimation.h"
#import "InteractiveTrasitionAnimation.h"
#import "ReleaseButton.h"
#import "ScanQRCodeViewController.h"

@interface ContentTypeViewController ()<UINavigationControllerDelegate> 

@property (strong, nonatomic) PushTransition *pushAnimation;
@property (strong, nonatomic) PopTransition  *popAnimation;
@property (strong, nonatomic) InteractionTransitionAnimation *popInteraction;
@property (strong, nonatomic) InteractiveTrasitionAnimation *popInteractive;

@end


@implementation ContentTypeViewController

#pragma mark - Initializes attributes

-(PushTransition *)pushAnimation {
    if (!_pushAnimation) {
        _pushAnimation = [[PushTransition alloc] init];
    }
    return _pushAnimation;
}

-(PopTransition *)popAnimation {
    if (!_popAnimation) {
        _popAnimation = [[PopTransition alloc] init];
    }
    return _popAnimation;
}

-(InteractionTransitionAnimation *)popInteraction {
    if (!_popInteraction) {
        _popInteraction = [[InteractionTransitionAnimation alloc] init];
    }
    return _popInteraction;
}

-(InteractiveTrasitionAnimation *)popInteractive {
    if (!_popInteractive) {
        _popInteractive = [[InteractiveTrasitionAnimation alloc] init];
    }
    return _popInteractive;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initSubViews

- (void)initSubViews {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGB(0, 206, 181).CGColor, (__bridge id)RGB(0, 196, 181).CGColor, (__bridge id)RGB(9, 181, 184).CGColor];
    gradientLayer.locations = @[@0.0, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(1.0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer addSublayer:gradientLayer];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(12, 24, 36, 36);
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setImage:[UIImage imageNamed:@"icon_white_cross"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(toCancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    CGFloat articleBtnX = 24;
    CGFloat articleBtnY = 148;
    CGFloat articleBtnW = 124;
    CGFloat articleBtnH = 196;
    ReleaseButton *articleBtn = [[ReleaseButton alloc] init];
    articleBtn.frame = CGRectMake(articleBtnX, articleBtnY, articleBtnW, articleBtnH);
    [articleBtn setImage:[UIImage imageNamed:@"icon_add_article"] forState:UIControlStateNormal];
    [articleBtn setTitle:@"发布文章" forState:UIControlStateNormal];
    articleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [articleBtn addTarget:self action:@selector(toClickArticleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:articleBtn];
    
    CGFloat homeBtnX = CGRectGetMaxX(articleBtn.frame)+24;
    CGFloat homeBtnY = articleBtnY;
    CGFloat homeBtnW = articleBtnW;
    CGFloat homeBtnH = articleBtnH;
    ReleaseButton *homeBtn = [[ReleaseButton alloc] init];
    homeBtn.frame = CGRectMake(homeBtnX, homeBtnY, homeBtnW, homeBtnH);
    [homeBtn setImage:[UIImage imageNamed:@"icon_add_home"] forState:UIControlStateNormal];
    [homeBtn setTitle:@"发布晒家" forState:UIControlStateNormal];
    homeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [homeBtn addTarget:self action:@selector(toClickHomeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
    
    CGFloat computerBtnX = 48;
    CGFloat computerBtnY = CGRectGetMaxY(homeBtn.frame)+80;
    CGFloat computerBtnW = self.view.frame.size.width-computerBtnX*2;
    CGFloat computerBtnH = 46;
    UIButton *computerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    computerBtn.frame = CGRectMake(computerBtnX, computerBtnY, computerBtnW, computerBtnH);
    [computerBtn setTitle:@"用电脑发布文章" forState:UIControlStateNormal];
    [computerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [computerBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    computerBtn.layer.borderWidth = 1;
    computerBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f].CGColor;
    computerBtn.layer.cornerRadius = computerBtnH/2.0;
    computerBtn.layer.masksToBounds = YES;
    [computerBtn addTarget:self action:@selector(toClickComputerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:computerBtn];

    CGFloat draftBtnW = self.view.frame.size.width+2;
    CGFloat draftBtnH = 44;
    CGFloat draftBtnX = -1;
    CGFloat draftBtnY = self.view.frame.size.height-draftBtnH+1;
    UIButton *draftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    draftBtn.frame = CGRectMake(draftBtnX, draftBtnY, draftBtnW, draftBtnH);
    [draftBtn setTitle:@"在草稿箱选择" forState:UIControlStateNormal];
    [draftBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    [draftBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    draftBtn.layer.borderWidth = 1;
    draftBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f].CGColor;
    [self.view addSubview:draftBtn];
}

#pragma mark - Actions

- (void)toCancelAction {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)toClickArticleAction {
    
}

- (void)toClickHomeAction {
    
}

- (void)toClickComputerAction {
    ScanQRCodeViewController *viewController = [[ScanQRCodeViewController alloc] init];
    viewController.isReturnRootView = YES;
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate
/** 返回转场动画实例*/
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop){
        return self.popAnimation;
    }
    if ([toVC isKindOfClass:[ScanQRCodeViewController class]]) {
        if (operation == UINavigationControllerOperationPush) {
            return self.pushAnimation;
        }
    }
    return nil;
}

/** 返回交互手势实例*/
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                        interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.popInteractive.isActing ? self.popInteractive : nil;
}

@end
