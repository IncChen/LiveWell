//
//  DiscoveryHeaderView.h
//  LiveWell
//
//  Created by Mark on 2017/7/27.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoveryHeaderView : UITableViewHeaderFooterView

+ (instancetype)discoveryHeaderView;

/** head */
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@end
