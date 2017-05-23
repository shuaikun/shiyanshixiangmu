//
//  SZNearByBigPhotoViewController.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-24.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByBigPhotoViewController.h"
#import "ITTImageSliderView.h"
#import "SZNearByFocusPicModel.h"
#import "ITTPageView.h"
#import "NSString+ITTAdditions.h"
@interface SZNearByBigPhotoViewController ()<ITTImageSliderViewDelegate>
{
    BOOL _statusBarIsHidden;
    ITTImageSliderView  *_imageSliderView;
    ITTPageView *_pageView;
    UILabel *_titleLabel;
}
@end

@implementation SZNearByBigPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    _statusBarIsHidden = [UIApplication sharedApplication].statusBarHidden;
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *bgView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bgView];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 20, 44, 44);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"SZ_NEARBY_BACK.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(handleBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(266, 20, 44, 44);
    saveBtn.tag = 111;
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"SZ_NEARBY_SAVE.png"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(handleSaveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    NSMutableArray *pics = self.pics;
    _imageSliderView = [[ITTImageSliderView alloc]initWithFrame:CGRectMake(0, 0, 320, 225)];
    _imageSliderView.delegate = self;
    _imageSliderView.backgroundColor = [UIColor clearColor];
    _imageSliderView.placeHolderImageUrl = @"SZ_NEARBY_TOP_DEFAULT.png";
    _imageSliderView.center = CGPointMake(160, self.view.centerY-30);
    NSMutableArray *imageUrls = [[NSMutableArray alloc]init];
    for (SZNearByFocusPicModel *model in pics) {
        model.pic_url = [model.pic_url stringFormatterWithStr:@"b"];
        [imageUrls addObject:model.pic_url];
    }
    [_imageSliderView setImageUrls:imageUrls];
    
    _pageView = [[ITTPageView alloc] initWithPageNum:[imageUrls count]];
    _pageView.top = _imageSliderView.bottom + 30;
    _pageView.left = (CGRectGetWidth(self.view.bounds) - CGRectGetWidth(_pageView.frame)) / 2;
    _pageView.imageDot = @"SZ_NEARBY_DOT_GRAY.png";
    _pageView.imageDotH = @"SZ_NEARBY_DOT_WHITE.png";
    [self.view addSubview:_imageSliderView];
    [self.view addSubview:_pageView];
    [self loadBottomView];
    
    if ([imageUrls count]==1){
        _pageView.hidden = YES;
    }
    
    [(UIScrollView *)[[_imageSliderView subviews]objectAtIndex:0]setContentOffset:CGPointMake(_currentIndex*320, 0)];
    if ([self.pics count]>=_currentIndex) {
        SZNearByFocusPicModel *pic = [self.pics objectAtIndex:_currentIndex];
        if (pic!=nil) {
            _titleLabel.text = pic.title;
        }
    }
}

- (void)imageDidScrollWithIndex:(int)imageIndex
{
    [_pageView setCurrentPage:imageIndex];
    self.currentIndex = imageIndex;
    if ([self.pics count]>=imageIndex) {
        SZNearByFocusPicModel *pic = [self.pics objectAtIndex:imageIndex];
        if (pic!=nil) {
            _titleLabel.text = pic.title;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)handleBackClick:(id)sender
{
    [[UIApplication sharedApplication]setStatusBarHidden:_statusBarIsHidden];
    _imageSliderView.hidden = YES;
    [self popMasterViewController];
}

- (void)loadBottomView
{
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-44, 320, 44)];
    grayView.backgroundColor = RGBCOLOR(60, 60, 60);
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    if ([self.pics count]!=0) {
        SZNearByFocusPicModel *pic = [self.pics objectAtIndex:0];
        if (pic!=nil) {
            _titleLabel.text = pic.title;
        }
    }
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.center = CGPointMake(160, 22);
    _titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [grayView addSubview:_titleLabel];
    [self.view addSubview:grayView];
}

- (void)handleSaveClick:(id)sender
{
    NSInteger index = self.currentIndex;
    if ([[[[_imageSliderView subviews]objectAtIndex:0] subviews]count]>=index) {
        ITTImageView *imgview = [[[[_imageSliderView  subviews]objectAtIndex:0] subviews] objectAtIndex:index];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(imgview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [[ITTPromptView sharedPromptView]showMessage:@"保存失败"];
    } else {
        [[ITTPromptView sharedPromptView]showMessage:@"保存成功"];
    }
}

@end
