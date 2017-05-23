//
//  ITTImageFilter.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTImagePixelData.h"


#define ITTImageFilterShouldLogFilterTime YES

@interface ITTImageFilter : NSObject{
    UIImage *_image;
    UIImage *_maskImage;
    NSDate *_filterStartTime;
}

#pragma mark - init methods
- (id)initWithImage:(UIImage*)image;
- (id)initWithImage:(UIImage*)image withMaskImage:(UIImage*)maskImage;
#pragma mark - public methods
//get processed image
- (UIImage*)getFilteredImage;
- (ITTImagePixelData*)getFilteredImageData;
+ (NSString*)getFilterName;
- (NSString*)getFilterName;
- (void)onFilterProcessStarted;
- (void)onFilterProcessEnded;

//ajust contrast 

- (UIImage*)adjustImage:(UIImage*)inImage 
           withContrast:(CGFloat)contrast;
- (UIImage*)adjustImage:(UIImage*)inImage 
           withContrast:(CGFloat)contrast
                   mask:(UIImage*)maskImage;
- (ITTImagePixelData*)adjustImagePixelData:(ITTImagePixelData*)inImagePixelData 
                              withContrast:(CGFloat)contrast;
- (ITTImagePixelData*)adjustImagePixelData:(ITTImagePixelData*)inImagePixelData 
                              withContrast:(CGFloat)contrast
                                      mask:(ITTImagePixelData*)maskImagePixelData;


//adjust Hue Saturation Brightness by percent
- (UIImage*)adjustImage:(UIImage*)inImage 
                withHue:(CGFloat)hueChangeRate 
             saturation:(CGFloat)saturationChangeRate 
             brightness:(CGFloat)brightnessChangeRate
                   mask:(UIImage*)maskImage;
- (UIImage*)adjustImage:(UIImage*)inImage 
                withHue:(CGFloat)hueChangeRate 
             saturation:(CGFloat)saturationChangeRate 
             brightness:(CGFloat)brightnessChangeRate;
- (ITTImagePixelData*)adjustImagePixelData:(ITTImagePixelData*)inImagePixelData
                                   withHue:(CGFloat)hueChangeRate 
                                saturation:(CGFloat)saturationChangeRate 
                                brightness:(CGFloat)brightnessChangeRate
                                      mask:(ITTImagePixelData*)maskImagePixelData;
- (ITTImagePixelData*)adjustImagePixelData:(ITTImagePixelData*)inImagePixelData 
                                   withHue:(CGFloat)hueChangeRate 
                                saturation:(CGFloat)saturationChangeRate 
                                brightness:(CGFloat)brightnessChangeRate;

//adjust Red Green Blue by percent
- (UIImage*)adjustImage:(UIImage*)inImage 
                withRed:(CGFloat)redChangeRate 
                  green:(CGFloat)greenChangeRate 
                   blue:(CGFloat)blueChangeRate
                   mask:(UIImage*)maskImage; 
- (UIImage*)adjustImage:(UIImage*)inImage 
                withRed:(CGFloat)redChangeRate 
                  green:(CGFloat)greenChangeRate 
                   blue:(CGFloat)blueChangeRate; 
- (ITTImagePixelData*)adjustImagePixelData:(ITTImagePixelData*)inImagePixelData
                                   withRed:(CGFloat)redChangeRate 
                                     green:(CGFloat)greenChangeRate 
                                      blue:(CGFloat)blueChangeRate
                                      mask:(ITTImagePixelData*)maskImagePixelData; 
- (ITTImagePixelData*)adjustImagePixelData:(ITTImagePixelData*)inImagePixelData
                                   withRed:(CGFloat)redChangeRate 
                                     green:(CGFloat)greenChangeRate 
                                      blue:(CGFloat)blueChangeRate; 

//util method for applying mask
- (BOOL)shouldProcessPixelAtPostion:(ITTImagePixelPosition)position 
                  withMaskImageData:(ITTImagePixelData*)maskData;

//blur
- (UIImage*)blurWithGaussFilter:(UIImage*)inImage;
- (ITTImagePixelData*)blurWithGaussFilterData:(ITTImagePixelData*)inImagePixelData;

//sharpen image with sharpeness
- (UIImage*)sharpen:(UIImage*)inImage withSharpeness:(float)sharpeness;
- (UIImage*)sharpenWithLaplacian:(UIImage*)inImage;
- (ITTImagePixelData*)sharpenData:(ITTImagePixelData*)inImagePixelData withSharpeness:(float)sharpeness;
- (ITTImagePixelData*)sharpenWithLaplacianData:(ITTImagePixelData*)inImagePixelData;

//blend images
- (UIImage*)blendImagesWithBottomImage:(UIImage*)bottomImage topImage:(UIImage*)topImage blendMode:(CGBlendMode)blendMode alpha:(float)alpha;

- (void)convolution3x3FilterWithImageData:(ITTImagePixelData*)imageData 
                                   filter:(int*)filter
                              filterScale:(int)filterScale;
//获取二值化图像
- (UIImage*)getTwoColorImageWithImage:(UIImage*)inImage divisionValue:(int)divisionValue;
- (ITTImagePixelData*)getTwoColorImageWithImageData:(ITTImagePixelData*)inImagePixelData divisionValue:(int)divisionValue;

@end
