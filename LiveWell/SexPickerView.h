//
//  SexPickerView.h
//  LiveWell
//
//  Created by Mark on 2017/6/20.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SexOptionBlock)(NSString *content);

@interface SexPickerView : UIView

- (instancetype)initWithSex:(NSString *)sex;
- (instancetype)setupOption:(SexOptionBlock)block;

- (void)option_show;
- (void)dismiss;

@end
