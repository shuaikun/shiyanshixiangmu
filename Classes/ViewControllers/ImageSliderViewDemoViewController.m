//
//  ImageSliderViewDemoViewController.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 3/27/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ImageSliderViewDemoViewController.h"

@interface ImageSliderViewDemoViewController ()
{
    ITTImageSliderView *_imageSliderView;
    ITTPageView        *_demoPageView;
}
@end

@implementation ImageSliderViewDemoViewController

#pragma mark - private methods

#pragma mark - lifecycle methods

- (id)init
{
    self = [super initWithNibName:@"ImageSliderViewDemoViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = TRUE;
    NSMutableArray *imageUrls = [NSMutableArray arrayWithObjects:
                                 @"http://i0.sinaimg.cn/qc/572/2011/0406/U7055P33T572D4F24198DT20120326100856.jpg",
                                 @"http://i2.sinaimg.cn/qc/572/2011/0406/U7055P33T572D4F24202DT20120326100856.jpg",
                                 @"http://i1.sinaimg.cn/qc/572/2011/0406/U7055P33T572D4F24206DT20120326103335.jpg",
                                 @"http://i2.sinaimg.cn/qc/572/2011/0406/U7055P33T572D4F24210DT20120326181928.jpg",
                                 @"http://i3.sinaimg.cn/qc/572/2011/0406/U7055P33T572D4F24214DT20120326180737.jpg",
                                 nil];
    _imageSliderView = [[ITTImageSliderView alloc] initWithFrame:CGRectMake(0, 0, 320, 167)];
    _imageSliderView.delegate = self;
    [self.view addSubview:_imageSliderView];
    [_imageSliderView setImageUrls:imageUrls];
    
    
    _demoPageView = [[ITTPageView alloc] initWithPageNum:[imageUrls count]];
    _demoPageView.top = _imageSliderView.bottom + 20;
    _demoPageView.left = (CGRectGetWidth(self.view.bounds) - CGRectGetWidth(_demoPageView.frame)) / 2;
    [self.view addSubview:_demoPageView];
    
}

#pragma mark - public methods


#pragma mark - ITTImageSliderViewDelegate

- (void)imageClickedWithIndex:(int)imageIndex
{
    ITTDINFO(@"image clicked at index:%d",imageIndex);
}

- (void)imageDidScrollWithIndex:(int)imageIndex
{
    [_demoPageView setCurrentPage:imageIndex];
}
@end
