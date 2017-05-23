//
//  SectionHeaderView.m
//  iTotemFramework
//
//  Created by Sword Zhou on 8/20/13.
//  Copyright (c) 2013 iTotemStudio. All rights reserved.
//

#import "SectionHeaderView.h"
#import "ITTImageView.h"
#import "ApplicationSectionHeader.h"
#import "ApplicationModel.h"

@interface SectionHeaderView()

@property (strong, nonatomic) IBOutlet ITTImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *toggleButton;

@end

@implementation SectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Set the colors for the gradient layer.
    static NSMutableArray *colors = nil;
    if (nil == colors) {
        colors = [[NSMutableArray alloc] initWithCapacity:3];
        UIColor *color = nil;
        color = [UIColor colorWithRed:0.9 green:0.7 blue:0.7 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
        color = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
        color = [UIColor colorWithRed:0.9 green:0.7 blue:0.7 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
    }
    NSArray *locations = @[@(0.0), @(0.48), @(1.0)];
    [(CAGradientLayer *)self.layer setColors:colors];
    [(CAGradientLayer *)self.layer setLocations:locations];
}

- (void)layoutSubviews
{
    ApplicationModel *application = self.sectionHeader.applications[0];
    [self.iconImageView loadImage:application.icon];
    self.nameLabel.text = application.name;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.toggleButton.selected = !self.toggleButton.selected;
    _sectionHeader.open = !_sectionHeader.open;
    if (_sectionHeader.open) {
        if (_delegate && [_delegate respondsToSelector:@selector(sectionHeaderView:didOpenedSection:)]) {
            [_delegate sectionHeaderView:self didOpenedSection:_section];
        }
    }
    else {
        if (_delegate && [_delegate respondsToSelector:@selector(sectionHeaderView:didClosedSection:)]) {
            [_delegate sectionHeaderView:self didClosedSection:_section];
        }
    }    
}

@end
