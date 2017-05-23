//
//  ITTImagePixelData.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 5/10/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - util structs for handling image

//pixel position in image
typedef struct {
    int row;
    int column;
} ITTImagePixelPosition;


//pixel position in image
typedef struct {
    int red;
    int green;
    int blue;
    int alpha;
    int gray;
    ITTImagePixelPosition position;
} ITTImagePixel;

ITTImagePixelPosition ITTImagePixelPositionMake(int row,int column);

ITTImagePixel ITTImagePixelMake(int red,int green,int blue,int alpha,int gray,ITTImagePixelPosition position);

@interface ITTImagePixelData : NSObject

@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;

- (id)initWithImage:(UIImage*)image;

- (id)initWithImagePixels:(unsigned char *)pixels 
               imageWidth:(int)width 
              imageHeight:(int)height;

- (unsigned char *)getPixelData;

- (ITTImagePixel)getPixelAtPostion:(ITTImagePixelPosition)position;

- (void)setPixelValue:(ITTImagePixel)pixel;

- (void)setPixelValue:(ITTImagePixel)pixel atPosition:(ITTImagePixelPosition)position;

- (UIImage*)generateImage;
@end
