//
//  User.m
//  LiveWell
//
//  Created by Mark on 2017/6/20.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "User.h"

@implementation User

- (User *)initWithDictionary:(NSDictionary *)dic {
    if (self == [super init]) {
        self.phone = dic[@"phone"];
        self.name = dic[@"name"];
        self.sex = dic[@"sex"];
        self.location = dic[@"location"];
        self.birthday = dic[@"birthday"];
        self.profile = dic[@"profile"];
    }
    return self;
}

+ (User *)userWithDictionary:(NSDictionary *)dic {
    User *user = [[User alloc] initWithDictionary:dic];
    return user;
}

@end
