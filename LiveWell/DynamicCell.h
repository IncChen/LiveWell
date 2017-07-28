//
//  DynamicCell.h
//  LiveWell
//
//  Created by Mark on 2017/7/18.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicStatus.h"

@class DynamicCell;

@protocol DynamicCellDelegate <NSObject>

@optional

- (void)didClickSubBtn:(UIButton *)btn picStatus:(PicStatus *)status;
- (void)didClickLikeBtn:(UIButton *)btn picStatus:(PicStatus *)status;
- (void)didClickStarBtn:(UIButton *)btn picStatus:(PicStatus *)status;
- (void)didClickComment:(PicStatus *)status;

@end

@interface DynamicCell : UITableViewCell

@property (nonatomic, strong) PicStatus *status;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, weak) id<DynamicCellDelegate> delegate;

@end
