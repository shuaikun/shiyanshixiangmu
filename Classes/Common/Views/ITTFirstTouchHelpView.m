//
//  HelpView.m
//  FengZi
//
//  Created by lt ji on 11-12-20.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define HELPIMAGE_BYEOND_WIDTH 40

#import "ITTFirstTouchHelpView.h"
#import "AppDelegate.h"
#import "ITTXibViewUtils.h"

@interface ITTFirstTouchHelpView ()
{
    NSArray                     *_iphone5ImagArray;
    NSArray                     *_helpImageArray;
    IBOutlet UIScrollView       *_scrollView;
}

@end

@implementation ITTFirstTouchHelpView


+(id)loadFromXib
{
    return [ITTXibViewUtils loadViewFromXibNamed:NSStringFromClass([self class])];
}

-(void)startHelpWithHelpImageArray:(NSArray *)imageArray iphone5ImageArray:(NSArray *)iphone5ImageArray
{
    if (iPhone5) {
        _iphone5ImagArray = iphone5ImageArray;
        for (int index = 0; index < [_iphone5ImagArray count]; index++) {
            UIImageView *helpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_iphone5ImagArray objectAtIndex:index]]];
            helpImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * index, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            [_scrollView addSubview:helpImageView];
            _scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width * [_iphone5ImagArray count] + HELPIMAGE_BYEOND_WIDTH, [UIScreen mainScreen].bounds.size.height);
        }
    }else{
       _helpImageArray = imageArray;
        for (int index = 0; index < [_helpImageArray count]; index++) {
            UIImageView *helpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_helpImageArray  objectAtIndex:index]]];
            helpImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * index, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            [_scrollView addSubview:helpImageView];
        }
        _scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width * [_helpImageArray count] + HELPIMAGE_BYEOND_WIDTH, [UIScreen mainScreen].bounds.size.height);
    }
    
    self.frame = [UIScreen mainScreen].bounds;
    UIWindow *win = [UIApplication sharedApplication].delegate.window;
    win.windowLevel = UIWindowLevelAlert;
    [win addSubview:self];
    [win bringSubviewToFront:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint currentOffset = [scrollView contentOffset];
    int scrollViewMaxOffset = 0;
    
    if (iPhone5) {
        scrollViewMaxOffset = [UIScreen mainScreen].bounds.size.width * ([_iphone5ImagArray count] - 1);
    }else{
        scrollViewMaxOffset = [UIScreen mainScreen].bounds.size.width * ([_helpImageArray count] - 1);
    }
    
    if (currentOffset.x > scrollViewMaxOffset) {
        UIWindow *win = [AppDelegate GetAppDelegate].window;
        win.windowLevel = UIWindowLevelNormal;
        [UIView animateWithDuration:0.3 
                         animations:^{
                             self.alpha = 0;
                         } 
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
}

@end
