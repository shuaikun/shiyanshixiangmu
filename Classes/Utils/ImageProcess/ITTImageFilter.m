//
//  ITTImageFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageFilter.h"
#import "UIColor-Expanded.h"
#import "UIImage+ITTAdditions.h"

@implementation ITTImageFilter

#pragma mark - lifecycle methods
- (void)dealloc{
    [_filterStartTime release];
    [_image release];
    [_maskImage release];
    [super dealloc];
}
- (id)initWithImage:(UIImage*)image{
    self = [super init];
    if (self) {
        _image = [image retain];
    }
    return self;
}
- (id)initWithImage:(UIImage*)image withMaskImage:(UIImage*)maskImage{
    self = [self initWithImage:image];
    if (self) {
        _maskImage = [maskImage retain];
    }
    return self;
}

#pragma mark - public methods
//get processed image
//should be override by subclass
- (UIImage*)getFilteredImage{
    ITTDERROR(@"you should override this method");
    return _image;
}

- (UIImage*)getFilteredImageData{
    ITTDERROR(@"you should override this method");
    return nil;
}
+ (NSString*)getFilterName{
    ITTDERROR(@"you should override this method");
    return nil;
}
- (NSString*)getFilterName{
    return [[self class] getFilterName];
}
- (void)onFilterProcessStarted{
    RELEASE_SAFELY(_filterStartTime);
    _filterStartTime = [[NSDate date] retain];
}
- (void)onFilterProcessEnded{
    if (ITTImageFilterShouldLogFilterTime && _filterStartTime) {
        ITTDINFO(@"filter[%@] finished in %f seconds",NSStringFromClass([self class]),[[NSDate date] timeIntervalSinceDate:_filterStartTime]);
    }
}

#pragma mark - 调整对比度
/* 调整对比度
 * 算法：http://apps.hi.baidu.com/share/detail/50155628
 * TODO:可根据网页中算法进行优化
 */
- (UIImage*)adjustImage:(UIImage*)inImage 
           withContrast:(CGFloat)contrast{
    return [self adjustImage:inImage withContrast:contrast mask:nil];
}
- (UIImage*)adjustImage:(UIImage*)inImage 
           withContrast:(CGFloat)contrast
                   mask:(UIImage*)maskImage{
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:inImage] autorelease];
    GLuint w = imageData.width;
    GLuint h = imageData.height;
    
    //prepare mask
    BOOL hasMask = NO;
    ITTImagePixelData *maskData = nil;
    if (maskImage) {
        hasMask = YES;
        UIImage *adjustedImageMask = [maskImage imageScaleToFillInSize:inImage.size];
        maskData = [[[ITTImagePixelData alloc] initWithImage:adjustedImageMask] autorelease];
    }
    
    for(GLuint row = 0;row< h;row++){
        
        for (GLuint col = 0; col<w; col++) {
            ITTImagePixelPosition currentPostion = ITTImagePixelPositionMake(row, col);
            
            if (hasMask) {
                BOOL shouldProcessThisPixel = [self shouldProcessPixelAtPostion:currentPostion withMaskImageData:maskData];
                if (!shouldProcessThisPixel) {
                    continue;
                }
            }
            
            ITTImagePixel pixel = [imageData getPixelAtPostion:currentPostion];
            
            pixel.red = (int)(128 + (pixel.red-128)*contrast);
            pixel.green = (int)(128 + (pixel.green-128)*contrast);
            pixel.blue = (int)(128 + (pixel.blue-128)*contrast);
            [imageData setPixelValue:pixel];
        }
    }
    return [imageData generateImage];
}

- (ITTImagePixelData*)adjustImagePixelData:(ITTImagePixelData*)inImagePixelData 
                              withContrast:(CGFloat)contrast{
    return [self adjustImagePixelData:inImagePixelData withContrast:contrast mask:nil];
}

