//
//  HYQServiceTagPageScrollerView.m
//  HotYQ
//
//  Created by he on 15/5/28.
//  Copyright (c) 2015年 hotyq. All rights reserved.
//

#import "HYQServiceTagPageScrollerView.h"
#define DEFAULT_TAG_FONT 14
#define SELECT_TAG_FONT 16
#define HEAD_HEIGHT 44

@interface HYQServiceTagPageScrollerView ()
{
    NSMutableArray *_tagViews;
    CGFloat _firstTagGap;      // 第一个标签的x轴
    UIColor *_tagColor;        // 标签颜色
    UIColor *_tagSelectColor;  // 选中标签的颜色
    NSArray *_tagDataSource;   // 标签原数据
    NSInteger _tempIndex;      // 记录上一个点击的标签的下标
}

@end

@implementation HYQServiceTagPageScrollerView



- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // 水平滑动条
        self.showsHorizontalScrollIndicator = NO;
        _tagColor = [UIColor colorFromHexRGB:@"4d4d4d"];
        _tagSelectColor = [UIColor redColor];
        _firstTagGap = 10;
    }
    return self;
}


- (void)serviceTagLayout:(NSArray *)serviceData {
    
    // 线条
    UIView *plane = [[UIView alloc] initWithFrame:CGRectMake(0, HEAD_HEIGHT - 1, self.bounds.size.width * 4, 1)];
    [plane setBackgroundColor:[UIColor colorFromHexRGB:@"cccccc"]];
    [self addSubview:plane];
    
    _tagDataSource = serviceData;
    _tagViews = nil;
    _tagViews = [[NSMutableArray alloc] init];
    
    CGFloat widthResult = 0.0f;
    
    for (NSString *text in serviceData) {
        
        CGFloat width = [self widthForInputViewWithText:text font:DEFAULT_TAG_FONT];
        widthResult += width;
    }
    // 如果标签 总数没有大于一屏幕 则平分
    if (widthResult <= kScreenWidth) {
        
        CGFloat btnWidth = kScreenWidth / serviceData.count;
        
        for (int i = 0; i < serviceData.count; i++) {
            
            UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [tagBtn setFrame:CGRectMake(btnWidth * i, 0, btnWidth, self.frame.size.height)];
            UIFont *tegFont = [UIFont fontWithName:@"Arial" size:DEFAULT_TAG_FONT];
            [tagBtn.titleLabel setFont:tegFont];
            [tagBtn setTitleColor:_tagColor forState:UIControlStateNormal];
            [tagBtn setTitleColor:_tagSelectColor forState:UIControlStateSelected];
            [tagBtn addTarget:self action:@selector(tagButtonTag:) forControlEvents:UIControlEventTouchUpInside];
            [tagBtn setTitle:[serviceData objectAtIndex:i] forState:UIControlStateNormal];
            [self addSubview:tagBtn];
            [_tagViews addObject:tagBtn];
            tagBtn.tag = [_tagViews indexOfObject:tagBtn];
        }
    } else {
        for (int i = 0; i < serviceData.count; i++) {
            
            NSString *tagTitle = [serviceData objectAtIndex:i];
            CGFloat x = [self posXForObjectNextToLastTagView];
            UIButton *tagBtn = [self tagButtonWithTag:tagTitle posX:x];
            [_tagViews addObject:tagBtn];
            tagBtn.tag = [_tagViews indexOfObject:tagBtn];
        }
    }
    CGFloat x = [self posXForObjectNextToLastTagView];
    self.contentSize = CGSizeMake(x , 20);
}

// 滑动列表对应哪一个的标签
- (void)moveRedsListAtTag:(NSInteger)index{
    
    UIButton *selectTag = [_tagViews objectAtIndex:index];
    if (selectTag.selected != 1) {
        [self selectTagStateForTag:selectTag];
    }
}

// 点击某个标签
- (void)tagButtonTag:(UIButton *)sender{
    
    if (sender.selected != 1) {
        [self selectTagStateForTag:sender];
    }
}

- (void)selectTagStateForTag:(UIButton *)button{
    
    // 现在点击标签的上一个 还原状态
//    [self restoreSelectTagFontWithState];
    _tempIndex = button.tag;
        // 代理回传点击标签的下标
        if ([self.tagDelegate respondsToSelector:@selector(scrollerView:selectServiceTagAtIndex:tagBtn:)]) {
            [self.tagDelegate scrollerView:self selectServiceTagAtIndex:button.tag tagBtn:button];
        }
    
    // 当前点中得标签 改变状态
    [self setCurrentSelectTag:button.tag];
}

