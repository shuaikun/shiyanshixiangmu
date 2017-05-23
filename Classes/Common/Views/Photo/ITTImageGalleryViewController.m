//
//  ITTImageGalleryViewController.m
//  
//
//  Created by lian jie on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ITTImageGalleryViewController.h"
#import "ITTImageInfo.h"

@interface ITTImageGalleryViewController()
- (void)dismiss;
- (ITTImageZoomableView *)dequeueRecycledPage;
- (void)recycleImageViews;
- (void)setupPageForIndex:(int)index;
- (int)getImageCount;
- (int)getPreviouIndex;
- (int)getNextIndex;
- (CGRect)frameForPageAtIndex:(NSInteger)index;
- (CGRect)frameForPageAtIndex:(NSInteger)index orientation:(UIInterfaceOrientation)orientation;
- (BOOL)shouldShowPageForIndex:(int)index;
- (BOOL)isShowingPageForIndex:(int)index;
- (ITTImageZoomableView*)pageForIndex:(int)index;
- (void)restoreZoomScaleForInvisiblePages;
- (void)clearPage;
- (void)setImageScrollViewContentSize;
- (void)setImageScrollViewContentSizeForOrientation:(UIInterfaceOrientation)orientation;
- (void)adjustImageAlphaWhenScrolled;
- (void)toggleThumbnail;
@end

@implementation ITTImageGalleryViewController

