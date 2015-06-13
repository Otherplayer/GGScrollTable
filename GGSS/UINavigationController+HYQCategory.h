//
//  UINavigationController+HYQCategory.h
//  HotYQ
//
//  Created by __无邪_ on 15/5/29.
//  Copyright (c) 2015年 hotyq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (HYQCategory)
- (void)applyGradientApprence;//不透明
- (void)applyGradientApprenceWithTranslucent:(BOOL)flag;//透明
- (void)applyApprenceWithBarTintColor:(UIColor *)tintColor fontColor:(UIColor *)fontColor translucent:(BOOL)flag;
- (void)setHide:(BOOL)hide;
@end
