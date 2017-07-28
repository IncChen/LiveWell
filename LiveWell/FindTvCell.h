//
//  FindTvCell.h
//  LiveWell
//
//  Created by Mark on 2017/7/27.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindStatus.h"

@interface FindTvCell : UITableViewCell

@property (nonatomic, strong) FindStatus *status;

@property (nonatomic, assign) CGFloat height;

@end
