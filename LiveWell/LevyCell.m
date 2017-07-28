//
//  LevyCell.m
//  LiveWell
//
//  Created by Mark on 2017/7/21.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "LevyCell.h"

#define kStatusCellControlSpacing 12 //控件间距

#define kStatusCellTitleFontSize 15
#define kStatusCellDetailFontSize 12
#define kStatusCellDateFontSize 10

@implementation LevyCell {
    UILabel *_titleLabel;//标题
    UIImageView *_levyIv;//活动图标
    UILabel *_detailTextLabel;//详细说明
    UILabel *_dateLabel;//发布日期
    UIView *_separator;//分割线
    UILabel *_promptLabel;//提示语
    UIImageView *_arrowIv;//箭头图标
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
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = RGB(51, 51, 51);
    _titleLabel.font = [UIFont systemFontOfSize:kStatusCellTitleFontSize];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    //活动图标
    _levyIv = [[UIImageView alloc] init];
    [self.contentView addSubview:_levyIv];
    //详细说明
    _detailTextLabel = [[UILabel alloc] init];
    _detailTextLabel.textColor = RGB(199, 199, 199);
    _detailTextLabel.font = [UIFont systemFontOfSize:kStatusCellDetailFontSize];
    _detailTextLabel.numberOfLines = 0;
    [self.contentView addSubview:_detailTextLabel];
    //发布日期
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = RGB(199, 199, 199);
    _dateLabel.font = [UIFont systemFontOfSize:kStatusCellDateFontSize];
    [self.contentView addSubview:_dateLabel];
    //分割线
    _separator = [[UIView alloc] init];
    [self.contentView addSubview:_separator];
    //提示语
    _promptLabel = [[UILabel alloc] init];
    _promptLabel.textColor = RGB(199, 199, 199);
    _promptLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_promptLabel];
    //箭头图标
    _arrowIv = [[UIImageView alloc] init];
    [self.contentView addSubview:_arrowIv];
    //cell分割线
    _cellSeparator = [[UIView alloc] init];
    [self.contentView addSubview:_cellSeparator];
}

- (void)setLevy:(LevySection *)levy {
    _levy = levy;
    
    CGFloat detailTextLabelY = 12;
    //标题
    if (levy.textLabel != nil || levy.textLabel.length != 0) {
        CGFloat titleLabelW = self.frame.size.width - kStatusCellControlSpacing*2;
        CGSize titleLabelSize = [levy.textLabel boundingRectWithSize:CGSizeMake(titleLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusCellTitleFontSize]} context:nil].size;
        
        _titleLabel.frame = CGRectMake(kStatusCellControlSpacing, kStatusCellControlSpacing, titleLabelSize.width, titleLabelSize.height);
        _titleLabel.text = levy.textLabel;
        
        detailTextLabelY = CGRectGetMaxY(_titleLabel.frame)+kStatusCellControlSpacing;
    }
    //活动图标
    if (levy.imageName != nil) {
        _levyIv.frame = CGRectMake(kStatusCellControlSpacing, kStatusCellControlSpacing, self.frame.size.width-kStatusCellControlSpacing*2, 120);
        _levyIv.image = [UIImage imageNamed:levy.imageName];
        
        detailTextLabelY = CGRectGetMaxY(_levyIv.frame)+kStatusCellControlSpacing;
    }
    //详细说明
    CGFloat detailTextLabelW = self.frame.size.width - kStatusCellControlSpacing*2;
    CGSize detailTextLabelSize = [levy.detailTextLabel boundingRectWithSize:CGSizeMake(detailTextLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusCellDetailFontSize]} context:nil].size;
    
    _detailTextLabel.frame = CGRectMake(kStatusCellControlSpacing, detailTextLabelY, detailTextLabelSize.width, detailTextLabelSize.height);
    _detailTextLabel.text = levy.detailTextLabel;
    //发布日期
    CGSize dateLabelSize = [levy.dateLabel sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusCellDateFontSize]}];
    _dateLabel.frame = CGRectMake(kStatusCellControlSpacing, CGRectGetMaxY(_detailTextLabel.frame)+kStatusCellControlSpacing, dateLabelSize.width, dateLabelSize.height);
    _dateLabel.text = levy.dateLabel;
    //分割线
    _separator.frame = CGRectMake(kStatusCellControlSpacing, CGRectGetMaxY(_dateLabel.frame)+kStatusCellControlSpacing, self.frame.size.width-kStatusCellControlSpacing*2, 0.6);
    _separator.backgroundColor = TableView_Separator;
    //提示语
    _promptLabel.frame = CGRectMake(kStatusCellControlSpacing, CGRectGetMaxY(_separator.frame)+kStatusCellControlSpacing, 100, 20);
    _promptLabel.text = @"点击查看详情";
    //箭头图标
    CGFloat arrowIvW = 20;
    CGFloat arrowIvH = 20;
    _arrowIv.frame = CGRectMake(self.frame.size.width-kStatusCellControlSpacing-arrowIvW, _promptLabel.frame.origin.y, arrowIvW, arrowIvH);
    _arrowIv.image = [UIImage imageNamed:@"icon_right"];
    //cell分割线
    _cellSeparator.frame = CGRectMake(0, CGRectGetMaxY(_promptLabel.frame)+kStatusCellControlSpacing, self.frame.size.width, 8);
    _cellSeparator.backgroundColor = RGB(245, 245, 245);
    
    self.height = CGRectGetMaxY(_cellSeparator.frame);
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
