//
//  DecorationStateViewController.h
//  LiveWell
//
//  Created by Mark on 2017/6/28.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "BaseBackViewController.h"

@protocol DecorationStateDelegate;

@interface DecorationStateViewController : BaseBackViewController

@property (nonatomic, copy) NSString *state;
@property (nonatomic, assign) id<DecorationStateDelegate> delegate;

@end

@protocol DecorationStateDelegate

- (void)didSelectState:(NSString *)state;

@end
