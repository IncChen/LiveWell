//
//  FindTvCell.m
//  LiveWell
//
//  Created by Mark on 2017/7/27.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "FindTvCell.h"

#define kStatusCellControlSpacing 12 //控件间距

#define kStatusCellUserNameFontSize 11
#define kStatusCellContentFontSize 16
#define kStatusCellAreaFontSize 10

@implementation FindTvCell {
    UILabel *_typeLabel;//类型来源
    UIImageView *_picIv;//图片
    UILabel *_content;//内容
    UIImageView *_avatarIv;//头像
    UILabel *_userName;//用户名
    UIImageView *_proIv;//职业图标
    UILabel *_areaLabel;//居室
    UIView *_cellSeparator;//cell分割线
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    //类型来源
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textColor = RGB(181, 181, 181);
    _typeLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_typeLabel];
    //图片
    _picIv = [[UIImageView alloc] init];
    [self.contentView addSubview:_picIv];
    //内容
    _content = [[UILabel alloc] init];
    _content.textColor = [UIColor blackColor];
    _content.font = [UIFont boldSystemFontOfSize:kStatusCellContentFontSize];
    _content.numberOfLines = 0;
    [self.contentView addSubview:_content];
    //头像
    _avatarIv = [[UIImageView alloc] init];
    [self.contentView addSubview:_avatarIv];
    //用户名
    _userName = [[UILabel alloc] init];
    _userName.textColor = RGB(117, 117, 117);
    _userName.font = [UIFont systemFontOfSize:kStatusCellUserNameFontSize];
    [self.contentView addSubview:_userName];
    //职业图标
    _proIv = [[UIImageView alloc] init];
    [self.contentView addSubview:_proIv];
    //居室
    _areaLabel = [[UILabel alloc] init];
    _areaLabel.textColor = RGB(181, 181, 181);
    _areaLabel.font = [UIFont systemFontOfSize:kStatusCellAreaFontSize];
    [self.contentView addSubview:_areaLabel];
    //cell分割线
    _cellSeparator = [[UIView alloc] init];
    _cellSeparator.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.contentView addSubview:_cellSeparator];
}

- (void)setStatus:(FindStatus *)status {
    _status = status;
    //类型来源
    _typeLabel.frame = CGRectMake(ScreenWidth/2.0-100/2.0, kStatusCellControlSpacing, 100, 20);
    _typeLabel.text = [NSString stringWithFormat:@"— %@ —",status.type];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    //图片
    _picIv.frame = CGRectMake(kStatusCellControlSpacing, CGRectGetMaxY(_typeLabel.frame)+kStatusCellControlSpacing, ScreenWidth-kStatusCellControlSpacing*2, 120);
    [_picIv setImage:[UIImage imageNamed:status.picUrl]];
    //内容
    NSString *contentStr = [NSString stringWithFormat:@"%@", status.content];
    CGFloat contentW = ScreenWidth - kStatusCellControlSpacing * 2;
    CGSize contentSize = [contentStr boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kStatusCellContentFontSize]} context:nil].size;
    _content.frame = CGRectMake(kStatusCellControlSpacing, CGRectGetMaxY(_picIv.frame)+kStatusCellControlSpacing, contentSize.width, contentSize.height);
    _content.text = contentStr;
    
    //用户名X,Y值
    CGFloat userNameX = 0;
    CGFloat userNameY = 0;
    
    //头像
    if ([status.type isEqualToString:@"整屋案例"]) {
        CGFloat avatarX = kStatusCellControlSpacing;
        CGFloat avatarY = CGRectGetMaxY(_content.frame)+8;
        CGRect avatarRect = CGRectMake(avatarX, avatarY, 28, 28);
        _avatarIv.image = [UIImage imageNamed:status.avatar];
        _avatarIv.frame = avatarRect;
        _avatarIv.layer.cornerRadius = _avatarIv.frame.size.width/2.0;
        _avatarIv.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarIv];
        
        userNameX = CGRectGetMaxX(_avatarIv.frame)+4;
        userNameY = avatarY+8;
    } else {
        [_avatarIv removeFromSuperview];
        
        userNameX = kStatusCellControlSpacing;
        userNameY = CGRectGetMaxY(_content.frame)+8;
    }
 
    //用户名
    //根据文本内容取得文本占用空间大小
    CGSize userNameSize = [status.nickname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusCellUserNameFontSize]}];
    _userName.frame = CGRectMake(userNameX, userNameY, userNameSize.width, userNameSize.height);
    _userName.text = status.nickname;
    [_userName sizeToFit];
    
    if ([status.type isEqualToString:@"整屋案例"]) {
        //职业图标
        _proIv.frame = CGRectMake(CGRectGetMaxX(_userName.frame)+4, _userName.frame.origin.y, 28, 12);
        _proIv.image = [UIImage imageNamed:status.proUrl];
        //居室
        NSString *areaStr = [NSString stringWithFormat:@"%@ %@", status.huxing, status.area];
        CGSize areaSize = [areaStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusCellUserNameFontSize]}];
        _areaLabel.frame = CGRectMake(ScreenWidth-kStatusCellControlSpacing-areaSize.width, _proIv.frame.origin.y, areaSize.width, areaSize.height);
        _areaLabel.text = areaStr;
        
        [self.contentView addSubview:_proIv];
        [self.contentView addSubview:_areaLabel];
    } else {
        [_proIv removeFromSuperview];
        [_areaLabel removeFromSuperview];
    }
    
    //cell分割线
    _cellSeparator.frame = CGRectMake(0, CGRectGetMaxY(_userName.frame)+kStatusCellControlSpacing, ScreenWidth, 10);
    //cell高度
    _height = CGRectGetMaxY(_cellSeparator.frame);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
