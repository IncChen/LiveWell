//
//  PicDetailViewController.h
//  LiveWell
//
//  Created by Mark on 2017/7/7.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "BaseBackViewController.h"
#import "PicStatus.h"

@interface PicDetailViewController : BaseBackViewController

@property (nonatomic, assign) BOOL isTouchComment;

@property (nonatomic, strong) PicStatus *status;

@end
