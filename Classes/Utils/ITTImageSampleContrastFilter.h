//
//  ITTImageSampleContrastFilter.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageFilter.h"

@interface ITTImageSampleContrastFilter : ITTImageFilter

- (id)initWithImage:(UIImage *)image withContrastChange:(CGFloat)contrastChange;
@end
