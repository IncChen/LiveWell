//
//  AppDelegate.m
//  LiveWell
//
//  Created by Mark on 2017/6/9.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "LWNavigationController.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "Database.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UINavigationController *nav;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //设置全局导航条风格和颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:RGB(51, 51, 51)}];
    //隐藏导航栏底部线条
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    LoginViewController *viewController = [[LoginViewController alloc] init];
    self.nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.nav;
    [self.window makeKeyAndVisible];
    
    [self registerNotification];
    [[Database sharedDatabase] initDatabase];
    [self initLaunch];
    return YES;
}


- (void)registerNotification {
    if (SYSTEM_VERSION >= 10.f) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
            }
        }];
        
    } else if (SYSTEM_VERSION >= 8.0 && SYSTEM_VERSION < 10.0) {
        UIUserNotificationType types = UIUserNotificationTypeSound | /*UIUserNotificationTypeBadge |*/ UIUserNotificationTypeAlert;
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    } else {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

/*
 兼容使用LaunchImage启动图
 这边去获取启动图（为了防止广告图还在加载中，启动图已经加载结束了）
 */
- (void)initLaunch {
//    CGSize viewSize =self.window.bounds.size;
//    NSString*viewOrientation =@"Portrait";//横屏请设置成 @"Landscape"
//    NSString*launchImage =nil;
//    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
//    for(NSDictionary* dict in imagesDict) {
//        CGSize imageSize =CGSizeFromString(dict[@"UILaunchImageSize"]);
//        if(CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
//            launchImage = dict[@"UILaunchImageName"];
//        }
//    }
//    self.oldLaunchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
//    self.oldLaunchView.frame=self.window.bounds;
//    self.oldLaunchView.contentMode=UIViewContentModeScaleAspectFill;
//    [self.window addSubview:self.oldLaunchView];
    
    [self loadLaunchAd];
    
}

/*
 加载自定义广告
 */
-(void)loadLaunchAd {
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(handleTimer) userInfo:nil repeats:NO];
    
    //获取LaunchScreen.storyborad
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    if (storyboard == nil) {
        return;
    }
    //通过使用storyborardID去获取启动页viewcontroller
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    if (viewController == nil) {
        return;
    }
    
    self.launchView = viewController.view;
    [self.window addSubview:self.launchView];
    
    UIImageView *homeownerIv = [[UIImageView alloc] init];
    homeownerIv.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight*39/47.0);
    homeownerIv.image = [UIImage imageNamed:@"logo_bg_1"];
    [self.launchView addSubview:homeownerIv];
    
    // x:16/26.5  y:2 /47.0
    CGFloat homeownerLabelX = ScreenWidth*16/26.5;
    CGFloat homeownerLabelY = ScreenHeight*2/47.0;
    UILabel *homeownerLabel = [[UILabel alloc] init];
    homeownerLabel.frame = CGRectMake(homeownerLabelX, homeownerLabelY, ScreenWidth-homeownerLabelX-12, 20);
    homeownerLabel.backgroundColor = RGBA(0, 0, 0, 0.3);
    homeownerLabel.text = @"本期屋主 | LilyZhu";
    homeownerLabel.textColor = [UIColor whiteColor];
    homeownerLabel.textAlignment = NSTextAlignmentCenter;
    homeownerLabel.font = [UIFont systemFontOfSize:12];
    [self.launchView addSubview:homeownerLabel];
    
    // x:0 /26.5  y:39/47.0
    CGFloat logoY = ScreenHeight*39/47.0;
    UIView *logoView = [[UIView alloc] init];
    logoView.frame = CGRectMake(0, logoY, ScreenWidth, ScreenHeight-logoY);
    [self.launchView addSubview:logoView];
    
    UIImage *logoImage = [UIImage imageNamed:@"logo_screen"];
    UIImageView *logoIv = [[UIImageView alloc] init];
    logoIv.frame = CGRectMake(ScreenWidth/2.0-logoImage.size.width/2.0, logoView.frame.size.height/2.0-logoImage.size.height/2.0, logoImage.size.width, logoImage.size.height);
    logoIv.image = logoImage;
    [logoView addSubview:logoIv];
    
    [self.window bringSubviewToFront:self.launchView];
}

-(void)handleTimer{
    [self.launchView removeFromSuperview];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *phone = [userDef objectForKey:User_Def_Phone];
    if ([phone isEqual:[NSNull null]] || phone == nil || phone.length == 0) {
        //没有存在已登录的帐号

    } else {
        MainViewController *viewController = [[MainViewController alloc] init];
        [self.nav pushViewController:viewController animated:YES];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[Database sharedDatabase] closeDatabase];
}


@end
