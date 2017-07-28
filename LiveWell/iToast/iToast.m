//
//  iToast.m
//  LiveWell
//
//  Created by Mark on 2017/6/15.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "iToast.h"
#import <QuartzCore/QuartzCore.h>

static iToastSettings *sharedSettings = nil;

@interface iToast(private)

- (iToast *) settings;

@end


@implementation iToast


- (id) initWithText:(NSString *) tex{
    if (self = [super init]) {
        text = [tex copy];
    }
    
    return self;
}

- (void) show{
    
    iToastSettings *theSettings = _settings;
    
    if (!theSettings) {
        theSettings = [iToastSettings getSharedSettings];
    }
    
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, 60)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 5, textSize.height + 5)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:87/255.0 green:55/255.0 blue:56/255.0 alpha:1.0];
    label.font = font;
    label.text = text;
    label.numberOfLines = 0;
//    label.shadowColor = [UIColor darkGrayColor];
//    label.shadowOffset = CGSizeMake(1, 1);
    
    UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];
    v.frame = CGRectMake(0, 0, textSize.width + 36, textSize.height + 36);
    label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
    [v addSubview:label];
    
    v.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6];
    v.layer.cornerRadius = 4;
    
    v.center = CGPointMake([self getScreenSize].width/2, [self getScreenSize].height/2);
    
    NSTimer *timer1 = [NSTimer timerWithTimeInterval:((float)theSettings.duration)/1000
                                              target:self selector:@selector(hideToast:)
                                            userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    
    [[self appRootViewController].view addSubview:v];
    
    view = v;
    
    [v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];
}

- (void) hideToast:(NSTimer*)theTimer{
    [UIView beginAnimations:nil context:NULL];
    view.alpha = 0;
    [UIView commitAnimations];
    
    NSTimer *timer2 = [NSTimer timerWithTimeInterval:500
                                              target:self selector:@selector(hideToast:)
                                            userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
}

- (void) removeToast:(NSTimer*)theTimer{
    [view removeFromSuperview];
}


+ (iToast *) makeText:(NSString *) _text{
    iToast *toast = [[iToast alloc] initWithText:_text];
    
    return toast;
}


- (iToast *) setDuration:(NSInteger ) duration{
    [self theSettings].duration = duration;
    return self;
}

- (iToast *) setGravity:(iToastGravity) gravity
             offsetLeft:(NSInteger) left
              offsetTop:(NSInteger) top{
    [self theSettings].gravity = gravity;
    offsetLeft = left;
    offsetTop = top;
    return self;
}

- (iToast *) setGravity:(iToastGravity) gravity{
    [self theSettings].gravity = gravity;
    return self;
}

- (iToast *) setPostion:(CGPoint) _position{
    [self theSettings].postition = CGPointMake(_position.x, _position.y);
    
    return self;
}

-(iToastSettings *) theSettings{
    if (!_settings) {
        _settings = [[iToastSettings getSharedSettings] copy];
    }
    
    return _settings;
}


-(CGSize)getScreenSize {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGSizeMake(screenSize.height, screenSize.width);
    }
    return screenSize;
}


-(UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end


@implementation iToastSettings
@synthesize duration;
@synthesize gravity;
@synthesize postition;
@synthesize images;

- (void) setImage:(UIImage *) img forType:(iToastType) type{
    if (!images) {
        images = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    
    if (img) {
        NSString *key = [NSString stringWithFormat:@"%i", type];
        [images setValue:img forKey:key];
    }
}


+ (iToastSettings *) getSharedSettings{
    if (!sharedSettings) {
        sharedSettings = [iToastSettings new];
        sharedSettings.gravity = iToastGravityCenter;
        sharedSettings.duration = iToastDurationNormal;
    }
    
    return sharedSettings;
    
}

- (id) copyWithZone:(NSZone *)zone{
    iToastSettings *copy = [iToastSettings new];
    copy.gravity = self.gravity;
    copy.duration = self.duration;
    copy.postition = self.postition;
    
    NSArray *keys = [self.images allKeys];
    
    for (NSString *key in keys){
        [copy setImage:[images valueForKey:key] forType:[key intValue]];
    }
    
    return copy;
}

@end
