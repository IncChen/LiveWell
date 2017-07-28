//
//  UserSection.m
//  LiveWell
//
//  Created by Mark on 2017/6/19.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "UserSection.h"

@implementation UserSection

- (UserSection *)initSectionImage:(NSString *)imageName text:(NSString *)textLabel {
    UserSection *section = [[UserSection alloc] init];
    section.imageName = imageName;
    section.textLabel = textLabel;
    section.detailTextLabel = @"";
    return section;
}

- (UserSection *)initSectionImage:(NSString *)imageName text:(NSString *)textLabel detailText:(NSString *)detailTextLabel {
    UserSection *section = [[UserSection alloc] init];
    section.imageName = imageName;
    section.textLabel = textLabel;
    section.detailTextLabel = detailTextLabel;
    return section;
}

@end
