//
//  ACMacros.h
//  LiveWell
//  app项目的相关宏定义
//
//  Created by Mark on 2017/6/9.
//  Copyright © 2017年 mark. All rights reserved.
//

#ifndef ACMacros_h
#define ACMacros_h

//沙盒路径
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#pragma mark - Frame (宏 x, y, width, height)

//系统版本
#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]

// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]

// App Frame Height&Width
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

// MainScreen Height&Width
#define ScreenHeight      [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth       [[UIScreen mainScreen] bounds].size.width

#pragma mark - Color

// 颜色(RGB)
#define RGBA(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGB(r, g, b)       RGBA(r, g, b, 1.0)

// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#endif /* ACMacros_h */
