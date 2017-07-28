//
//  DynamicCell.m
//  LiveWell
//
//  Created by Mark on 2017/7/18.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "DynamicCell.h"
#import "FeatureButton.h"

#define kStatusCellControlSpacing 12 //控件间距
#define kStatusCellFeatureBtnHeight 20

#define kStatusCellUserNameFontSize 11
#define kStatusCellCreateAtFontSize 10
#define kStatusCellContentFontSize 12

@implementation DynamicCell {
    UILabel *_subLabel;//订阅来源
    UIView *_topSeparator;//顶部分割线
    UIImageView *_avatarIv;//头像
    UILabel *_userName;//用户名
    UILabel *_createAt;//发布日期
    UIButton *_subBtn;//订阅按键
    UIImageView *_picIv;//图片
    UILabel *_content;//内容
    UIView *_bottomSeparator;//底部分割线
    FeatureButton *_likeBtn;//点赞按键
    FeatureButton *_starBtn;//收藏按键
    FeatureButton *_commentBtn;//评论按键
    UIButton *_shareBtn;//分享按键
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
    //订阅来源
    _subLabel = [[UILabel alloc] init];
    _subLabel.textColor = RGB(181, 181, 181);
    _subLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:_subLabel];
    //顶部分割线
    _topSeparator = [[UIView alloc] init];
    _topSeparator.backgroundColor = TableView_Separator;
    [self.contentView addSubview:_topSeparator];
    //头像
    _avatarIv = [[UIImageView alloc] init];
    [self.contentView addSubview:_avatarIv];
    //用户名
    _userName = [[UILabel alloc] init];
    _userName.textColor = RGB(117, 117, 117);
    _userName.font = [UIFont systemFontOfSize:kStatusCellUserNameFontSize];
    [self.contentView addSubview:_userName];
    //发布日期
    _createAt = [[UILabel alloc] init];
    _createAt.textColor = RGB(181, 181, 181);
    _createAt.font = [UIFont systemFontOfSize:kStatusCellCreateAtFontSize];
    [self.contentView addSubview:_createAt];
    //订阅按键
    _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_subBtn];
    //图片
    _picIv = [[UIImageView alloc] init];
    [self.contentView addSubview:_picIv];
    //内容
    _content = [[UILabel alloc] init];
    _content.textColor = RGB(117, 117, 117);
    _content.font = [UIFont systemFontOfSize:kStatusCellContentFontSize];
    _content.numberOfLines = 0;
    [self.contentView addSubview:_content];
    //底部分割线
    _bottomSeparator = [[UIView alloc] init];
    _bottomSeparator.backgroundColor = TableView_Separator;
    [self.contentView addSubview:_bottomSeparator];
    //点赞按键
    _likeBtn = [[FeatureButton alloc] init];
    [self.contentView addSubview:_likeBtn];
    //收藏按键
    _starBtn = [[FeatureButton alloc] init];
    [self.contentView addSubview:_starBtn];
    //评论按键
    _commentBtn = [[FeatureButton alloc] init];
    [self.contentView addSubview:_commentBtn];
    //分享按键
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_shareBtn];
    //cell分割线
    _cellSeparator = [[UIView alloc] init];
    _cellSeparator.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.contentView addSubview:_cellSeparator];
}

