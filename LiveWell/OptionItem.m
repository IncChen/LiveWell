//
//  OptionItem.m
//  LiveWell
//
//  Created by Mark on 2017/7/19.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "OptionItem.h"

@implementation OptionItem

- (OptionItem *)initOption:(NSString *)title checked:(BOOL)isChecked {
    OptionItem *item = [[OptionItem alloc] init];
    item.title = title;
    item.isChecked = isChecked;
    return item;
}

@end