- (ITTImagePixelData*)adjustImagePixelData:(ITTImagePixelData*)inImagePixelData 
                              withContrast:(CGFloat)contrast
                                      mask:(ITTImagePixelData*)maskImagePixelData{
    ITTImagePixelData *imageData = inImagePixelData;
    GLuint w = imageData.width;
    GLuint h = imageData.height;
    
    //prepare mask
    BOOL hasMask = NO;
    ITTImagePixelData *maskData = nil;
    if (maskImagePixelData) {
        hasMask = YES;
        maskData = [[[ITTImagePixelData alloc] initWithImagePixels:[maskImagePixelData getPixelData] imageWidth:w imageHeight:h
                     ] autorelease];
    }
    
    for(GLuint row = 0;row< h;row++){
        
        for (GLuint col = 0; col<w; col++) {
            ITTImagePixelPosition currentPostion = ITTImagePixelPositionMake(row, col);
            
            if (hasMask) {
                BOOL shouldProcessThisPixel = [self shouldProcessPixelAtPostion:currentPostion withMaskImageData:maskData];
                if (!shouldProcessThisPixel) {
                    continue;
                }
            }
            
            ITTImagePixel pixel = [imageData getPixelAtPostion:currentPostion];
            
            pixel.red = (int)(128 + (pixel.red-128)*contrast);
            pixel.green = (int)(128 + (pixel.green-128)*contrast);
            pixel.blue = (int)(128 + (pixel.blue-128)*contrast);
            [imageData setPixelValue:pixel];
        }
    }
    return imageData;    
}

- (BOOL)shouldProcessPixelAtPostion:(ITTImagePixelPosition)position 
                   withMaskImageData:(ITTImagePixelData*)maskData{
    BOOL shouldProcess = NO;
    if (position.row >= 0 && position.row < maskData.height 
        && position.column >= 0 && position.column < maskData.width) {
        ITTImagePixel pixel = [maskData getPixelAtPostion:position];
        if (pixel.gray == 0) {
            // is black color
            shouldProcess = YES;
        }
    }
    return shouldProcess;
}

#pragma mark - 调整RGB强度
/* 调整RGB强度
 * 算法：改变每个像素点的颜色空间
 */
- (UIImage*)adjustImage:(UIImage*)inImage 
                withRed:(CGFloat)redChangeRate 
                  green:(CGFloat)greenChangeRate 
                   blue:(CGFloat)blueChangeRate{
    return [self adjustImage:inImage 
                     withRed:redChangeRate
                       green:greenChangeRate
                        blue:blueChangeRate 
                        mask:nil];
}

- (UIImage*)adjustImage:(UIImage*)inImage 
                withRed:(CGFloat)redChangeRate 
                  green:(CGFloat)greenChangeRate 
                   blue:(CGFloat)blueChangeRate
                   mask:(UIImage*)maskImage{
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:inImage] autorelease];
    GLuint w = imageData.width;
    GLuint h = imageData.height;
    
    //prepare mask
    BOOL hasMask = NO;
    ITTImagePixelData *maskData = nil;
    if (maskImage) {
        hasMask = YES;
        UIImage *adjustedImageMask = [maskImage imageScaleToFillInSize:inImage.size];
        maskData = [[[ITTImagePixelData alloc] initWithImage:adjustedImageMask] autorelease];
    }
    
    
    for(GLuint row = 0;row< h;row++){
        
        for (GLuint col = 0; col<w; col++) {
            ITTImagePixelPosition currentPostion = ITTImagePixelPositionMake(row, col);
            
            if (hasMask) {
                
                BOOL shouldProcessThisPixel = [self shouldProcessPixelAtPostion:currentPostion
                                               withMaskImageData:maskData];
                if (!shouldProcessThisPixel) {
                    continue;
                }
            }
            ITTImagePixel pixel = [imageData getPixelAtPostion:currentPostion];
            
            pixel.red = pixel.red * redChangeRate;
            pixel.green = pixel.green * greenChangeRate;
            pixel.blue = pixel.blue * blueChangeRate;
            [imageData setPixelValue:pixel];
        }
    }
    
    return [imageData generateImage];
}

- (ITTImagePixelData*)adjustImagePixelData:(ITTImagePixelData*)inImagePixelData
                                   withRed:(CGFloat)redChangeRate 
                                     green:(CGFloat)greenChangeRate 
                                      blue:(CGFloat)blueChangeRate
{
    return [self adjustImagePixelData:inImagePixelData
                              withRed:redChangeRate
                                green:greenChangeRate
                                 blue:blueChangeRate
                                 mask:nil];
}

