
//
//  ITTImageExpandFilter.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageExpandFilter.h"
#import "RandomUtil.h"

@implementation ITTImageExpandFilter

/* 扩散效果 
 * 算法：http://dev.yesky.com/SoftChannel/72342371928637440/20050105/1896848.shtml
 */
-(UIImage*)getFilteredImage{
    [self onFilterProcessStarted];
//    ITTImagePixelData *imageData = [[[ITTImagePixelData alloc] initWithImage:_image] autorelease];
//    
//    for(GLuint row = 0;row< imageData.height;row++){
//        for (GLuint col = 0; col<imageData.width; col++) {
//            
//            if (col > 0  && col < imageData.width-1 && row > 0 && row < imageData.height-1) {
//                ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
//                
//                ITTImagePixelPosition position;
//                int replacement = RANDOM_INT(0, 7);
//                switch (replacement) {
//                    case 0:{
//                        position = ITTImagePixelPositionMake(row-1, col-1);
//                        break;
//                    }
//                    case 1:{
//                        position = ITTImagePixelPositionMake(row-1, col);
//                        break;
//                    }
//                    case 2:{
//                        position = ITTImagePixelPositionMake(row-1, col+1);
//                        break;
//                    }
//                    case 3:{
//                        position = ITTImagePixelPositionMake(row, col-1);
//                        break;
//                    }
//                    case 4:{
//                        position = ITTImagePixelPositionMake(row, col+1);
//                        break;
//                    }
//                    case 5:{
//                        position = ITTImagePixelPositionMake(row+1, col-1);
//                        break;
//                    }
//                    case 6:{
//                        position = ITTImagePixelPositionMake(row+1, col);
//                        break;
//                    }
//                    case 7:{
//                        position = ITTImagePixelPositionMake(row+1, col+1);
//                        break;
//                    }
//                        
//                    default:
//                        ITTDERROR(@"something is wrong here!%d",replacement);
//                        break;
//                }
//                
//                ITTImagePixel replacementPixel = [imageData getPixelAtPostion:position];
//                pixel.red = replacementPixel.red;
//                pixel.green = replacementPixel.green;
//                pixel.blue = replacementPixel.blue;
//                
//                [imageData setPixelValue:pixel];
//            }
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
    
    for(GLuint row = 0;row< imageData.height;row++){
        for (GLuint col = 0; col<imageData.width; col++) {
            
            if (col > 0  && col < imageData.width-1 && row > 0 && row < imageData.height-1) {
                ITTImagePixel pixel = [imageData getPixelAtPostion:ITTImagePixelPositionMake(row, col)];
                
                ITTImagePixelPosition position;
                int replacement = RANDOM_INT(0, 7);
                switch (replacement) {
                    case 0:{
                        position = ITTImagePixelPositionMake(row-1, col-1);
                        break;
                    }
                    case 1:{
                        position = ITTImagePixelPositionMake(row-1, col);
                        break;
                    }
                    case 2:{
                        position = ITTImagePixelPositionMake(row-1, col+1);
                        break;
                    }
                    case 3:{
                        position = ITTImagePixelPositionMake(row, col-1);
                        break;
                    }
                    case 4:{
                        position = ITTImagePixelPositionMake(row, col+1);
                        break;
                    }
                    case 5:{
                        position = ITTImagePixelPositionMake(row+1, col-1);
                        break;
                    }
                    case 6:{
                        position = ITTImagePixelPositionMake(row+1, col);
                        break;
                    }
                    case 7:{
                        position = ITTImagePixelPositionMake(row+1, col+1);
                        break;
                    }
                        
                    default:
                        ITTDERROR(@"something is wrong here!%d",replacement);
                        position = ITTImagePixelPositionMake(row, col);
                        break;
                }
                
                ITTImagePixel replacementPixel = [imageData getPixelAtPostion:position];
                pixel.red = replacementPixel.red;
                pixel.green = replacementPixel.green;
                pixel.blue = replacementPixel.blue;
                
                [imageData setPixelValue:pixel];
            }
        }
    }
    [self onFilterProcessEnded];
    return imageData;
}

+ (NSString*)getFilterName{
    return @"扩散";
}
@end
