//
//  LevyCell.h
//  LiveWell
//
//  Created by Mark on 2017/7/21.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevySection.h"

@interface LevyCell : UITableViewCell

@property (nonatomic, strong) LevySection *levy;

@property (nonatomic, assign) CGFloat height;

@end