- (ITTImagePixelData*)adjustImagePixelData:(ITTImagePixelData*)inImagePixelData
                                   withRed:(CGFloat)redChangeRate 
                                     green:(CGFloat)greenChangeRate 
                                      blue:(CGFloat)blueChangeRate
                                      mask:(ITTImagePixelData*)maskImagePixelData
{
    ITTImagePixelData *imageData = inImagePixelData;
    GLuint w = imageData.width;
    GLuint h = imageData.height;
    
    //prepare mask
    BOOL hasMask = NO;
    ITTImagePixelData *maskData = nil;
    if (maskImagePixelData) {
        hasMask = YES;
        maskData = [[[ITTImagePixelData alloc] initWithImagePixels:[maskImagePixelData getPixelData] imageWidth:w imageHeight:h
                     ] autorelease];
    }    
    
    for(GLuint row = 0;row< h;row++){
        
        for (GLuint col = 0; col<w; col++) {
            ITTImagePixelPosition currentPostion = ITTImagePixelPositionMake(row, col);
            
            if (hasMask) {
                
                BOOL shouldProcessThisPixel = [self shouldProcessPixelAtPostion:currentPostion
                                                              withMaskImageData:maskData];
                if (!shouldProcessThisPixel) {
                    continue;
                }
            }
            ITTImagePixel pixel = [imageData getPixelAtPostion:currentPostion];
            
            pixel.red = pixel.red * redChangeRate;
            pixel.green = pixel.green * greenChangeRate;
            pixel.blue = pixel.blue * blueChangeRate;
            [imageData setPixelValue:pixel];
        }
    }
    
    return imageData;
}

#pragma mark - 调整色相、饱和度、亮度
/* 调整色相、饱和度、亮度
 * 算法：改变每个像素点的颜色空间
 */
- (UIImage*)adjustImage:(UIImage*)inImage 
                withHue:(CGFloat)hueChangeRate 
             saturation:(CGFloat)saturationChangeRate 
             brightness:(CGFloat)brightnessChangeRate{
    return [self adjustImage:inImage 
                     withHue:hueChangeRate 
                  saturation:saturationChangeRate 
                  brightness:brightnessChangeRate
                        mask:nil];
}

- (UIImage*)adjustImage:(UIImage*)inImage 
                withHue:(CGFloat)hueChangeRate 
             saturation:(CGFloat)saturationChangeRate 
             brightness:(CGFloat)brightnessChangeRate
                   mask:(UIImage*)maskImage{
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:inImage] autorelease];
    GLuint w = imageData.width;
    GLuint h = imageData.height;
    
    //prepare mask
    BOOL hasMask = NO;
    ITTImagePixelData *maskData = nil;
    if (maskImage) {
        hasMask = YES;
        UIImage *adjustedImageMask = [maskImage imageScaleToFillInSize:inImage.size];
        maskData = [[[ITTImagePixelData alloc] initWithImage:adjustedImageMask] autorelease];
    }
    
    for(GLuint row = 0;row< h;row++){
        
        for (GLuint col = 0; col<w; col++) {
            ITTImagePixelPosition currentPostion = ITTImagePixelPositionMake(row, col);
            
            if (hasMask) {
                
                BOOL shouldProcessThisPixel = [self shouldProcessPixelAtPostion:currentPostion
                                                              withMaskImageData:maskData];
                if (!shouldProcessThisPixel) {
                    continue;
                }
            }
            
            ITTImagePixel pixel = [imageData getPixelAtPostion:currentPostion];
            
            CGFloat newH,newS,newB;
            [UIColor red:pixel.red/255.0 green:pixel.green/255.0 blue:pixel.blue/255.0 toHue:&newH saturation:&newS brightness:&newB];
            newH = newH * hueChangeRate;
            newS = newS * saturationChangeRate;
            newB = newB * brightnessChangeRate;
            CGFloat newR,newG,newBlue;
            [UIColor hue:newH saturation:newS brightness:newB toRed:&newR green:&newG blue:&newBlue];
            pixel.red = newR * 255;
            pixel.green = newG * 255;
            pixel.blue = newBlue * 255;
            
            [imageData setPixelValue:pixel];
        }
    }

    return [imageData generateImage];
}

