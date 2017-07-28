//
//  PicStatusCollectionViewCell.h
//  LiveWell
//
//  Created by Mark on 2017/7/5.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicStatus.h"

@interface PicStatusCollectionViewCell : UICollectionViewCell {
    UIImageView *_picIv;//图片
    UILabel *_contentLabel;//文字描述
    UIImageView *_avatarIv;//头像
    UILabel *_nameLabel;//昵称
    UILabel *_starLabel;//被喜欢的个数
    UIImageView *_starIv;//星星图标
}

@property (nonatomic, strong) PicStatus *status;

//单元格高度
@property (nonatomic, assign) CGFloat height;

@end
