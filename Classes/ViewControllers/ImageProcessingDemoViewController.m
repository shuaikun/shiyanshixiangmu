//
//  ImageProcessingDemoViewController.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/24/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ImageProcessingDemoViewController.h"
#import "UIImage+ITTAdditions.h"
#import "ITTImageFilters.h"
#import "ITTImageFilterEffectView.h"
#import "AppDelegate.h"
#import "HomeTabBarController.h"

@interface ImageProcessingDemoViewController (){
    UIImage *_currentImage;
    UIImage *_coverImage;
    NSMutableArray *_filterClasses;
}
@end

@implementation ImageProcessingDemoViewController

#pragma mark - private methods
- (ITTImageFilter*)getImageFilterByFilterName:(NSString*)filterClassName withImage:(UIImage*)image
{
    ITTImageFilter *filter = nil;
    if ([filterClassName isEqualToString:NSStringFromClass([ITTImageBlackWhiteFilter class])]) {
        filter = [[ITTImageBlackWhiteFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageRevertBlackWhiteFilter class])]){
        filter = [[ITTImageRevertBlackWhiteFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageRevertFilter class])]){
        filter = [[ITTImageRevertFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageBlurFilter class])]){
        filter = [[ITTImageBlurFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageExpandFilter class])]){
        filter = [[ITTImageExpandFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageRevertFilter class])]){
        filter = [[ITTImageRevertFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageCarveFilter class])]){
        filter = [[ITTImageCarveFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageSharpenFilter class])]){
        filter = [[ITTImageSharpenFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageCartoonFilter class])]){
        filter = [[ITTImageCartoonFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageMemoryFilter class])]){
        filter = [[ITTImageMemoryFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageScanlineFilter class])]){
        filter = [[ITTImageScanlineFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageSampleHSBFilter class])]){
        filter = [[ITTImageSampleHSBFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageSampleHSBFilter class])]){
        filter = [[ITTImageSampleHSBFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageSampleHSBFilter class])]){
        filter = [[ITTImageSampleHSBFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageSampleContrastFilter class])]){
        filter = [[ITTImageSampleContrastFilter alloc] initWithImage:image withContrastChange:1.5];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageSampleRGBFilter class])]){
        filter = [[ITTImageSampleRGBFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageSampleMaskFilter class])]){
        filter = [[ITTImageSampleMaskFilter alloc] initWithImage:image withMaskImage:[UIImage imageNamed:@"imageProcessMask.png"]];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageLomoMemoryFilter class])]){
        filter = [[ITTImageLomoMemoryFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImagePencilFilter class])]){
        filter = [[ITTImagePencilFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageOilPaintFilter class])]){
        filter = [[ITTImageOilPaintFilter alloc] initWithImage:image];
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageWoodenCarveFilter class])]){
        filter = [[ITTImageWoodenCarveFilter alloc] initWithImage:image];
        
    }else if([filterClassName isEqualToString:NSStringFromClass([ITTImageHistogramAjustmentFilter class])]){
        filter = [[ITTImageHistogramAjustmentFilter alloc] initWithImage:image];
        
    }
    
    return filter;
}

- (void)setupEffectBtnScrollView
{
    NSAssert(_currentImage != nil,@"no image is selected");
    float currentX = 0;
    float currentY = 0;
    float gap = 1;
    
    // add none filter
    
    UIImage *thumbnailImage = [_currentImage imageFitInSize:CGSizeMake(90, 90)];
    
    ITTImageFilterEffectView *normalEffectView = [ITTImageFilterEffectView loadFromXib];
    normalEffectView.imageFilter = nil;
    normalEffectView.imageView.image = thumbnailImage;
    normalEffectView.nameLabel.text = @"正常";
    normalEffectView.left = currentX;
    normalEffectView.top = currentY;
    [_scrollView addSubview:normalEffectView];
    
    currentX = currentX + normalEffectView.width + gap;
    normalEffectView.delegate = self;
    
    for (NSString *filterClassName in _filterClasses) {
        ITTImageFilterEffectView *effectView = [ITTImageFilterEffectView loadFromXib];
        effectView.delegate = self;
    
        effectView.imageFilter = [self getImageFilterByFilterName:filterClassName withImage:thumbnailImage];
        effectView.left = currentX;
        effectView.top = currentY;
        [_scrollView addSubview:effectView];
        currentX = currentX + effectView.width + gap;
    }
    
    [_scrollView setContentSize:CGSizeMake(currentX - gap, _scrollView.height)];

}

