//
//  SearchCvCell.h
//  LiveWell
//
//  Created by Mark on 2017/7/24.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellTitleFontSize 10

@class SearchCvCell;

@protocol SearchCvCellDelegate <NSObject>

@optional

- (void)didSelectedOption:(NSString *)option;

@end

@interface SearchCvCell : UICollectionViewCell

@property (nonatomic, copy) NSString *option;

@property (nonatomic, weak) id<SearchCvCellDelegate> delegate;

@end
