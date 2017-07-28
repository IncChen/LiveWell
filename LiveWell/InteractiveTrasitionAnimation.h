//
//  InteractiveTrasitionAnimation.h
//  LiveWell
//
//  Created by Mark on 2017/6/29.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface InteractiveTrasitionAnimation : NSObject<UIViewControllerInteractiveTransitioning>

@property (assign , nonatomic) BOOL isActing;/** 判断动画正在进行中*/

-(void)writeToViewcontroller:(UIViewController *)toVc;/** 写入二级ViewController*/

- (void)updateInteractiveTransition:(CGFloat)percentComplete;/** 更新交互进度*/

- (void)cancelInteractiveTransition;/** 取消切换*/

- (void)finishInteractiveTransition;/** 完成切换*/

@end