- (void)setCurrentSelectTag:(NSInteger)index {
    
    NSLog(@" ------ %ld",index);
    
    // 当前点中得标签 改变状态
    UIButton *button = [_tagViews objectAtIndex:index];
    button.selected = !button.selected;
    [button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:SELECT_TAG_FONT]];
//    UIButton *selectTag = [_tagViews objectAtIndex:button.tag];
//    [self changeSelectTagFontWithState:selectTag];
    
    for (UIButton *btn in _tagViews) {
        UIButton *tagBtn = [_tagViews objectAtIndex:button.tag];
        if (btn != tagBtn) {
            btn.selected = NO;
            [btn.titleLabel setFont:[UIFont fontWithName:@"Arial" size:DEFAULT_TAG_FONT]];
        }
    }
    
//    // 代理回传点击标签的下标
//    if ([self.tagDelegate respondsToSelector:@selector(scrollerView:selectServiceTagAtIndex:tagBtn:)]) {
//        [self.tagDelegate scrollerView:self selectServiceTagAtIndex:button.tag tagBtn:button];
//    }
    
    // 发送通知监听标签移动
    NSString *indexStr = [NSString stringWithFormat:@"%ld",index];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self, @"scrollerView", indexStr, @"index", button, @"button", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"currentTagIndex" object:nil userInfo:dic];
}


- (void)restoreSelectTagFontWithState{
    UIButton *tagBtn = [_tagViews objectAtIndex:_tempIndex];
    CGFloat x = tagBtn.frame.origin.x;
    CGFloat width = [self widthForInputViewWithText:[_tagDataSource objectAtIndex:tagBtn.tag] font:DEFAULT_TAG_FONT];
    [tagBtn setFrame:CGRectMake(x, tagBtn.bounds.origin.y, width, tagBtn.frame.size.height)];
}


// 改变选中的标签状态及字体大小
- (void)changeSelectTagFontWithState:(UIButton *)button{
    CGFloat x = button.frame.origin.x;
    CGFloat width = [self widthForInputViewWithText:[_tagDataSource objectAtIndex:button.tag] font:SELECT_TAG_FONT];
    [button setFrame:CGRectMake(x, button.bounds.origin.y, width, button.frame.size.height)];
}


#pragma mark - 计算label文本size
- (CGFloat)serviceTagSizeForText:(NSString *)text font:(CGFloat)font height:(CGFloat)height{
    
    UIFont *font1 = [UIFont fontWithName:@"Arial" size:font];
    NSDictionary *fDic = [NSDictionary dictionaryWithObject:font1 forKey:NSFontAttributeName];
    NSAttributedString *fAttri = [[NSAttributedString alloc] initWithString:text attributes:fDic];
    CGSize fcontraint = CGSizeMake(150, height);
    CGRect fRect = [fAttri boundingRectWithSize:fcontraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize fSize = fRect.size;
    return fSize.width;
}

- (CGFloat)widthForInputViewWithText:(NSString *)text font:(CGFloat)font
{
    UIFont *font1 = [UIFont fontWithName:@"Arial" size:font];
    return MAX(20.0, [text sizeWithAttributes:@{NSFontAttributeName:font1}].width + 30);
}


#pragma mark - 设置每个元素的样式
- (UIButton *)tagButtonWithTag:(NSString *)text posX:(CGFloat)posX
{
    UIFont *tegFont = [UIFont fontWithName:@"Arial" size:DEFAULT_TAG_FONT];
    UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tagBtn.titleLabel setFont:tegFont];
    [tagBtn setTitleColor:_tagColor forState:UIControlStateNormal];
    [tagBtn setTitleColor:_tagSelectColor forState:UIControlStateSelected];
    [tagBtn addTarget:self action:@selector(tagButtonTag:) forControlEvents:UIControlEventTouchUpInside];
    [tagBtn setTitle:text forState:UIControlStateNormal];
    
    
    CGRect btnFrame = tagBtn.frame;
    btnFrame.origin.x = posX;
    btnFrame.origin.y = 0;
    btnFrame.size.width = [self widthForInputViewWithText:text font:DEFAULT_TAG_FONT];
    btnFrame.size.height = self.frame.size.height;
    tagBtn.frame = CGRectIntegral(btnFrame);
    [self addSubview:tagBtn];
    
    return tagBtn;
}

// 获取下一个标签的x坐标
- (CGFloat)posXForObjectNextToLastTagView
{
    CGFloat accumX = _firstTagGap;
    
    if (_tagViews.count > 0) {
        UIView *lastTag = _tagViews.lastObject;
        accumX = lastTag.frame.origin.x + lastTag.frame.size.width;
        return accumX;
    }
    return 0;
}


@end