- (ITTImagePixelData*)adjustImagePixelData:(ITTImagePixelData*)inImagePixelData 
                                   withHue:(CGFloat)hueChangeRate 
                                saturation:(CGFloat)saturationChangeRate 
                                brightness:(CGFloat)brightnessChangeRate{
    return [self adjustImagePixelData:inImagePixelData
                              withHue:hueChangeRate
                           saturation:saturationChangeRate
                           brightness:brightnessChangeRate
                                 mask:nil];
}

- (ITTImagePixelData*)adjustImagePixelData:(ITTImagePixelData*)inImagePixelData
                                   withHue:(CGFloat)hueChangeRate 
                                saturation:(CGFloat)saturationChangeRate 
                                brightness:(CGFloat)brightnessChangeRate
                                      mask:(ITTImagePixelData*)maskImagePixelData{
    
    ITTImagePixelData *imageData = inImagePixelData;
    GLuint w = imageData.width;
    GLuint h = imageData.height;
    
    //prepare mask
    BOOL hasMask = NO;
    ITTImagePixelData *maskData = nil;
    if (maskImagePixelData) {
        hasMask = YES;
        maskData = [[[ITTImagePixelData alloc] initWithImagePixels:[maskImagePixelData getPixelData] imageWidth:w imageHeight:h
                     ] autorelease];
    }
    
    for(GLuint row = 0;row< h;row++){
        
        for (GLuint col = 0; col<w; col++) {
            ITTImagePixelPosition currentPostion = ITTImagePixelPositionMake(row, col);
            
            if (hasMask) {
                
                BOOL shouldProcessThisPixel = [self shouldProcessPixelAtPostion:currentPostion
                                                              withMaskImageData:maskData];
                if (!shouldProcessThisPixel) {
                    continue;
                }
            }
            
            ITTImagePixel pixel = [imageData getPixelAtPostion:currentPostion];
            
            CGFloat newH,newS,newB;
            [UIColor red:pixel.red/255.0 green:pixel.green/255.0 blue:pixel.blue/255.0 toHue:&newH saturation:&newS brightness:&newB];
            newH = newH * hueChangeRate;
            newS = newS * saturationChangeRate;
            newB = newB * brightnessChangeRate;
            CGFloat newR,newG,newBlue;
            [UIColor hue:newH saturation:newS brightness:newB toRed:&newR green:&newG blue:&newBlue];
            pixel.red = newR * 255;
            pixel.green = newG * 255;
            pixel.blue = newBlue * 255;
            
            [imageData setPixelValue:pixel];
        }
    }
    
    return imageData;
}


- (UIImage*)blendImagesWithBottomImage:(UIImage*)bottomImage topImage:(UIImage*)topImage blendMode:(CGBlendMode)blendMode alpha:(float)alpha{
    
    CGSize newSize = CGSizeMake(CGImageGetWidth(bottomImage.CGImage), (CGImageGetHeight(bottomImage.CGImage)));
    
    UIGraphicsBeginImageContext( newSize );
    // Use existing opacity as is
    
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Apply supplied opacity
    
    [topImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:blendMode alpha:alpha];
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

//根据 3 * 3 滤波器filter matrix进行卷积计算
- (void)convolution3x3FilterWithImageData:(ITTImagePixelData*)imageData 
                                   filter:(int*)filter
                              filterScale:(int)filterScale{
    int filterWidth = 3;
    //int filterTotalRow = 3;
    for(GLuint row = 0;row< imageData.height;row++){
        
        for (GLuint col = 0; col < imageData.width; col++) {
            
            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)] ;
            
            float newR = 0.0;
            float newG = 0.0;
            float newB = 0.0;   
            for (int i = -1; i <=1 ; i++) {
                for (int j = -1; j<= 1; j++) {
                    int filterRow = row + i;
                    int filterCol = col + j;
                    if (filterRow < 0 || filterRow >= imageData.height || filterCol < 0 || filterCol>= imageData.width) {
                        continue;
                    }
                    ITTImagePixel fpixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(filterRow, filterCol)] ;
                    
                    int filterParam = filter[(i+1)*filterWidth + (j+1)];
                    
                    //ITTDINFO(@"filterParam:%d,%d,%f",i+1,j+1,filterParam);
                    newR += filterParam * (float)fpixel.red;
                    newG += filterParam * (float)fpixel.green;
                    newB += filterParam * (float)fpixel.blue;
                }
            }
            pixel.red = newR/filterScale;
            pixel.green = newG/filterScale;
            pixel.blue = newB/filterScale;
            //ITTDINFO(@"r,g,b:%f,%f,%f",newR,newG,newB);
            [imageData setPixelValue:pixel];
        }
    }
}

