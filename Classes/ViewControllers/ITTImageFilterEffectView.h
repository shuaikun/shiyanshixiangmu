//
//  ITTImageFilterEffectView.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 5/3/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTImageFilter.h"
#import "ITTXibView.h"
@class ITTImageFilterEffectView;

@protocol ITTImageFilterEffectViewDelegate <NSObject>
@optional
- (void)filterEffectViewClicked:(ITTImageFilterEffectView *)effectView;
@end

@interface ITTImageFilterEffectView : ITTXibView
{
    ITTImageFilter *_imageFilter;
}
@property (nonatomic, weak) id<ITTImageFilterEffectViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) ITTImageFilter *imageFilter;

@end
