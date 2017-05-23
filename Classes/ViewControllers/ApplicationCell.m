//
//  ApplicationCell.m
//  iTotemFramework
//
//  Created by Sword Zhou on 8/20/13.
//  Copyright (c) 2013 iTotemStudio. All rights reserved.
//

#import "ApplicationCell.h"
#import "ITTImageView.h"
#import "ApplicationModel.h"

@interface ApplicationCell()

@property (nonatomic, weak) IBOutlet ITTImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@end

@implementation ApplicationCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.descriptionLabel.text = self.application.introduction;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
