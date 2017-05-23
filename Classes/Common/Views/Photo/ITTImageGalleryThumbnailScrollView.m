//
//  ITTImageGalleryThumbnailScrollView.m
//  
//
//  Created by lian jie on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ITTImageGalleryThumbnailScrollView.h"
#import "ITTImageView.h"

@interface ITTImageGalleryThumbnailScrollView()
- (void)handleTap:(UITapGestureRecognizer *)sender;
- (int)getImageCount;
- (ITTImageView *)dequeueRecycledPage;
- (void)recycleImageViews;
- (void)setupPageForIndex:(int)index;
- (CGRect)frameForImageViewAtIndex:(int)index;
- (void)setPages;
- (BOOL)shouldShowPageForIndex:(int)index;
- (BOOL)isShowingPageForIndex:(int)index;
- (int)getFirstVisibleIndex;
- (int)getLastVisibleIndex;
- (int)getImageViewIndexWithFrame:(CGRect)frame;
- (NSString*)getImageUrlAtIndex:(int)index;
- (int)tagForIndex:(int)index;
- (int)indexForTag:(int)tag;
@end

#define PHOTO_THUMBNAIL_SCROLL_VIEW_TAG_BASE 10000
#define PHOTO_THUMBNAIL_SCROLL_VIEW_PADDING 10
#define PHOTO_THUMBNAIL_SCROLL_VIEW_IMAGE_WIDTH 110

@implementation ITTImageGalleryThumbnailScrollView

#pragma mark - private methods
- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded){     
		int index = [self indexForTag:sender.view.tag];
        if (_selectionDelegate && [_selectionDelegate respondsToSelector:@selector(thumbnailScrollView:imageSelectedAtIndex:)]) {
            [_selectionDelegate thumbnailScrollView:self imageSelectedAtIndex:index];
            [self scrollToIndex:index];
        }
    } 
}

- (int)tagForIndex:(int)index
{
    return index + PHOTO_THUMBNAIL_SCROLL_VIEW_TAG_BASE;
}

- (int)indexForTag:(int)tag
{
    return tag - PHOTO_THUMBNAIL_SCROLL_VIEW_TAG_BASE;
}

- (int)getImageCount
{
    return [_datasource numberOfImagesInThumbnailScrollView:self];
}

- (CGRect)frameForImageViewAtIndex:(int)index
{
    CGFloat x = index * (PHOTO_THUMBNAIL_SCROLL_VIEW_IMAGE_WIDTH + PHOTO_THUMBNAIL_SCROLL_VIEW_PADDING);
    return CGRectMake(x, 5, PHOTO_THUMBNAIL_SCROLL_VIEW_IMAGE_WIDTH, self.bounds.size.height - 10);
}

- (int)getFirstVisibleIndex
{
    int firstIndex = floorf(CGRectGetMinX(self.bounds) / (PHOTO_THUMBNAIL_SCROLL_VIEW_IMAGE_WIDTH + PHOTO_THUMBNAIL_SCROLL_VIEW_PADDING)) - 1;
    return MAX(0,firstIndex);
}

- (int)getLastVisibleIndex
{
    int lastIndex = floorf(CGRectGetMaxX(self.bounds) / (PHOTO_THUMBNAIL_SCROLL_VIEW_IMAGE_WIDTH + PHOTO_THUMBNAIL_SCROLL_VIEW_PADDING)) + 1;
    return MIN(lastIndex, [self getImageCount] - 1);
}

- (int)getImageViewIndexWithFrame:(CGRect)frame
{
    return floorf(frame.origin.x/ (PHOTO_THUMBNAIL_SCROLL_VIEW_IMAGE_WIDTH + PHOTO_THUMBNAIL_SCROLL_VIEW_PADDING));
}

- (BOOL)shouldShowPageForIndex:(int)index
{
    int firstVisibleIndex = [self getFirstVisibleIndex];
    int lastVisibleIndex = [self getLastVisibleIndex];
    return (index >= firstVisibleIndex && index <= lastVisibleIndex);
}

- (BOOL)isShowingPageForIndex:(int)index
{
    BOOL isShowing = NO;
    if ([self viewWithTag:[self tagForIndex:index]]) {
        isShowing = YES;
    }
    return isShowing;
}

