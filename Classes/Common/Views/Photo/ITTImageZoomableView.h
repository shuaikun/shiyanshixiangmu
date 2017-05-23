//
//  ImageScrollView.h
//  AiQiChe
//
//  Created by lian jie on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ITTImageView.h"
#import "ITTImageInfo.h"
@protocol ITTImageZoomableViewDelegate;
@interface ITTImageZoomableView : UIScrollView <UIScrollViewDelegate> {
    ITTImageView *_imageView;
    int _index;
    BOOL _canClickScale;     //if the maxscale equals to minscale, the image can't support click enlarge
//    id<ITTImageZoomableViewDelegate> _tapDelegate;
}

@property (nonatomic, assign) int index;
@property (nonatomic, weak) id<ITTImageZoomableViewDelegate> tapDelegate;

- (void)displayImage:(ITTImageInfo*)image;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;
- (void)cancelImageRequest;
- (void)setMaxMinZoomScalesForCurrentBounds;

@end

@protocol ITTImageZoomableViewDelegate <NSObject>

@optional
- (void)imageZoomableViewSingleTapped:(ITTImageZoomableView*)imageZoomableView;

@end