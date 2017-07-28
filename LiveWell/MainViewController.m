//
//  MainViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/9.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "MainViewController.h"
#import "CYLTabBarControllerConfig.h"
#import "CYLPlusButtonSubclass.h"
#import "AddContentView.h"
#import "ContentTypeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ContentTypeViewController.h"
#import "PushTransition.h"

@interface MainViewController ()<UITabBarControllerDelegate, CYLTabBarControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) PushTransition *pushAnimation;

@end

@implementation MainViewController

#pragma mark - Initializes attributes

-(PushTransition *)pushAnimation {
    if (!_pushAnimation) {
        _pushAnimation = [[PushTransition alloc] init];
    }
    return _pushAnimation;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [CYLPlusButtonSubclass registerPlusButton];
    CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
    CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
    tabBarController.delegate = self;
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBarControllerDelegate,CYLTabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    // 即使 PlusButton 也添加了点击事件，点击 PlusButton 后也会触发该代理方法。
    if ([control cyl_isPlusButton]) {
        UIButton *button = CYLExternPlusButton;
        animationView = button.imageView;
        
        [self playSoundEffect:@"beep-beep.aiff"];
        
        AddContentView *contentView = [[AddContentView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [[contentView setupOption:^(NSInteger index) {
            if (index == 0) {
                //发布图片

            } else if (index == 1) {
                //发布文章
                UIViewController *viewController = tabBarController.selectedViewController;
                viewController.navigationController.delegate = self;
                ContentTypeViewController *vc = [[ContentTypeViewController alloc] init];
                [tabBarController presentViewController:vc animated:YES completion:nil];
            }
        }] show];
    }
}


- (void)playSoundEffect:(NSString *)name {
    //获取音效文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    //创建音效文件URL
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    //音效声音的唯一标示ID
    SystemSoundID soundID = 0;
    //将音效加入到系统音效服务中，NSURL需要桥接成CFURLRef，会返回一个长整形ID，用来做音效的唯一标示
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //设置音效播放完成后的回调C语言函数
    AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL, soundCompleteCallBack,NULL);
    //开始播放音效
    AudioServicesPlaySystemSound(soundID);
}

void soundCompleteCallBack(SystemSoundID soundID, void *clientData) {
    NSLog(@"播放完成");
}

#pragma mark - UINavigationControllerDelegate
/** 返回转场动画实例*/
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if ([toVC isKindOfClass:[ContentTypeViewController class]]) {
        if (operation == UINavigationControllerOperationPush) {
            return self.pushAnimation;
        }
    }
    
    return nil;
}

@end
