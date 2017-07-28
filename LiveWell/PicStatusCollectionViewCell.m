//
//  PicStatusCollectionViewCell.m
//  LiveWell
//
//  Created by Mark on 2017/7/5.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "PicStatusCollectionViewCell.h"

#define kStatusCellContentTextFontSize 11
#define kStatusCellNameTextFontSize 10
#define kStatusCellStarTextFontSize 10

@implementation PicStatusCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    //图片
    _picIv = [[UIImageView alloc] init];
    [self.contentView addSubview:_picIv];
    //文字描述
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = RGB(117, 117, 117);
    _contentLabel.font = [UIFont systemFontOfSize:kStatusCellContentTextFontSize];
    _contentLabel.numberOfLines = 2;
    [self.contentView addSubview:_contentLabel];
    //头像
    _avatarIv = [[UIImageView alloc] init];
    [self.contentView addSubview:_avatarIv];
    //昵称
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor lightGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize:kStatusCellNameTextFontSize];
    _nameLabel.numberOfLines = 1;
    [self.contentView addSubview:_nameLabel];
    //被喜欢的个数
    _starLabel = [[UILabel alloc] init];
    _starLabel.textColor = [UIColor lightGrayColor];
    _starLabel.font = [UIFont systemFontOfSize:kStatusCellStarTextFontSize];
    _starLabel.numberOfLines = 1;
    [self.contentView addSubview:_starLabel];
    //星星图标
    _starIv = [[UIImageView alloc] init];
    [self.contentView addSubview:_starIv];
}

- (void)setStatus:(PicStatus *)status {
    //图片
    UIImage *picImage = [UIImage imageNamed:status.image];
    CGFloat picIvW = picImage.size.width*0.42;
    CGFloat picIvH = picImage.size.height*0.42;
    _picIv.image = picImage;
    _picIv.frame = CGRectMake(self.contentView.frame.size.width/2.0-picIvW/2.0, 0, picIvW, picIvH);
    //文字描述
    NSString *contentStr = [NSString stringWithFormat:@"%@ %@", status.content, [status typeText]];
    if ([contentStr isEqual:[NSNull null]] || contentStr == nil || contentStr.length == 0
        || [contentStr containsString:@"(null)"]) {
        _contentLabel.hidden = YES;
        
        //cell高度
        _height = CGRectGetMaxY(_picIv.frame);
    } else {
        _contentLabel.hidden = NO;
        CGFloat contentLabelW = _picIv.frame.size.width;
        CGFloat contentLabelH = 32.0;
        CGSize contentSize = [contentStr boundingRectWithSize:CGSizeMake(contentLabelW, contentLabelH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusCellContentTextFontSize]} context:nil].size;
        
        _contentLabel.frame = CGRectMake(_picIv.frame.origin.x, CGRectGetMaxY(_picIv.frame)+6, contentSize.width, contentSize.height);
        _contentLabel.text = contentStr;
    
        //头像
        CGFloat avatarIvY = CGRectGetMaxY(_contentLabel.frame)+8;
        if (contentStr.length == 0) {
            avatarIvY = CGRectGetMaxY(_picIv.frame)+6;
        }
        _avatarIv.frame = CGRectMake(_picIv.frame.origin.x, avatarIvY, 12, 12);
        _avatarIv.image = [UIImage imageNamed:status.avatar];
        _avatarIv.layer.cornerRadius = _avatarIv.frame.size.width/2.0;
        _avatarIv.layer.masksToBounds = YES;
        //被喜欢的个数
        NSString *starStr = [NSString stringWithFormat:@"%ld",status.starModel.num];
        CGSize starSize = [starStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusCellStarTextFontSize]}];
        CGFloat starLabelX = CGRectGetMaxX(_picIv.frame)-starSize.width;
        CGFloat starLabelY = _avatarIv.frame.origin.y;
        _starLabel.frame = CGRectMake(starLabelX, starLabelY, starSize.width, starSize.height);
        _starLabel.text = starStr;
        //星星图标
        CGFloat starIvX = _starLabel.frame.origin.x-12-4;
        CGFloat starIvY = _avatarIv.frame.origin.y;
        _starIv.frame = CGRectMake(starIvX, starIvY, 12, 12);
        _starIv.image = [UIImage imageNamed:@"icon_star_n"];
        //昵称
        CGFloat nameLabelX = CGRectGetMaxX(_avatarIv.frame)+4;
        CGFloat nameLabelY = _avatarIv.frame.origin.y;
        CGFloat nameLabelW = _starIv.frame.origin.x-nameLabelX;
        CGFloat nameLabelH = _avatarIv.frame.size.height;
        _nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
        _nameLabel.text = status.nickname;
        
        //cell高度
        _height = CGRectGetMaxY(_avatarIv.frame);
    }
}

@end
