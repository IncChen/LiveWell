//
//  CommentStatusCell.m
//  LiveWell
//
//  Created by Mark on 2017/7/13.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "CommentStatusCell.h"
#import "FeatureButton.h"

#define kStatusCellControlSpacing 12 //控件间距
#define kCommentCellFeatureBtnHeight 24

#define kCommentCellUserNameFontSize 11
#define kCommentCellCreateAtFontSize 10
#define kCommentCellContentFontSize 12

@implementation CommentStatusCell {
    UIImageView *_avatarIv;//头像
    UILabel *_userName;//用户名
    UILabel *_createAt;//发布日期
    FeatureButton *_likeBtn;//点赞按键
    UIView *_vertical;//竖线
    UILabel *_targetLabel;//留言
    UILabel *_commentLabel;//评论
    UIView *_separator;//分割线
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    //头像
    _avatarIv = [[UIImageView alloc] init];
    [self.contentView addSubview:_avatarIv];
    //用户名
    _userName = [[UILabel alloc] init];
    _userName.textColor = RGB(117, 117, 117);
    _userName.font = [UIFont systemFontOfSize:kCommentCellUserNameFontSize];
    [self.contentView addSubview:_userName];
    //发布日期
    _createAt = [[UILabel alloc] init];
    _createAt.textColor = RGB(181, 181, 181);
    _createAt.font = [UIFont systemFontOfSize:kCommentCellCreateAtFontSize];
    [self.contentView addSubview:_createAt];
    //点赞按键
    _likeBtn = [[FeatureButton alloc] init];
    [self.contentView addSubview:_likeBtn];
    //竖线
    _vertical = [[UIView alloc] init];
    _vertical.backgroundColor = RGB(229, 229, 229);
    _vertical.hidden = YES;
    [self.contentView addSubview:_vertical];
    //留言
    _targetLabel = [[UILabel alloc] init];
    _targetLabel.textColor = RGB(183, 183, 183);
    _targetLabel.font = [UIFont systemFontOfSize:kCommentCellContentFontSize];
    _targetLabel.hidden = YES;
    [self.contentView addSubview:_targetLabel];
    //评论
    _commentLabel = [[UILabel alloc] init];
    _commentLabel.textColor = RGB(117, 117, 117);
    _commentLabel.font = [UIFont systemFontOfSize:kCommentCellContentFontSize];
    [self.contentView addSubview:_commentLabel];
    //分割线
    _separator = [[UIView alloc] init];
    _separator.backgroundColor = TableView_Separator;
    [self.contentView addSubview:_separator];
}

- (void)setComment:(CommentModel *)comment{
    //设置头像大小和位置
    CGFloat avatarX = 12;
    CGFloat avatarY = 12;
    CGRect avatarRect = CGRectMake(avatarX, avatarY, 28, 28);
    _avatarIv.image = [UIImage imageNamed:comment.avatar];
    _avatarIv.frame = avatarRect;
    _avatarIv.layer.cornerRadius = _avatarIv.frame.size.width/2.0;
    _avatarIv.layer.masksToBounds = YES;
    //设置用户名大小和位置
    CGFloat userNameX = CGRectGetMaxX(_avatarIv.frame)+6;
    CGFloat userNameY = avatarY;
    //根据文本内容取得文本占用空间大小
    CGSize userNameSize = [comment.nickname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kCommentCellUserNameFontSize]}];
    _userName.frame = CGRectMake(userNameX, userNameY, userNameSize.width, userNameSize.height);
    _userName.text = comment.nickname;
    [_userName sizeToFit];
    //设置发布日期大小和位置
    CGFloat createAtX = userNameX;
    CGFloat createAtY = CGRectGetMaxY(_userName.frame)+2;
    NSString *createAtStr = [NSString stringWithFormat:@"%@", [comment dateText]];
    CGSize createAtSize = [createAtStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kCommentCellCreateAtFontSize]}];
    _createAt.frame = CGRectMake(createAtX, createAtY, createAtSize.width, createAtSize.height);
    _createAt.text = createAtStr;
    [_userName sizeToFit];
    //设置点赞按键位置和大小
    NSString *likeStr = [NSString stringWithFormat:@"%ld",comment.like];
    CGSize likeSize = [likeStr boundingRectWithSize:CGSizeMake(48, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8.0f]} context:nil].size;
    CGFloat likeBtnW = likeSize.width+24;
    CGFloat likeBtnH = kCommentCellFeatureBtnHeight;
    CGFloat likeBtnX = self.contentView.frame.size.width-likeBtnW-kStatusCellControlSpacing;
    _likeBtn.frame = CGRectMake(likeBtnX, avatarY, likeBtnW, likeBtnH);
    [_likeBtn setTitle:likeStr forState:UIControlStateNormal];
    _likeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (comment.isLike) {
        [_likeBtn setImage:[UIImage imageNamed:@"icon_like_s"] forState:UIControlStateNormal];
    } else {
        [_likeBtn setImage:[UIImage imageNamed:@"icon_like_n"] forState:UIControlStateNormal];
    }
    //
    CGFloat commentH = CGRectGetMaxY(_createAt.frame)+kStatusCellControlSpacing;
    
    //
    if (self.target != nil) {
        _vertical.hidden = NO;
        _targetLabel.hidden = NO;
        //计算留言的大小
        NSString *targetStr = [NSString stringWithFormat:@"%@：%@", self.target.nickname,self.target.comment];
        CGFloat targetW = self.frame.size.width -_userName.frame.origin.x - kStatusCellControlSpacing;
        CGSize targetSize = [targetStr boundingRectWithSize:CGSizeMake(targetW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kCommentCellContentFontSize]} context:nil].size;
        //设置竖线位置和大小
        _vertical.frame = CGRectMake(_userName.frame.origin.x, CGRectGetMaxY(_createAt.frame)+kStatusCellControlSpacing, 1, targetSize.height);
        //设置留言的位置和大小
        _targetLabel.frame = CGRectMake(CGRectGetMaxX(_vertical.frame)+4, _vertical.frame.origin.y+2, targetSize.width, targetSize.height);
        _targetLabel.text = targetStr;
        [_targetLabel sizeToFit];
        
        commentH = CGRectGetMaxY(_vertical.frame)+kStatusCellControlSpacing;
    } else {
        _vertical.hidden = YES;
        _targetLabel.hidden = YES;
    }
    
    //设置评论的位置和大小
    CGFloat commentW = self.frame.size.width -_userName.frame.origin.x - kStatusCellControlSpacing;
    CGSize commentSize = [comment.comment boundingRectWithSize:CGSizeMake(commentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kCommentCellContentFontSize]} context:nil].size;
    
    _commentLabel.frame = CGRectMake(_userName.frame.origin.x, commentH, commentSize.width, commentSize.height);
    _commentLabel.text = comment.comment;
    [_commentLabel sizeToFit];
    //设置分割线的位置
    _separator.frame = CGRectMake(_createAt.frame.origin.x, CGRectGetMaxY(_commentLabel.frame)+kStatusCellControlSpacing, self.contentView.frame.size.width-_createAt.frame.origin.x-kStatusCellControlSpacing, 0.6);
    
    self.height = CGRectGetMaxY(_separator.frame);
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
