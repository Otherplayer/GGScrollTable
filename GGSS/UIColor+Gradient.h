//
//  UIColor+Gradient.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Gradient)
//渐变左右方向
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;

// 自上而下
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 height:(int)height;

@end
