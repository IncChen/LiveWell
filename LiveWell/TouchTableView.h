//
//  TouchTableView.h
//  LiveWell
//
//  Created by Mark on 2017/7/14.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchTableViewDelegate <NSObject>

@optional

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
 touchesCancelled:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
     touchesEnded:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
     touchesMoved:(NSSet *)touches
        withEvent:(UIEvent *)event;


@end

@interface TouchTableView : UITableView {
//@private
//    id _touchDelegate;
}

@property (nonatomic,assign) id<TouchTableViewDelegate> touchDelegate;

@end
