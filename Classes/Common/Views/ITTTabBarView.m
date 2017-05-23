//
//  CustomTabBar.m
//  AiQiChe
//
//  Created by lian jie on 7/5/11.
//  Copyright 2011 iTotem. All rights reserved.
//

#import "ITTTabBarView.h"

@interface ITTTabBarView()
{
    UIButton        *_selectedButton;
}

@end

@implementation ITTTabBarView

#pragma mark - lifecycle
+ (ITTTabBarView*)viewFromNib
{
    return [[self class] loadFromXib];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - public methods

- (BOOL)shouldSelectTab:(NSInteger)index
{
    BOOL shouldSelect = TRUE;
    if (_delegate && [_delegate respondsToSelector:@selector(customTabBarWillSelect:selectedIndex:)]) {
        shouldSelect = [_delegate customTabBarWillSelect:self selectedIndex:index];
    }
    return shouldSelect;
}

- (void)notifyDelegate:(NSInteger)index
{
    if (_delegate && [_delegate respondsToSelector:@selector(customTabBar:selectedIndex:)]) {
        [_delegate customTabBar:self selectedIndex:index];
    }
}

@end
