//
//  ITTImageFilterEffectView.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 5/3/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageFilterEffectView.h"
@interface ITTImageFilterEffectView()
-(void)handleTapGesture:(UITapGestureRecognizer *)recognizer;
@end

@implementation ITTImageFilterEffectView
#pragma mark - private methods

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    if (_delegate && [_delegate respondsToSelector:@selector(filterEffectViewClicked:)]) {
        [_delegate filterEffectViewClicked:self];
	}
}
#pragma mark - lifecycle methods
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)setImageFilter:(ITTImageFilter *)imageFilter
{
    if (_imageFilter) {
        _imageFilter = imageFilter;
        _imageFilter = nil;
    }
    _imageFilter = imageFilter;
    _imageView.image = [_imageFilter getFilteredImage];
    _nameLabel.text = [_imageFilter getFilterName];
}

- (void)dealloc
{
    _delegate = nil;
}
@end