- (NSString *)stringDeleteString:(NSString *)str {
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    for (int i = 0; i < str1.length; i++) {
        unichar c = [str1 characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if (c == '#') { //此处可以是任何字符
            [str1 deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:str1];
    return newstr;
}

-(void)setStatus:(PicStatus *)status {
    _status = status;
    CGFloat avatarY = 0;
    if (status.types != nil) {
        _subLabel.frame = CGRectMake(kStatusCellControlSpacing, 8, 200, 20);
        NSString *type = status.types[0];
        NSString *result = [self stringDeleteString:type];
        _subLabel.text = [NSString stringWithFormat:@"来自你订阅的 %@",result];
        
        //顶部分割线
        _topSeparator.frame = CGRectMake(0, CGRectGetMaxY(_subLabel.frame)+8, ScreenWidth, 0.6);
        
        avatarY = CGRectGetMaxY(_topSeparator.frame)+kStatusCellControlSpacing;
    } else {
        avatarY = kStatusCellControlSpacing;
    }
    //头像
    CGFloat avatarX = kStatusCellControlSpacing;
    CGRect avatarRect = CGRectMake(avatarX, avatarY, 28, 28);
    _avatarIv.image = [UIImage imageNamed:status.avatar];
    _avatarIv.frame = avatarRect;
    _avatarIv.layer.cornerRadius = _avatarIv.frame.size.width/2.0;
    _avatarIv.layer.masksToBounds = YES;
    //用户名
    CGFloat userNameX = CGRectGetMaxX(_avatarIv.frame)+6;
    CGFloat userNameY = avatarY;
    //根据文本内容取得文本占用空间大小
    CGSize userNameSize = [status.nickname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusCellUserNameFontSize]}];
    _userName.frame = CGRectMake(userNameX, userNameY, userNameSize.width, userNameSize.height);
    _userName.text = status.nickname;
    [_userName sizeToFit];
    //发布日期
    _createAt.textColor = RGB(181, 181, 181);
    _createAt.font = [UIFont systemFontOfSize:kStatusCellCreateAtFontSize];
    CGFloat createAtX = userNameX;
    CGFloat createAtY = CGRectGetMaxY(_userName.frame)+2;
    NSString *createAtStr = [NSString stringWithFormat:@"%@ 发布", [status dateText]];
    CGSize createAtSize = [createAtStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusCellCreateAtFontSize]}];
    _createAt.frame = CGRectMake(createAtX, createAtY, createAtSize.width, createAtSize.height);
    _createAt.text = createAtStr;
    [_createAt sizeToFit];
    //订阅按键
    CGFloat subBtnW = 42;
    CGFloat subBtnH = _avatarIv.frame.size.height;
    CGFloat subBtnX = ScreenWidth-subBtnW-8;
    CGFloat subBtnY = avatarY;
    _subBtn.frame = CGRectMake(subBtnX, subBtnY, subBtnW, subBtnH);
    if (status.sub) {
        [_subBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [_subBtn setBackgroundColor:RGB(181, 181, 181)];
    } else {
        [_subBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_subBtn setBackgroundColor:UIColorFromRGB(0x57b4b5)];
    }
    [_subBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _subBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    _subBtn.layer.cornerRadius = 4;
    _subBtn.layer.masksToBounds = YES;
    [_subBtn addTarget:self action:@selector(toClickSub:) forControlEvents:UIControlEventTouchUpInside];
    //图片
    UIImage *picImage = [UIImage imageNamed:status.image];
    CGFloat picIvW = picImage.size.width;
    CGFloat picIvH = picImage.size.height;
    _picIv.image = picImage;
    _picIv.frame = CGRectMake(ScreenWidth/2.0-picIvW/2.0, CGRectGetMaxY(_avatarIv.frame)+kStatusCellControlSpacing, picIvW, picIvH);
    //内容
    NSString *contentStr = [NSString stringWithFormat:@"%@", status.content];
    CGFloat contentW = ScreenWidth - kStatusCellControlSpacing * 2;
    CGSize contentSize = [contentStr boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusCellContentFontSize]} context:nil].size;
    _content.frame = CGRectMake(kStatusCellControlSpacing, CGRectGetMaxY(_picIv.frame)+kStatusCellControlSpacing, contentSize.width, contentSize.height);
    _content.textColor = [UIColor blackColor];
    _content.text = contentStr;
    //底部分割线
    _bottomSeparator.frame = CGRectMake(kStatusCellControlSpacing, CGRectGetMaxY(_content.frame)+kStatusCellControlSpacing, ScreenWidth-kStatusCellControlSpacing*2, 0.6);
    //点赞按键
    NSString *likeStr = [NSString stringWithFormat:@"%ld",status.likeModel.num];
    CGSize likeSize = [likeStr boundingRectWithSize:CGSizeMake(48, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8.0f]} context:nil].size;
    _likeBtn.frame = CGRectMake(kStatusCellControlSpacing, CGRectGetMaxY(_bottomSeparator.frame)+kStatusCellControlSpacing, likeSize.width+24, kStatusCellFeatureBtnHeight);
    [_likeBtn setTitle:likeStr forState:UIControlStateNormal];
    if (status.likeModel.isLike) {
        [_likeBtn setImage:[UIImage imageNamed:@"icon_like_s"] forState:UIControlStateNormal];
    } else {
        [_likeBtn setImage:[UIImage imageNamed:@"icon_like_n"] forState:UIControlStateNormal];
    }
    [_likeBtn addTarget:self action:@selector(toClickLike:) forControlEvents:UIControlEventTouchUpInside];
    //收藏按键
    NSString *starStr = [NSString stringWithFormat:@"%ld",status.starModel.num];
    CGSize starSize = [starStr boundingRectWithSize:CGSizeMake(48, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8.0f]} context:nil].size;
    _starBtn.frame = CGRectMake(CGRectGetMaxX(_likeBtn.frame)+kStatusCellControlSpacing, _likeBtn.frame.origin.y, starSize.width+24, kStatusCellFeatureBtnHeight);
    [_starBtn setTitle:starStr forState:UIControlStateNormal];
    if (self.status.starModel.isStar) {
        [_starBtn setImage:[UIImage imageNamed:@"icon_star_s"] forState:UIControlStateNormal];
    } else {
        [_starBtn setImage:[UIImage imageNamed:@"icon_star_n"] forState:UIControlStateNormal];
    }
    [_starBtn addTarget:self action:@selector(toClickStar:) forControlEvents:UIControlEventTouchUpInside];
    //评论按键
    NSString *commentStr = [NSString stringWithFormat:@"%ld", status.comments.count];
    CGSize commnetSize = [starStr boundingRectWithSize:CGSizeMake(48, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8.0f]} context:nil].size;
    _commentBtn.frame = CGRectMake(CGRectGetMaxX(_starBtn.frame)+kStatusCellControlSpacing, _likeBtn.frame.origin.y, commnetSize.width+24, kStatusCellFeatureBtnHeight);
    [_commentBtn setTitle:commentStr forState:UIControlStateNormal];
    [_commentBtn setImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(toClickCooment) forControlEvents:UIControlEventTouchUpInside];
    //分享按键
    _shareBtn.frame = CGRectMake(ScreenWidth-kStatusCellFeatureBtnHeight-kStatusCellControlSpacing, _likeBtn.frame.origin.y, kStatusCellFeatureBtnHeight, kStatusCellFeatureBtnHeight);
    [_shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    //cell分割线
    _cellSeparator.frame = CGRectMake(0, CGRectGetMaxY(_shareBtn.frame)+kStatusCellControlSpacing, ScreenWidth, 10);
    //cell高度
    _height = CGRectGetMaxY(_cellSeparator.frame);
}

#pragma mark - Actions

- (void)toClickSub:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSubBtn:picStatus:)]) {
        [self.delegate didClickSubBtn:btn picStatus:self.status];
    }
}

- (void)toClickLike:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLikeBtn:picStatus:)]) {
        [self.delegate didClickLikeBtn:btn picStatus:self.status];
    }
}

- (void)toClickStar:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickStarBtn:picStatus:)]) {
        [self.delegate didClickStarBtn:btn picStatus:self.status];
    }
}

- (void)toClickCooment {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didClickComment:)]) {
        [self.delegate didClickComment:self.status];
    }
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