#pragma mark - 模糊效果 
/* 模糊效果 
 * 算法：线性滤波器
 */
- (UIImage*)blurWithGaussFilter:(UIImage*)inImage{
    
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:inImage] autorelease];
    
    int gaussFilter[] = {
        1,2,1,
        2,4,2,
        1,2,1
    };
    [self convolution3x3FilterWithImageData:imageData 
                                     filter:gaussFilter
                                filterScale:16];
    
    return [imageData generateImage];
}

- (ITTImagePixelData*)blurWithGaussFilterData:(ITTImagePixelData*)inImagePixelData{
    
    ITTImagePixelData *imageData = inImagePixelData;
    
    int gaussFilter[] = {
        1,2,1,
        2,4,2,
        1,2,1
    };
    [self convolution3x3FilterWithImageData:imageData 
                                     filter:gaussFilter
                                filterScale:16];
    
    return imageData;
}

#pragma mark - 锐化效果 
/* 锐化效果 
 * 算法：http://dev.yesky.com/SoftChannel/72342371928637440/20050105/1896848.shtml
 */
- (UIImage*)sharpen:(UIImage*)inImage withSharpeness:(float)sharpeness{
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:inImage] autorelease];
    
    for(GLuint row = 0;row< imageData.height;row++){
        
        for (GLuint col = 0; col < imageData.width; col++) {
            
            if (col > 0  && col < imageData.width-1 && row > 0 && row < imageData.height-1) {
                ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
                //is not border pixels
                ITTImagePixel topLeftPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row-1, col-1)];

                ITTImagePixel topPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row-1, col)];
                
                ITTImagePixel topRightPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row-1, col+1)];
                
                ITTImagePixel leftPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col-1)];
                
                ITTImagePixel rightPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col+1)];
                
                ITTImagePixel bottomLeftPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row+1, col-1)];
                
                ITTImagePixel bottomPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row+1, col)];
                
                ITTImagePixel bottomRightPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row+1, col+1)];
                
                int redAva = (int)((topLeftPixel.red + topPixel.red + topRightPixel.red + leftPixel.red + rightPixel.red + rightPixel.red + bottomLeftPixel.red + bottomPixel.red + bottomRightPixel.red)/8.0);
                int redDelta = pixel.red - redAva;
                pixel.red = pixel.red + sharpeness * redDelta;
                
                
                int greenAva = (int)((topLeftPixel.green + topPixel.green + topRightPixel.green + leftPixel.green + rightPixel.green + rightPixel.green + bottomLeftPixel.green + bottomPixel.green + bottomRightPixel.green)/8.0);
                int greenDelta = pixel.green - greenAva;
                pixel.green = pixel.green + sharpeness * greenDelta;
                
                int blueAva = (int)((topLeftPixel.blue + topPixel.blue + topRightPixel.blue + leftPixel.blue + rightPixel.blue + rightPixel.blue + bottomLeftPixel.blue + bottomPixel.blue + bottomRightPixel.blue)/8.0);
                
                int blueDelta = pixel.blue - blueAva;
                pixel.blue = pixel.blue + sharpeness * blueDelta;
                
                [imageData setPixelValue:pixel];
            }
        }
    }
    
    return [imageData generateImage];
}

