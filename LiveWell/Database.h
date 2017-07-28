//
//  Database.h
//  LiveWell
//
//  Created by Mark on 2017/6/15.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface Database : NSObject

@property (nonatomic, retain) FMDatabase *fmdb;

+ (Database*)sharedDatabase;

- (void)initDatabase;
- (void)closeDatabase;

@end
