//
//  CustomTabBar.h
//  AiQiChe
//
//  Created by lian jie on 7/5/11.
//  Copyright 2011 iTotem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTXibView.h"

@protocol ITTCustomTabBarViewDelegate;

@interface ITTTabBarView : ITTXibView
{

}

@property (nonatomic, weak) id<ITTCustomTabBarViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

+ (ITTTabBarView*)viewFromNib;

- (void)notifyDelegate:(NSInteger)index;
- (BOOL)shouldSelectTab:(NSInteger)index;

@end


@protocol ITTCustomTabBarViewDelegate <NSObject>

@optional
- (void)customTabBar:(ITTTabBarView*)tabBar selectedIndex:(NSInteger)index;
- (BOOL)customTabBarWillSelect:(ITTTabBarView*)tabBar selectedIndex:(NSInteger)index;

@end
