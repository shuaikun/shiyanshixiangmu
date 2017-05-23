//
//  ITTImageGalleryViewController.h
//  
//
//  Created by lian jie on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTImageZoomableView.h"
#import "ITTImageGalleryThumbnailScrollView.h"
#import "BaseDemoViewController.h"

@interface ITTImageGalleryViewController : BaseDemoViewController <UIScrollViewDelegate,ITTImageGalleryThumbnailScrollViewDatasource,ITTImageGalleryThumbnailScrollViewDelegate,ITTImageZoomableViewDelegate>{
    NSMutableArray *_images;
    int _initSelectedIndex;
    int _currentIndex;
    int _indexBeforeRotation;
    UIScrollView *_imageScrollView;
    ITTImageGalleryThumbnailScrollView *_thumbnailScrollView;
    UIView *_navView;
    NSMutableSet *_recycledViewSet;
    BOOL _isShowingThumbnail;
    
    UILabel *_titleLabel;
    NSString *_titleString;
    UIView *_alertView;
}

@property (nonatomic, strong) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, strong) IBOutlet ITTImageGalleryThumbnailScrollView *thumbnailScrollView;
@property (nonatomic, strong) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (id)initWithImages:(NSArray*)images 
       selectedIndex:(int)selectedIndex 
               title:(NSString*)title;
- (IBAction)backBtnClicked:(id)sender;
@end