#pragma mark - lifecycle methods

- (void)setup
{
    self.navTitle = @"图片处理demo";
    _filterClasses = [[NSMutableArray alloc] init];
    [_filterClasses addObject:NSStringFromClass([ITTImagePencilFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageOilPaintFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageBlurFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageSharpenFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageHistogramAjustmentFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageWoodenCarveFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageSampleContrastFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageSampleRGBFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageSampleMaskFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageSampleHSBFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageBlackWhiteFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageRevertBlackWhiteFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageRevertFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageExpandFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageScanlineFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageMemoryFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageCartoonFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageCarveFilter class])];
    [_filterClasses addObject:NSStringFromClass([ITTImageLomoMemoryFilter class])];
}

- (id)init
{
    self = [super initWithNibName:@"ImageProcessingDemoViewController" bundle:nil];
    if (self) {
        [self setup];        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AppDelegate GetAppDelegate].tabBarController.tabBarHidden = TRUE;
    UIImage *image = [UIImage imageNamed:@"imageToProcess.png"];
    //UIImage *image = [UIImage imageNamed:@"imageToProcess3.jpg"];
    int width = image.size.width;
    int height = image.size.height;
    if (width != height) {
        CGRect rect;
        if (width > height) {
            rect = CGRectMake((width-height)/2, 0, height, height);
        }else if(height > width){
            rect = CGRectMake(0, (height-width)/2, width, width);
        }else {
            rect = CGRectMake(0, 0, width, width);
        }
        
        UIImage *croppedImage = [image imageCroppedWithRect:rect];
        _currentImage = nil;
        _currentImage = [croppedImage imageFitInSize:CGSizeMake(320, 320)];
    }else {
        _currentImage = nil;
        _currentImage = [image imageFitInSize:CGSizeMake(320, 320)];
    }
    
        //UI的更新需在主线程中进行
        _imageView.image = _currentImage;
        [self setupEffectBtnScrollView];
        
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
//        UIImage *image = [UIImage imageNamed:@"imageToProcess.png"];
//        //UIImage *image = [UIImage imageNamed:@"imageToProcess3.jpg"];
//        int width = image.size.width;
//        int height = image.size.height;
//        if (width != height) {
//            CGRect rect;
//            if (width > height) {
//                rect = CGRectMake((width-height)/2, 0, height, height);
//            }else if(height > width){
//                rect = CGRectMake(0, (height-width)/2, width, width);
//            }else {
//                rect = CGRectMake(0, 0, width, width);
//            }
//            
//            UIImage *croppedImage = [image imageCroppedWithRect:rect];
//            RELEASE_SAFELY(_currentImage);
//            _currentImage = [[croppedImage imageFitInSize:CGSizeMake(320, 320)] retain];
//        }else {
//            RELEASE_SAFELY(_currentImage);
//            _currentImage = [[image imageFitInSize:CGSizeMake(320, 320)] retain];
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //UI的更新需在主线程中进行
//            _imageView.image = _currentImage;
//            [self setupEffectBtnScrollView];
//
//        });
//    });
    
}
#pragma mark - ITTImageFilterEffectViewDelegate methods
- (void)filterEffectViewClicked:(ITTImageFilterEffectView *)effectView
{
    UIImage *processedImage;
    if (!effectView.imageFilter) {
        // restore
        processedImage = _currentImage;
    }else{
        NSString *filterClassName = NSStringFromClass([effectView.imageFilter class]);
        ITTImageFilter *imageFilter = [self getImageFilterByFilterName:filterClassName withImage:_currentImage];
        processedImage = [imageFilter getFilteredImage];
    
    }
    if(processedImage){
        _imageView.image = processedImage;
    }
}
@end
