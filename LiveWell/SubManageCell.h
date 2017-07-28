//
//  SubManageCell.h
//  LiveWell
//
//  Created by Mark on 2017/7/18.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionItem.h"

#define kCellTitleFontSize 12

@class SubManageCell;

@protocol SubManageCellDelegate <NSObject>

@optional

- (void)didCheckedSub:(OptionItem *)theme;

@end

@interface SubManageCell : UICollectionViewCell

@property (nonatomic, strong) OptionItem *theme;

@property (nonatomic, weak) id<SubManageCellDelegate> delegate;

@end
