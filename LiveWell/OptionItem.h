//
//  OptionItem.h
//  LiveWell
//
//  Created by Mark on 2017/7/19.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionItem : NSObject

@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, assign) NSString *title;

- (OptionItem *)initOption:(NSString *)title checked:(BOOL)isChecked;

@end
