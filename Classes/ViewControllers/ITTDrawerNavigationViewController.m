//
//  ITTNavigationViewController.m
//  TestNavigationViewController
//
//  Created by lian jie on 3/21/13.
//  Copyright (c) 2013 ITT. All rights reserved.
//

#import "ITTDrawerNavigationViewController.h"
#import "UIView+ITTAdditions.h"

#define INIT_ALPHA 0.3
#define INIT_SCALE 0.95
#define MIN_LEFT_TO_POP 100

@interface ITTDrawerNavigationViewController ()
{
    NSMutableArray          *_images;
    UIImageView             *_lastImageView;
    UIImageView             *_currentImageView;
    UIPanGestureRecognizer  *_panGR;
}
@end

@implementation ITTDrawerNavigationViewController

#pragma mark - lifecycle methods
- (void)dealloc
{
    [self.view removeGestureRecognizer:_panGR];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [_images removeLastObject];
    return [super popViewControllerAnimated:animated];
}

- (void)saveCurrentScreen
{
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    [_images addObject:[self captureCurrentScreenShot]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"currentVC:%@", [self.viewControllers lastObject]);
    [self saveCurrentScreen];
    [self enablePanToPopViewController];
    [super pushViewController:viewController animated:animated];    
}


#pragma mark - public methods
- (void)enablePanToPopViewController
{
    if (!_panGR) {
        _panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self.view addGestureRecognizer:_panGR];
    }
}

#pragma mark - private methods
- (BOOL)canPanToPop
{
    return ([self.viewControllers count] > 1);
}

-(UIImage *)captureCurrentScreenShot
{
    CGSize size = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    }else{
        UIGraphicsBeginImageContext(size);
    }
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (UIImage *)getLastScreenShot
{
    if (_images && [_images count] > 0) {
        return [_images lastObject];
    }
    return nil;
}

- (void)hideContentView
{
    for(UIView *subview in [self.view subviews]){
        subview.alpha = 0;
    }
}

- (void)showContentView
{
    for(UIView *subview in [self.view subviews]){
        subview.alpha = 1;
    }
}

-(void)handleGesture:(UIPanGestureRecognizer*)recognizer
{
    if (![self canPanToPop]) {
        return;
    }
    CGFloat viewWidth = self.view.bounds.size.width;
    CGFloat viewHeight = self.view.bounds.size.height;
    if (!_currentImageView) {
        _currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    }
    if (!_lastImageView) {
        _lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    }
    
    UIView *topView = _currentImageView;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            ITTDINFO(@"UIGestureRecognizerStateBegan");
            _currentImageView.image = [self captureCurrentScreenShot];
            _currentImageView.frame = CGRectMake(0, 0, viewWidth, viewHeight);            
            [self hideContentView];
            
            _lastImageView.image = [self getLastScreenShot];
            _lastImageView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
            _lastImageView.alpha = INIT_ALPHA;
            _lastImageView.transform = CGAffineTransformMakeScale(INIT_SCALE, INIT_SCALE);
            if (!_lastImageView.superview) {
                [self.view addSubview:_lastImageView];
            }else{
                [self.view bringSubviewToFront:_lastImageView];
            }
            
            if (!_currentImageView.superview) {
                [self.view addSubview:_currentImageView];
            }else{
                [self.view bringSubviewToFront:_currentImageView];
            }
            
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint translation = [recognizer translationInView:self.view];
            
            topView.left = topView.left + translation.x;
            topView.left = MAX(0, topView.left);
            float currentAlpha = ((topView.right -  viewWidth)/viewWidth) * (1-INIT_ALPHA) + INIT_ALPHA;
            _lastImageView.alpha = currentAlpha;
            
            float currentScale = ((topView.right -  viewWidth)/viewWidth) * (1-INIT_SCALE) + INIT_SCALE;
            _lastImageView.transform = CGAffineTransformMakeScale(currentScale, currentScale);            
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            ITTDINFO(@"UIGestureRecognizerStateEnded");            
            [self onPanFinishOrCancel:topView];
            break;
        }
        case UIGestureRecognizerStateCancelled:{
            ITTDINFO(@"UIGestureRecognizerStateCancelled");                        
            [self onPanFinishOrCancel:topView];
            break;
        }            
        default:
            [self onPanFinishOrCancel:topView];
            break;
    }
    
}
- (void)onPanFinishOrCancel:(UIView*)topView
{
    if (_currentImageView.left > MIN_LEFT_TO_POP) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _currentImageView.left = 320;
            _lastImageView.alpha = 1;
            _lastImageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self popViewControllerAnimated:NO];
            [_lastImageView removeFromSuperview];
            [_currentImageView removeFromSuperview];
            
            [self showContentView];
        }];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            _currentImageView.left = 0;
            _lastImageView.alpha = INIT_ALPHA;
            _lastImageView.transform = CGAffineTransformMakeScale(INIT_SCALE, INIT_SCALE);
        } completion:^(BOOL finished) {
            _lastImageView.alpha = 1;
            _lastImageView.transform = CGAffineTransformIdentity;
            [_lastImageView removeFromSuperview];
            [_currentImageView removeFromSuperview];
            [self showContentView];
        }];
    }
}
@end