#pragma mark - object lifecycle
- (void)dealloc
{
    _currentIndex = 0;
}
- (id)initWithImages:(NSArray*)images
       selectedIndex:(int)selectedIndex
               title:(NSString*)title
{
    
    self = [super initWithNibName:@"ITTImageGalleryViewController" bundle:nil];
    if (self) {
        _recycledViewSet = [[NSMutableSet alloc] init];
        _images = [[NSMutableArray alloc] initWithArray:images];
        _initSelectedIndex = selectedIndex;
        _titleString = title;
        _isShowingThumbnail = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - private methods
- (void)showView:(UIView*)view FromAlpha:(float)alpha1 To:(float)alpha2 withTime:(float)time
{
    NSTimeInterval animationDuration = time;
    view.alpha = alpha1;
	[UIView beginAnimations:@"ShowAlpha" context:nil];
	[UIView setAnimationDuration:animationDuration];
    view.alpha = alpha2;
	[UIView commitAnimations];
}

- (void)toggleThumbnail
{
    [UIView animateWithDuration:0.3f 
                     animations:^{
                         if (_isShowingThumbnail) {
                             _navView.bottom = _imageScrollView.top;
                             _thumbnailScrollView.top = _imageScrollView.bottom;
                             _isShowingThumbnail = NO;
                         }else{
                             _navView.top = 0;
                             _thumbnailScrollView.bottom = _imageScrollView.bottom;
                             _isShowingThumbnail = YES;
                         }
                     }];
}

- (void)clearPage
{
    [_recycledViewSet removeAllObjects];
    [_imageScrollView removeAllSubviews];
    [_thumbnailScrollView removeAllSubviews];
}

- (void)dismiss
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self clearPage];
    
    if (ITTIsModalViewController(self)) {
		[self dismissViewControllerAnimated:TRUE completion:NULL];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (int)getImageCount
{
    return [_images count];
}

- (int)getPreviouIndex
{
    return MAX(0, _currentIndex - 1);
}

- (int)getNextIndex
{
    return MIN([self getImageCount] - 1, _currentIndex + 1);
}

- (BOOL)shouldShowPageForIndex:(int)index
{
    return (index == _currentIndex || 
            index == [self getPreviouIndex] || 
            index == [self getNextIndex]);
}

- (ITTImageZoomableView *)dequeueRecycledPage
{
    ITTImageZoomableView *page = [_recycledViewSet anyObject];
    if (page) {
        [_recycledViewSet removeObject:page];
    }else{
        //create one
        page = [[ITTImageZoomableView alloc] initWithFrame:_imageScrollView.bounds];
        page.tapDelegate = self;
        page.index = -1;
    }
    return page;
}

- (ITTImageZoomableView*)pageForIndex:(int)index
{
    ITTImageZoomableView *page = nil;
    for (UIView *view in [_imageScrollView subviews]) {
        if (![view isKindOfClass:[ITTImageZoomableView class]]) {
            continue;
        }
        int indexOfView = ((ITTImageZoomableView*)view).index;
        if (indexOfView == index) {
            page = (ITTImageZoomableView*)view;
            break;
        }
    }
    return page;
}

- (CGRect)frameForPageAtIndex:(NSInteger)index
{
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    return [self frameForPageAtIndex:index orientation:currentOrientation];
}

- (CGRect)frameForPageAtIndex:(NSInteger)index orientation:(UIInterfaceOrientation)orientation
{
    CGRect bounds;
	CGFloat screenHeight = _imageScrollView.frame.size.height;
    if (orientation == UIInterfaceOrientationPortrait){
        bounds = CGRectMake(0, 0, 320, screenHeight);
    }else{
        bounds = CGRectMake(0, 0, 480, screenHeight);
    }
	CGRect pageFrame = bounds;
	pageFrame.origin.x = (bounds.size.width * index);
	return pageFrame;
}

- (void)recycleImageViews
{
    //recycle big image views
    for (UIView *view in [_imageScrollView subviews]) {
        if (![view isKindOfClass:[ITTImageZoomableView class]]) {
            continue;
        }
        int indexOfView = ((ITTImageZoomableView*)view).index;
        if (![self shouldShowPageForIndex:indexOfView]) {
            [_recycledViewSet addObject:view];
            [(ITTImageZoomableView*)view cancelImageRequest];
            [view removeFromSuperview];
            ITTDINFO(@"page %d is recycled,current recycled object:%d", indexOfView,[_recycledViewSet count]);
            
        }
    }
    
}
- (BOOL)isShowingPageForIndex:(int)index
{
    BOOL isShowing = NO;
    for (UIView *view in [_imageScrollView subviews]) {
        if (![view isKindOfClass:[ITTImageZoomableView class]]) {
            continue;
        }
        int indexOfView = ((ITTImageZoomableView*)view).index;
        if (indexOfView == index) {
            isShowing = YES;
            break;
        }
    }
    return  isShowing;
}

- (void)restoreZoomScaleForInvisiblePages
{
    
    for (UIView *view in [_imageScrollView subviews]) {
        if (![view isKindOfClass:[ITTImageZoomableView class]]) {
            continue;
        }
        
        int indexOfView = ((ITTImageZoomableView*)view).index;
        if (indexOfView == _currentIndex) {
            continue;
        }
        [(ITTImageZoomableView*)view setZoomScale:[(ITTImageZoomableView*)view minimumZoomScale] animated:YES];
    }
}

- (void)adjustImageAlphaWhenScrolled
{
    for (UIView *view in [_imageScrollView subviews]) {
        if (![view isKindOfClass:[ITTImageZoomableView class]]) {
            continue;
        }
        
        int indexOfView = ((ITTImageZoomableView*)view).index;
        if (indexOfView == _currentIndex) {
            [UIView animateWithDuration:0.2 animations:^{
                ((ITTImageZoomableView*)view).alpha = 1;
            }];
        }else{
            ((ITTImageZoomableView*)view).alpha = 0.9;
        }
    }
}

- (void)setupPageForIndex:(int)index
{
    if ([self isShowingPageForIndex:index]) {
        return;
    }
    ITTDINFO(@"_imageScrollView.frame %@ _imageScrollView.bounds %@ _imageScrollView.contentSize %@", NSStringFromCGRect(_imageScrollView.frame), NSStringFromCGRect(_imageScrollView.bounds), NSStringFromCGSize(_imageScrollView.contentSize));
    ITTImageZoomableView *page = [self dequeueRecycledPage];
    if (page.index != index) {
        ITTDINFO(@"reusing page: original index is %d, new index is %d", page.index , index);
        page.frame = [self frameForPageAtIndex:index];
        page.index = index;
        [_imageScrollView addSubview:page];
        if([_images count]>index)
        {
            [page displayImage:_images[index]];
        }
    }else{
        ITTDINFO(@"reusing page directly");
    }
}

- (void)hiddenAlertView
{
    [self showView:_alertView FromAlpha:1.0 To:0.0 withTime:0.5];
}

- (void)tilePages
{
	// Calculate which pages are visible
	CGRect visibleBounds = _imageScrollView.bounds;
	_currentIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    
	_currentIndex = MAX(_currentIndex,0);
	_currentIndex = MIN(_currentIndex,[self getImageCount] + 1);
    /*
    BOOL shouldUpdate = NO;
    if (_oldCurrentIndex != _currentIndex) {
        shouldUpdate = YES;
        _oldCurrentIndex = _currentIndex;
    }
    if (!shouldUpdate) {
        return;
    }
    */
    [self recycleImageViews];
    
    [self setupPageForIndex:_currentIndex];
    [self setupPageForIndex:[self getNextIndex]];
    [self setupPageForIndex:[self getPreviouIndex]];
    
    if (_currentIndex == [_images count]-1) {
        [self showView:_alertView FromAlpha:0.0 To:1.0 withTime:0.5];
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hiddenAlertView) userInfo:nil repeats:NO];
    }
}

