//
//  UserSection.h
//  LiveWell
//
//  Created by Mark on 2017/6/19.
//  Copyright © 2017年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSection : NSObject

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *textLabel;
@property (nonatomic, copy) NSString *detailTextLabel;

- (UserSection *)initSectionImage:(NSString *)imageName text:(NSString *)textLabel;

- (UserSection *)initSectionImage:(NSString *)imageName text:(NSString *)textLabel detailText:(NSString *)detailTextLabel;

@end
