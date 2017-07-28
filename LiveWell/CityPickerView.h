//
//  CityPickerView.h
//  LiveWell
//
//  Created by Mark on 2017/6/20.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CityOptionBlock)(NSString *content);

@interface CityPickerView : UIView

- (instancetype)initWithProvince:(NSString *)province city:(NSString *)city;
- (instancetype)setupOption:(CityOptionBlock)block;

- (void)option_show;
- (void)dismiss;

@end