- (void)setImageScrollViewContentSize
{
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self setImageScrollViewContentSizeForOrientation:currentOrientation];
}

- (void)setImageScrollViewContentSizeForOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationPortrait){
        _titleLabel.frame = CGRectMake(107, 3, 114, 37);
    }else{
        _titleLabel.frame = CGRectMake(187, 3, 114, 37);
    }
    CGRect frame = _imageScrollView.frame;
    _imageScrollView.contentSize = CGSizeMake(frame.size.width * [self getImageCount], frame.size.height );
}

#pragma mark - ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self tilePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_thumbnailScrollView scrollToIndex:_currentIndex];
    [self restoreZoomScaleForInvisiblePages];
    [self adjustImageAlphaWhenScrolled];
}
#pragma mark - public methods

- (IBAction)backBtnClicked:(id)sender
{
    [self dismiss];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    _titleLabel.text = _titleString;
    _thumbnailScrollView.datasource = self;
    _thumbnailScrollView.selectionDelegate = self;    
    
    _alertView = [[UIView alloc] initWithFrame:CGRectMake(90, 180, 140, 60)];
    _alertView.alpha = 0.0;
    _alertView.backgroundColor = [UIColor clearColor];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 60)];
    bgView.alpha = 0.5;
    bgView.backgroundColor = [UIColor blackColor];
    bgView.layer.cornerRadius = 10;
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 60)];
    alertLabel.backgroundColor = [UIColor clearColor];
    alertLabel.font = [UIFont systemFontOfSize:11];
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.text = @"这已经是本图组最后一张图";
    alertLabel.textAlignment = NSTextAlignmentCenter;
    
    [_alertView addSubview:bgView];
    [_alertView addSubview:alertLabel];
    [self.view addSubview:_alertView];
    // scroll to current index
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setImageScrollViewContentSize];
    [self tilePages];    
    if (_initSelectedIndex >= 0) {
        CGRect targetFrame = [self frameForPageAtIndex:_initSelectedIndex];
        [_imageScrollView setContentOffset:targetFrame.origin animated:NO];
        [_thumbnailScrollView scrollToIndex:_initSelectedIndex];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    _indexBeforeRotation = _currentIndex;
    BOOL shouldRotate = (interfaceOrientation == UIInterfaceOrientationPortrait 
                         || interfaceOrientation == UIInterfaceOrientationLandscapeLeft
                         || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
    return shouldRotate;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setImageScrollViewContentSizeForOrientation:toInterfaceOrientation];
    for (UIView *view in [_imageScrollView subviews]) {
        if (![view isKindOfClass:[ITTImageZoomableView class]]) {
            continue;
        }
        ITTImageZoomableView *page = (ITTImageZoomableView*)view;
        if (page.index == _currentIndex) {
            [UIView animateWithDuration:duration animations:^{
                page.frame = [self frameForPageAtIndex:page.index];
                [page setMaxMinZoomScalesForCurrentBounds];
                //[page restoreCenterPoint:[page pointToCenterAfterRotation] scale:[page scaleToRestoreAfterRotation]];
            }];
            [page setZoomScale:page.minimumZoomScale animated:NO];
        }else{
            page.frame = [self frameForPageAtIndex:page.index];
        }
    }
    _currentIndex = _indexBeforeRotation;
    CGRect currentPageRect =  [self frameForPageAtIndex:_currentIndex];
    [_imageScrollView setContentOffset:currentPageRect.origin animated:NO];
}

#pragma mark - ITTImageGalleryThumbnailScrollViewDelegate

- (void)thumbnailScrollView:(ITTImageGalleryThumbnailScrollView*)thumbnailScrollView
            imageSelectedAtIndex:(int)index
{
    CGRect targetFrame = [self frameForPageAtIndex:index];
    [_imageScrollView setContentOffset:targetFrame.origin animated:NO];
}
#pragma mark - ITTImageGalleryThumbnailScrollViewDatasource

- (NSString*)thumbnailScrollView:(ITTImageGalleryThumbnailScrollView*)thumbnailScrollView
                      imageUrlAtIndex:(int)index
{
    if([_images count]>index)
    {
        return ((ITTImageInfo*)_images[index]).smallUrl;
    }
    return NULL;
}

- (int)numberOfImagesInThumbnailScrollView:(ITTImageGalleryThumbnailScrollView*)thumbnailScrollView
{
    return [_images count];
}

#pragma mark - ImageZoomableViewDelegate

- (void)imageZoomableViewSingleTapped:(ITTImageZoomableView*)imageZoomableView
{
    [self toggleThumbnail];
}
@end
