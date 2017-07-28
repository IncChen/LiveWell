//
//  InteractionTransitionAnimation.h
//  LiveWell
//
//  Created by Mark on 2017/6/29.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractionTransitionAnimation : UIPercentDrivenInteractiveTransition

@property (assign , nonatomic) BOOL isActing;/** 判断动画正在进行中*/

-(void)writeToViewcontroller:(UIViewController *)toVc;/** 写入二级ViewController*/

@end
