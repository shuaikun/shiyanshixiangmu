//
//  ImageProcessingDemoViewController.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/24/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDemoViewController.h"
#import "ITTImageFilterEffectView.h"
#import "ITTImageFilters.h"

@interface ImageProcessingDemoViewController : BaseDemoViewController<ITTImageFilterEffectViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
