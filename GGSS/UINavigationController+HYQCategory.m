//
//  UINavigationController+HYQCategory.m
//  HotYQ
//
//  Created by __无邪_ on 15/5/29.
//  Copyright (c) 2015年 hotyq. All rights reserved.
//

#import "UINavigationController+HYQCategory.h"
#import "UIColor+Gradient.h"
@implementation UINavigationController (HYQCategory)
- (void)applyGradientApprence{
    [self applyGradientApprenceWithTranslucent:NO];
}

- (void)applyGradientApprenceWithTranslucent:(BOOL)flag{
    UIColor *tintColor = [UIColor gradientFromColor:[UIColor colorWithRed:0.953 green:0.486 blue:0.059 alpha:1.000] toColor:[UIColor colorWithRed:0.949 green:0.000 blue:0.322 alpha:1.000] withHeight:64];
    [self applyApprenceWithBarTintColor:tintColor fontColor:[UIColor whiteColor] translucent:flag];
}



- (void)applyApprenceWithBarTintColor:(UIColor *)tintColor fontColor:(UIColor *)fontColor translucent:(BOOL)flag{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    UINavigationBar *navigationBar = self.navigationBar;
    
    [navigationBar setTitleTextAttributes:@{
                                            NSFontAttributeName : [UIFont systemFontOfSize:17.f],
                                            NSForegroundColorAttributeName : fontColor,
                                            }];
    [navigationBar setTintColor:fontColor];    //设置字体颜色
    [navigationBar setBarTintColor:tintColor]; //设置背景色
    
    //    [navigationBar setBackgroundImage:[UIImage imageNamed:@"5.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    [navigationBar setTranslucent:flag];        //关透明
    
    
//    iOS7之后由于navigationBar.translucent默认是YES，坐标零点默认在（0，0）点  当不透明的时候，零点坐标在（0，64）；如果你想设置成透明的，而且还要零点从（0，64）开始，那就添加：self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)setHide:(BOOL)hide{
    [self setNavigationBarHidden:hide animated:YES];
}
@end
