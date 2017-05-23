//
//  CoverFlowDemoViewController.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 3/27/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "CoverFlowDemoViewController.h"
#import "ITTImageDataOperation.h"
#import "ITTImageCacheManager.h"
#import "UIImage+ITTAdditions.h"
#import "iCarousel.h"
#import "FXImageView.h"
#import "UIImage+FX.h"
#import "AppDelegate.h"
#import "HomeTabBarController.h"

@interface CoverFlowDemoViewController ()<UIActionSheetDelegate>
{
    NSMutableArray *_imageUrls;    
}

@property (nonatomic, strong) IBOutlet UIBarItem *orientationBarItem;
@property (strong, nonatomic) IBOutlet iCarousel *carousel;

@end

@implementation CoverFlowDemoViewController
#pragma mark - private methods

#pragma mark - lifecycle methods

- (void)setup
{
    self.navTitle = @"cover flow demo";
    _imageUrls = [[NSMutableArray alloc ] initWithObjects:
                  @"http://i0.sinaimg.cn/qc/572/2011/0406/U7055P33T572D4F24198DT20120326100856.jpg",
                  @"http://i2.sinaimg.cn/qc/572/2011/0406/U7055P33T572D4F24202DT20120326100856.jpg",
                  @"http://i1.sinaimg.cn/qc/572/2011/0406/U7055P33T572D4F24206DT20120326103335.jpg",
                  @"http://i2.sinaimg.cn/qc/572/2011/0406/U7055P33T572D4F24210DT20120326181928.jpg",
                  @"http://i3.sinaimg.cn/qc/572/2011/0406/U7055P33T572D4F24214DT20120326180737.jpg",
                  @"http://i0.sinaimg.cn/qc/572/2011/0406/U7055P33T572D4F24198DT20120326100856.jpg",
                  @"http://i2.sinaimg.cn/qc/572/2011/0406/U7055P33T572D4F24202DT20120326100856.jpg",
                  @"http://i1.sinaimg.cn/qc/572/2011/0406/U7055P33T572D4F24206DT20120326103335.jpg",
                  @"http://i2.sinaimg.cn/qc/572/2011/0406/U7055P33T572D4F24210DT20120326181928.jpg",
                  @"http://i3.sinaimg.cn/qc/572/2011/0406/U7055P33T572D4F24214DT20120326180737.jpg",
                  nil];
}

- (id)init
{
    self = [super initWithNibName:@"CoverFlowDemoViewController" bundle:nil];
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
    self.carousel.type = iCarouselTypeInvertedTimeMachine;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark iCarousel methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_imageUrls count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    FXImageView *imageView = nil;
    //create new view if no view is available for recycling
    if (view == nil)
    {
        CGFloat width = 200;
        CGFloat height = 400;
        imageView = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.asynchronous = FALSE;
        imageView.reflectionScale = 0.5f;
        imageView.reflectionAlpha = 0.25f;
        imageView.reflectionGap = 5.0f;
        imageView.shadowOffset = CGSizeMake(0.0f, 2.0f);
        imageView.shadowBlur = 5.0f;
        imageView.processedImage = [[UIImage imageNamed:@"default_image_news_top.png"] imageScaledToFitSize:CGSizeMake(width, height)];
//        imageView.cornerRadius = 10.0f;
    }
    else {
        imageView = (FXImageView*)view;
    }
    //show placeholder
//    [imageView loadImage:[_imageUrls objectAtIndex:index]];
    [imageView loadImage:[_imageUrls objectAtIndex:index]];
    return imageView;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    ITTDINFO(@"selected index %d", index);
}

- (IBAction)switchCarouselType
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Carousel Type"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Linear", @"Rotary", @"Inverted Rotary", @"Cylinder", @"Inverted Cylinder", @"Wheel", @"Inverted Wheel", @"CoverFlow", @"CoverFlow2", @"Time Machine", @"Inverted Time Machine", @"Custom", nil];
    [sheet showInView:self.view];
}

- (IBAction)toggleOrientation
{
    //carousel orientation can be animated
    [UIView beginAnimations:nil context:nil];
    self.carousel.vertical = !self.carousel.vertical;
    [UIView commitAnimations];
    
    //update button
    self.orientationBarItem.title = self.carousel.vertical? @"Vertical": @"Horizontal";
}

#pragma mark -
#pragma mark UIActionSheet methods
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0)
    {
        //map button index to carousel type
        iCarouselType type = buttonIndex;
        
        //carousel can smoothly animate between types
        [UIView beginAnimations:nil context:nil];
        self.carousel.type = type;
        [UIView commitAnimations];
        
        //update title
        self.navTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
}
@end