- (ITTImagePixelData*)sharpenData:(ITTImagePixelData*)inImagePixelData withSharpeness:(float)sharpeness{
    
    ITTImagePixelData *imageData = inImagePixelData;
    
    for(GLuint row = 0;row< imageData.height;row++){
        
        for (GLuint col = 0; col < imageData.width; col++) {
            
            if (col > 0  && col < imageData.width-1 && row > 0 && row < imageData.height-1) {
                ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
                //is not border pixels
                ITTImagePixel topLeftPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row-1, col-1)];
                
                ITTImagePixel topPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row-1, col)];
                
                ITTImagePixel topRightPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row-1, col+1)];
                
                ITTImagePixel leftPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col-1)];
                
                ITTImagePixel rightPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col+1)];
                
                ITTImagePixel bottomLeftPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row+1, col-1)];
                
                ITTImagePixel bottomPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row+1, col)];
                
                ITTImagePixel bottomRightPixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row+1, col+1)];
                
                int redAva = (int)((topLeftPixel.red + topPixel.red + topRightPixel.red + leftPixel.red + rightPixel.red + rightPixel.red + bottomLeftPixel.red + bottomPixel.red + bottomRightPixel.red)/8.0);
                int redDelta = pixel.red - redAva;
                pixel.red = pixel.red + sharpeness * redDelta;
                
                
                int greenAva = (int)((topLeftPixel.green + topPixel.green + topRightPixel.green + leftPixel.green + rightPixel.green + rightPixel.green + bottomLeftPixel.green + bottomPixel.green + bottomRightPixel.green)/8.0);
                int greenDelta = pixel.green - greenAva;
                pixel.green = pixel.green + sharpeness * greenDelta;
                
                int blueAva = (int)((topLeftPixel.blue + topPixel.blue + topRightPixel.blue + leftPixel.blue + rightPixel.blue + rightPixel.blue + bottomLeftPixel.blue + bottomPixel.blue + bottomRightPixel.blue)/8.0);
                
                int blueDelta = pixel.blue - blueAva;
                pixel.blue = pixel.blue + sharpeness * blueDelta;
                
                [imageData setPixelValue:pixel];
            }
        }
    }
    
    return imageData;
}

/* 锐化效果 
 * 算法：拉普拉斯锐化(Laplacian , scale = 3)
 */
- (UIImage*)sharpenWithLaplacian:(UIImage*)inImage{
    
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:inImage] autorelease];
    
    int laplacianFilter[] = {
        -1,-1,-1,
        -1, 8,-1,
        -1,-1,-1
    };
    [self convolution3x3FilterWithImageData:imageData 
                                     filter:laplacianFilter
                                filterScale:3];
    
    return [imageData generateImage];
}

- (ITTImagePixelData*)sharpenWithLaplacianData:(ITTImagePixelData*)inImagePixelData{
    
    ITTImagePixelData *imageData = inImagePixelData;
    
    int laplacianFilter[] = {
        -1,-1,-1,
        -1, 8,-1,
        -1,-1,-1
    };
    [self convolution3x3FilterWithImageData:imageData 
                                     filter:laplacianFilter
                                filterScale:3];
    
    return imageData;
}

- (UIImage*)getTwoColorImageWithImage:(UIImage*)inImage divisionValue:(int)divisionValue{
    
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:inImage] autorelease];
    
    for(GLuint row = 0;row< imageData.height;row++){
        for (GLuint col = 0; col < imageData.width; col++) {
            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
            if (pixel.gray > divisionValue) {
                pixel.red = 255;
                pixel.green = 255;
                pixel.blue = 255;
            }else {
                pixel.red = 0;
                pixel.green = 0;
                pixel.blue = 0;
            }
            
            [imageData setPixelValue:pixel];
            
        }
    }
    
    return [imageData generateImage];
}

- (ITTImagePixelData*)getTwoColorImageWithImageData:(ITTImagePixelData*)inImagePixelData divisionValue:(int)divisionValue{
   
    ITTImagePixelData *imageData = inImagePixelData;
    
    for(GLuint row = 0;row< imageData.height;row++){
        for (GLuint col = 0; col < imageData.width; col++) {
            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
            if (pixel.gray > divisionValue) {
                pixel.red = 255;
                pixel.green = 255;
                pixel.blue = 255;
            }else {
                pixel.red = 0;
                pixel.green = 0;
                pixel.blue = 0;
            }
            
            [imageData setPixelValue:pixel];
            
        }
    }
    
    return imageData;
}
@end