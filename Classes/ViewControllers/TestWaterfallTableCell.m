//
//  MDDishCell.m
//  iTotemFramework
//
//  Created by Sword on 13-10-23.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "TestWaterfallTableCell.h"
#import "ITTImageView.h"
#import "PictureModel.h"

@interface TestWaterfallTableCell()

@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (retain, nonatomic) IBOutlet ITTImageView *imageView;

@end

@implementation TestWaterfallTableCell

- (void)dealloc
{
    [self.imageView cancelCurrentImageRequest];
}

- (void) layoutSubviews
{
//    [self.imageView setImageWithURL:_imageUrl];
}
- (void) recyleAllComponents
{
    self.imageView.image = nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setPicture:(PictureModel *)picture
{    
    [self.imageView loadImage:picture.image_small];
    if(0 == self.index) {
        [self.backgroundImageView setImage:[UIImage imageNamed:@"placeholder_3.png"]];
    }
    else if(1 == self.index) {
        [self.backgroundImageView setImage:[UIImage imageNamed:@"placeholder_5.png"]];
    }
    else if(2 == self.index) {
        [self.backgroundImageView setImage:[UIImage imageNamed:@"placeholder_4.png"]];
    }
    else {
        int height = 0;
        NSString *wh = picture.image_wh;
        NSRange range = [wh rangeOfString:@"|"];
        if(range.length > 0) {
            height = [[wh substringFromIndex:range.location+1] intValue];
        }
        if(height < 500) {
            [self.backgroundImageView setImage:[UIImage imageNamed:@"placeholder_3.png"]];
        }
        else if(height > 500 && height < 1000) {
            [self.backgroundImageView setImage:[UIImage imageNamed:@"placeholder_4.png"]];
        }
        else {
            [self.backgroundImageView setImage:[UIImage imageNamed:@"placeholder_5.png"]];
        }
    }
}
@end
