//
//  Database.m
//  LiveWell
//
//  Created by Mark on 2017/6/15.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "Database.h"
#import "AccountDao.h"

#define DATABASE_FILE @"database.sqlite"

#define DEF_PhoneTableVersionNumber			1.0
#define DEF_PhoneTableVersionNumberKeyString	@"PhoneTableVer"

@implementation Database

static Database *sDatabase = nil;

+ (Database*)sharedDatabase {
    if (sDatabase == nil) {
        sDatabase = [[super allocWithZone:NULL] init];
    }
    
    return sDatabase;
}

- (void)initDatabase {
//#if IS_REBUILD_DB == 1
//    // 移除資料庫
//    [self removeDatabase];
//#endif
    
    [self openDatabase];
    [self initDataTable];
}

- (void)openDatabase {
    NSString *document = PATH_OF_DOCUMENT;
    _fmdb = [[FMDatabase alloc] initWithPath:[NSString stringWithFormat:@"%@/%@", document, DATABASE_FILE]];
    
    if (![_fmdb open]) {
        return;
    }
}

- (void)initDataTable{
    BOOL bResetDatabase = NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *numVer = [userDefaults objectForKey:DEF_PhoneTableVersionNumberKeyString];

    if( [numVer floatValue] != DEF_PhoneTableVersionNumber ) {
        NSLog(@"Need to reset UserList data table !!!" );
        
        bResetDatabase = YES;
    }
    
    if (bResetDatabase) {
        [self removeDatabase];
        [self openDatabase];
    }
    
    [userDefaults setValue:[NSNumber numberWithFloat:DEF_PhoneTableVersionNumber] forKey:DEF_PhoneTableVersionNumberKeyString];
    
    [AccountDao initDB];
}

- (void)closeDatabase {
    [_fmdb close];
    _fmdb = nil;
}

- (void)removeDatabase {
    if (_fmdb) {
        [_fmdb close];
    }
    
    NSString *documentsDirectory = PATH_OF_DOCUMENT;
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:DATABASE_FILE];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

@end
