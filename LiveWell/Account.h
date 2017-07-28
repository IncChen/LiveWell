//
//  Account.h
//  LiveWell
//
//  Created by Mark on 2017/6/15.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (nonatomic, assign) NSInteger accountID;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;

@end
