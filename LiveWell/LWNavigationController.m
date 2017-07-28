//
//  LWNavigationController.m
//  LiveWell
//
//  Created by Mark on 2017/6/9.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "LWNavigationController.h"

@implementation LWNavigationController

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    
    return self.topViewController;
}

@end
