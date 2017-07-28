//
//  CommentStatusCell.h
//  LiveWell
//
//  Created by Mark on 2017/7/13.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentStatusCell : UITableViewCell

@property (nonatomic, strong) CommentModel *target;
@property (nonatomic, strong) CommentModel *comment;

@property (nonatomic, assign) CGFloat height;

@end
