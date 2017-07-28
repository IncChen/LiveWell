//
//  AddContentView.h
//  LiveWell
//
//  Created by Mark on 2017/7/25.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OptionBlock)(NSInteger index);

@interface AddContentView : UIView

- (instancetype)setupOption:(OptionBlock)block;

- (void)show;
- (void)dismiss;

@end