- (NSString*)getImageUrlAtIndex:(int)index
{
    return [_datasource thumbnailScrollView:self imageUrlAtIndex:index];
}

- (void)recycleImageViews
{
    //recycle big image views
    for (UIView *view in [self subviews]) {
        if (![view isKindOfClass:[ITTImageView class]]) {
            continue;
        }
        int indexOfView =[self indexForTag:view.tag];
        
        if (![self shouldShowPageForIndex:indexOfView]) {
            [_recycledViewSet addObject:view];
            [(ITTImageView*)view cancelCurrentImageRequest];
            [view removeFromSuperview];
            ITTDINFO(@"thumbnail %d is recycled,current recycled object:%d", indexOfView,[_recycledViewSet count]);
            
        }
    }
    
}

- (ITTImageView *)dequeueRecycledPage
{
    ITTImageView *page = [_recycledViewSet anyObject];
    if (page) {
        [_recycledViewSet removeObject:page];
    }else{
        //create one
        CGRect firstViewFrame = [self frameForImageViewAtIndex:0];
        
        // make sure the index is negtive
        firstViewFrame.origin.x = - PHOTO_THUMBNAIL_SCROLL_VIEW_IMAGE_WIDTH;
        page = [[ITTImageView alloc] initWithFrame:firstViewFrame];
        page.userInteractionEnabled = YES;
        page.contentMode = UIViewContentModeScaleAspectFit;
        page.image = ImageNamed(@"default_image_thumbnail_140.png");
        page.tag = -1;
        
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [page addGestureRecognizer:tapRec];
    }
    return page;
}

- (void)setupPageForIndex:(int)index
{
    if ([self isShowingPageForIndex:index]) {
        return;
    }
    ITTImageView *page = [self dequeueRecycledPage];
    int indexOfPage = [self getImageViewIndexWithFrame:page.frame];
    if (indexOfPage != index) {
        ITTDINFO(@"reusing thumbnail page: original index is %d, new index is %d", indexOfPage , index);
        page.frame = [self frameForImageViewAtIndex:index];
        [self addSubview:page];
       // [page loadImage:[self getImageUrlAtIndex:index]];
        UIImage *placeHolderImage = [UIImage imageNamed:@"default_image_thumbnail_140.png"];
        [page loadImage:[self getImageUrlAtIndex:index] placeHolder:placeHolderImage];
        page.tag = [self tagForIndex:index];
    }else{
        ITTDINFO(@"reusing thumbnail page directly");
    }
}

- (void)setPages
{
	int firstIndex = [self getFirstVisibleIndex];
	int lastIndex = [self getLastVisibleIndex];
    BOOL shouldUpdateView = NO;
    if (_oldFirstIndex != firstIndex) {
        shouldUpdateView = YES;
        _oldFirstIndex = firstIndex;
    }
    if (_oldLastIndex != lastIndex) {
        shouldUpdateView = YES;
        _oldLastIndex = lastIndex;
    }
    if (!shouldUpdateView) {
        return;
    }
    [self recycleImageViews];
    for (int i = firstIndex; i <= lastIndex; i++) {
        [self setupPageForIndex:i];
    }
}

#pragma mark - lifecycle methods
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _recycledViewSet = [[NSMutableSet alloc] init];
        _oldFirstIndex = -1;
        _oldLastIndex = -1;
    }
    return self;
}

- (void)dealloc
{
    _datasource = nil;
    _selectionDelegate = nil;
}

#pragma mark - public methods
- (void)scrollToIndex:(int)index
{
    ITTDINFO(@"scroll thumbnail to index:%d",index);
    CGRect targetFrame = [self frameForImageViewAtIndex:index];
    CGFloat centerX = targetFrame.origin.x + targetFrame.size.width/2;
    [self setContentOffset:CGPointMake(centerX - self.width/2, 0) animated:YES];
}

- (void)setDatasource:(id<ITTImageGalleryThumbnailScrollViewDatasource>)datasource
{
    _datasource = datasource;
    self.delegate = self;
    self.contentSize = CGSizeMake([self getImageCount] * (PHOTO_THUMBNAIL_SCROLL_VIEW_IMAGE_WIDTH + PHOTO_THUMBNAIL_SCROLL_VIEW_PADDING), self.bounds.size.height);
    [self setPages];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	//[self setNeedsDisplay];
	[self setPages];
}
@end
