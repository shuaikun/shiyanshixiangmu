
//
//  ITTImageStatisticsAjustmentFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 5/3/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageHistogramAjustmentFilter.h"

@implementation ITTImageHistogramAjustmentFilter

/* 直方均衡 
 * 算法：http://hi.baidu.com/lwb198609_love/blog/item/cff284205096a0ffd6cae223.html
 */
-(UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
//    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
//    
//    NSMutableArray *statistic = [NSMutableArray array];
//    for (int i = 0; i <= 255; i++) {
//        [statistic addObject:[NSNumber numberWithInt:0]];
//    }
//    
//    for(GLuint row = 0;row< imageData.height;row++){
//        
//        for (GLuint col = 0; col<imageData.width; col++) {
//            
//            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
//            int gray = pixel.red * 0.3 + pixel.green * 0.6 + pixel.blue * 0.1;
//            int currentGray = [[statistic objectAtIndex:gray] intValue];
//            [statistic replaceObjectAtIndex:gray withObject:[NSNumber numberWithInt:currentGray+1]];
//        }
//    }
//    //ITTDINFO(@"statistic:%@",statistic);
//    int pixelCount = imageData.height * imageData.width;
//    NSMutableArray *ratio = [NSMutableArray array];
//    
//    [ratio addObject:[NSNumber numberWithInt:0]];
//    for (int i = 1; i <= 255; i++) {
//        float ratioValue = [[statistic objectAtIndex:i] intValue]*1.0/pixelCount + [[ratio objectAtIndex:i-1] floatValue];
//        [ratio addObject:[NSNumber numberWithFloat:ratioValue]];
//    }
//    //ITTDINFO(@"ratio:%@",ratio);
//    
//    NSMutableArray *newValue = [NSMutableArray array];
//    for (int i = 0; i <= 255; i++) {
//        [newValue addObject:[NSNumber numberWithFloat:[[ratio objectAtIndex:i] floatValue] * 255]];
//    }
//    //ITTDINFO(@"newValue:%@",newValue);
//    
//    for(GLuint row = 0;row< imageData.height;row++){
//        
//        for (GLuint col = 0; col<imageData.width; col++) {
//            
//            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
//            pixel.red = [[newValue objectAtIndex:pixel.red] floatValue];
//            pixel.green = [[newValue objectAtIndex:pixel.green] floatValue];
//            pixel.blue = [[newValue objectAtIndex:pixel.blue] floatValue];
//            
//            [imageData setPixelValue:pixel];
//        }
//    }
    
    ITTImagePixelData *imageData = [self getFilteredImageData];
    
    UIImage *processedImage = [imageData generateImage];
    [self onFilterProcessEnded];
    return processedImage;
}

- (ITTImagePixelData*)getFilteredImageData{
    [self onFilterProcessStarted];
    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
    
    NSMutableArray *statistic = [NSMutableArray array];
    for (int i = 0; i <= 255; i++) {
        [statistic addObject:@0];
    }
    
    for(GLuint row = 0;row< imageData.height;row++){
        
        for (GLuint col = 0; col<imageData.width; col++) {
            
            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
            int gray = pixel.red * 0.3 + pixel.green * 0.6 + pixel.blue * 0.1;
            int currentGray = [statistic[gray] intValue];
            statistic[gray] = @(currentGray+1);
        }
    }
    //ITTDINFO(@"statistic:%@",statistic);
    int pixelCount = imageData.height * imageData.width;
    NSMutableArray *ratio = [NSMutableArray array];
    
    [ratio addObject:@0];
    for (int i = 1; i <= 255; i++) {
        float ratioValue = [statistic[i] intValue]*1.0/pixelCount + [ratio[i-1] floatValue];
        [ratio addObject:@(ratioValue)];
    }
    //ITTDINFO(@"ratio:%@",ratio);
    
    NSMutableArray *newValue = [NSMutableArray array];
    for (int i = 0; i <= 255; i++) {
        [newValue addObject:@([ratio[i] floatValue] * 255)];
    }
    //ITTDINFO(@"newValue:%@",newValue);
    
    for(GLuint row = 0;row< imageData.height;row++){
        
        for (GLuint col = 0; col<imageData.width; col++) {
            
            ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
            pixel.red = [newValue[pixel.red] floatValue];
            pixel.green = [newValue[pixel.green] floatValue];
            pixel.blue = [newValue[pixel.blue] floatValue];
            
            [imageData setPixelValue:pixel];
        }
    }
    
    [self onFilterProcessEnded];
    return imageData;
}

+ (NSString*)getFilterName{
    return @"直方均衡";
}
@end
