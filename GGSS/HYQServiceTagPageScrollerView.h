//
//  HYQServiceTagPageScrollerView.h
//  HotYQ
//
//  Created by he on 15/5/28.
//  Copyright (c) 2015年 hotyq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYQServiceTagPageScrollerView;

@protocol HYQServiceTagPageScrollerViewDelegate <NSObject>

- (void)scrollerView:(HYQServiceTagPageScrollerView *)scrollerView selectServiceTagAtIndex:(NSInteger)index tagBtn:(UIButton *)button;

@end

@interface HYQServiceTagPageScrollerView : UIScrollView


@property (nonatomic, assign) id <HYQServiceTagPageScrollerViewDelegate> tagDelegate;


- (void)serviceTagLayout:(NSArray *)serviceData;
// 滑动列表对应哪一个的标签
- (void)moveRedsListAtTag:(NSInteger)index;
// 设置当前选中标签的状态
- (void)setCurrentSelectTag:(NSInteger)index;

@end
