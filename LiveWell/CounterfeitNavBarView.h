//
//  CounterfeitNavBarView.h
//  LiveWell
//
//  Created by Mark on 2017/6/22.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^leftBtnTapBlock)(void);
typedef void(^rightBtnTapBlock)(void);

@interface CounterfeitNavBarView : UIView

@property (strong, nonatomic)UIView *backgroundView;
@property (strong, nonatomic)UILabel *titleLab;
@property (strong, nonatomic)UIButton *rightBtn;
@property (strong, nonatomic)UIButton *leftBtn;
@property (strong, nonatomic)UIView *lineView;
@property (strong, nonatomic)leftBtnTapBlock leftBtnTapAction;
@property (strong, nonatomic)rightBtnTapBlock rightBtnTapAction;

@end
