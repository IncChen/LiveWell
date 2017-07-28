//
//  DatePickerView.h
//  LiveWell
//
//  Created by Mark on 2017/6/21.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DateOptionBlock)(NSString *content);

@interface DatePickerView : UIView

- (instancetype)initWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day;
- (instancetype)setupOption:(DateOptionBlock)block;

- (void)option_show;
- (void)dismiss;

@end
