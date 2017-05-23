//
//  ITTImageGalleryThumbnailScrollView.h
//  
//
//  Created by lian jie on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ITTImageGalleryThumbnailScrollViewDelegate;
@protocol ITTImageGalleryThumbnailScrollViewDatasource;

@interface ITTImageGalleryThumbnailScrollView : UIScrollView <UIScrollViewDelegate>{
//    id<ITTImageGalleryThumbnailScrollViewDatasource> _datasource;
//    id<ITTImageGalleryThumbnailScrollViewDelegate> _selectionDelegate;
    NSMutableSet *_recycledViewSet;
    int _oldFirstIndex;
    int _oldLastIndex;
}
@property (nonatomic,weak) id<ITTImageGalleryThumbnailScrollViewDatasource> datasource;
@property (nonatomic,weak) id<ITTImageGalleryThumbnailScrollViewDelegate> selectionDelegate;

- (void)scrollToIndex:(int)index;
@end

@protocol ITTImageGalleryThumbnailScrollViewDatasource <NSObject>
- (NSString*)thumbnailScrollView:(ITTImageGalleryThumbnailScrollView*)thumbnailScrollView
                      imageUrlAtIndex:(int)index;
- (int)numberOfImagesInThumbnailScrollView:(ITTImageGalleryThumbnailScrollView*)thumbnailScrollView;
@end

@protocol ITTImageGalleryThumbnailScrollViewDelegate <NSObject>
@optional
- (void)thumbnailScrollView:(ITTImageGalleryThumbnailScrollView*)thumbnailScrollView
            imageSelectedAtIndex:(int)index;
@end