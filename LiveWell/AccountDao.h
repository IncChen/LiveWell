//
//  AccountDao.h
//  LiveWell
//
//  Created by Mark on 2017/6/15.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface AccountDao : NSObject

+ (void)initDB;
+ (BOOL)insertAccount:(Account *)account;
+ (BOOL)deleteAccountWithPhone:(NSString *)phone;
+ (BOOL)updatePwdWithPhone:(NSString *)phone password:(NSString *)password;
+ (NSArray *)queryAccounts;


@end
