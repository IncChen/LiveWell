//
//  AccountDao.m
//  LiveWell
//
//  Created by Mark on 2017/6/15.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "AccountDao.h"
#import "Database.h"

@implementation AccountDao

+ (void)initDB {
   BOOL bResult = [[Database sharedDatabase].fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS Account(account_id INTEGER PRIMARY KEY AUTOINCREMENT, phone TEXT, password TEXT)"];
    NSLog(@"Account DB create %@", bResult?@"<OK>":@"<Failed!>" );
}

+ (BOOL)insertAccount:(Account *)account {
    BOOL result = [[Database sharedDatabase].fmdb executeUpdate:@"INSERT INTO Account(phone, password) VALUES(?, ?)", account.phone, account.password];
    return result;
}

+ (BOOL)deleteAccountWithPhone:(NSString *)phone {
    @synchronized([Database sharedDatabase].fmdb) {
        BOOL result = [[Database sharedDatabase].fmdb executeUpdate:@"DELETE FROM Account WHERE phone = ?", phone];
        return result;
    }
}

+ (BOOL)updatePwdWithPhone:(NSString *)phone password:(NSString *)password {
    BOOL result = [[Database sharedDatabase].fmdb executeUpdate:@"UPDATE Account SET password = ? WHERE phone = ?", password, phone];
    return result;
}

+ (NSArray *)queryAccounts {
    NSMutableArray *accounts = [[NSMutableArray alloc] init];
    
    FMResultSet *rs = [[Database sharedDatabase].fmdb executeQuery:@"SELECT * FROM Account"];
    while ([rs next]) {
        NSInteger accountID = [rs intForColumn:@"account_id"];
        NSString *phone = [rs stringForColumn:@"phone"];
        NSString *password = [rs stringForColumn:@"password"];
        
        Account *account = [[Account alloc] init];
        account.accountID = accountID;
        account.phone = phone;
        account.password = password;
        
        [accounts addObject:account];
    }
    [rs close];
    
    return accounts;
}



@end
