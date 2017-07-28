//
//  TopicHeaderView.h
//  LiveWell
//
//  Created by Mark on 2017/7/17.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicHeaderView : UITableViewHeaderFooterView

+ (instancetype)topicHeaderView;

/** head */
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) NSArray *topics;

@end
