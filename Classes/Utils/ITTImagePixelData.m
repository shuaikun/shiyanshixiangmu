//
//  ITTImagePixelData.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 5/10/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImagePixelData.h"

ITTImagePixelPosition ITTImagePixelPositionMake(int row,int column){
    ITTImagePixelPosition postion = {row,column}; 
    return postion;
}


ITTImagePixel ITTImagePixelMake(int red,int green,int blue,int alpha,int gray,ITTImagePixelPosition position){
    ITTImagePixel pixel = {red,green,blue,alpha,gray,position}; 
    return pixel;
}

#pragma mark - private interface
@interface ITTImagePixelData(){
    unsigned char *_pixelData;
    int _width;
    int _height;
    int _bitmapBytesPerRow;
    int _bitmapByteCount;
    BOOL _shouldReleasePixelDataWhenDealloc;   //default is YES, should be NO when pixel data is not generated in this class
}
- (void)setupPixelDataWithImage:(UIImage*)image;
- (int)pixelOffsetForPixelAtPostion:(ITTImagePixelPosition)position;
- (int)getGrayValueWithRed:(int)red green:(int)green blue:(int)blue;
@end

#pragma mark - implemetations

@implementation ITTImagePixelData
#pragma mark - private methods
- (void)setupPixelDataWithImage:(UIImage*)image{
    if (!image) {
        return;
    }
	CGImageRef imageRef = [image CGImage]; 
    _width = CGImageGetWidth(imageRef); 
    _height = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL) {
        ITTDERROR(@"error when allocating color space");
        return;
	}
    
    _bitmapBytesPerRow = _width * 4;
    _bitmapByteCount = _bitmapBytesPerRow * _height;
    
	// allocate the bitmap & create context 
    
	_pixelData = malloc(_bitmapByteCount); 
	if (_pixelData == NULL) {
        ITTDERROR(@"error when allocating Memory");
		CGColorSpaceRelease(colorSpace); 
		return;
	}
    
	CGContextRef context = CGBitmapContextCreate(_pixelData, 
                                                  _width, 
                                                  _height, 
                                                  8, 
                                                  _bitmapBytesPerRow, 
                                                  colorSpace, 
                                                  kCGImageAlphaPremultipliedLast);
	if (context == NULL) {
		free(_pixelData); 
        ITTDERROR(@"error when creating context");
	} 
	CGColorSpaceRelease(colorSpace); 
    
    // fill pixel data
	CGContextDrawImage(context, CGRectMake(0, 0, _width, _height), imageRef); 
    CGContextRelease(context);
}

- (int)pixelOffsetForPixelAtPostion:(ITTImagePixelPosition)position{
    return 4*(position.row * _width + position.column);
}

- (int)getGrayValueWithRed:(int)red green:(int)green blue:(int)blue{
    return red * 0.299 + green * 0.587 + blue * 0.114;
}

#pragma mark - lifecycle methods
- (void)dealloc{
    if (_shouldReleasePixelDataWhenDealloc) {
        free(_pixelData); 
    }
    [super dealloc];
}

- (id)initWithImage:(UIImage*)image{
    self = [super init];
    if (self) {
        _width = 0;
        _height = 0;
        _pixelData = nil;
        _shouldReleasePixelDataWhenDealloc = YES;
        [self setupPixelDataWithImage:image];
    }
    return self;
}

- (id)initWithImagePixels:(unsigned char *)pixels imageWidth:(int)width imageHeight:(int)height{
    self = [super init];
    if (self) {
        _width = width;
        _height = height;
        _pixelData = pixels;
        _bitmapBytesPerRow = _width * 4;
        _bitmapByteCount = _bitmapBytesPerRow * _height;
        _shouldReleasePixelDataWhenDealloc = NO;
    }
    return self;
}

#pragma mark - public methods
- (unsigned char *)getPixelData{
    return _pixelData;
}

- (ITTImagePixel)getPixelAtPostion:(ITTImagePixelPosition)position{
    int pixelOffset = [self pixelOffsetForPixelAtPostion:position];
    int red = (unsigned char)_pixelData[pixelOffset];
    int green = (unsigned char)_pixelData[pixelOffset+1];
    int blue = (unsigned char)_pixelData[pixelOffset+2];
    int alpha = (unsigned char)_pixelData[pixelOffset+3];
    int gray = [self getGrayValueWithRed:red green:green blue:blue];
    return ITTImagePixelMake(red, green, blue, alpha, gray, position);
}
- (void)setPixelValue:(ITTImagePixel)pixel{
    int pixelOffset = [self pixelOffsetForPixelAtPostion:pixel.position];
    //make sure value is between 0 - 255
    pixel.red = MIN(255, pixel.red);
    pixel.red = MAX(0, pixel.red);
    pixel.green = MIN(255, pixel.green);
    pixel.green = MAX(0, pixel.green);
    pixel.blue = MIN(255, pixel.blue);
    pixel.blue = MAX(0, pixel.blue);
    
    _pixelData[pixelOffset] = pixel.red;
    _pixelData[pixelOffset + 1] = pixel.green;
    _pixelData[pixelOffset + 2] = pixel.blue;
    _pixelData[pixelOffset + 3] = pixel.alpha;
}

- (void)setPixelValue:(ITTImagePixel)pixel atPosition:(ITTImagePixelPosition)position{
    int pixelOffset = [self pixelOffsetForPixelAtPostion:position];
    //make sure value is between 0 - 255
    pixel.red = MIN(255, pixel.red);
    pixel.red = MAX(0, pixel.red);
    pixel.green = MIN(255, pixel.green);
    pixel.green = MAX(0, pixel.green);
    pixel.blue = MIN(255, pixel.blue);
    pixel.blue = MAX(0, pixel.blue);
    
    _pixelData[pixelOffset] = pixel.red;
    _pixelData[pixelOffset + 1] = pixel.green;
    _pixelData[pixelOffset + 2] = pixel.blue;
    _pixelData[pixelOffset + 3] = pixel.alpha;
}

- (UIImage*)generateImage{
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, _pixelData, _bitmapByteCount, NULL);
	// prep the ingredients
	int bitsPerComponent = 8;
	int bitsPerPixel = bitsPerComponent * 4;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	// make the cgimage
	CGImageRef imageRef = CGImageCreate(_width,
                                        _height, 
                                        bitsPerComponent, 
                                        bitsPerPixel, 
                                        _bitmapBytesPerRow, 
                                        colorSpaceRef, 
                                        bitmapInfo, 
                                        provider, 
                                        NULL,
                                        NO, 
                                        renderingIntent);
	
	UIImage *image = [UIImage imageWithCGImage:imageRef];
	
	CFRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
    return image;

}
@end
