//
//  ITTImageInfo.h
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/21/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface ITTImageInfo : ITTBaseModelObject

@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSString *smallUrl;

+ (NSString*)getImageUrlWithSourceUrl:(NSString*)url targetWidth:(int)imageWidth;

@end