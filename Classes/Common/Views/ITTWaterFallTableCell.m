//
//  ITTWaterFallTableCell.m
//  meidian
//
//  Created by jack 廉洁 on 5/21/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//  Modifyed by Sword on 24/10/28
//  Convert to ARC, optimization, format
//  Refacotring refresh and load more function
//

#import "ITTWaterFallTableCell.h"

@interface ITTWaterFallTableCell()
- (void)onViewTapped;
@end

@implementation ITTWaterFallTableCell


#pragma mark - private methods
- (void)onViewTapped
{
    if (_delegate && [_delegate respondsToSelector:@selector(waterFallTableCellSelected:)]) {
        [_delegate waterFallTableCellSelected:self];
    }
}

#pragma mark - lifecycle methods
- (void)dealloc
{
    _delegate = nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTapped)];
        tapGR.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withReusableCellId:(NSString *)reusableCellId
{
    self = [super initWithFrame:frame];
    if (self) {
        if (reusableCellId) {
            _reusableCellId = reusableCellId;
        }
    }
    return self;
}

#pragma mark - public methods
- (BOOL)isVisibleInRect:(CGRect)rect
{    
    if (self.top > rect.origin.y + rect.size.height + 20) {
        // below the area
        return NO;
    }
    if (self.bottom < rect.origin.y - 20) {
        // below the area
        return NO;
    }
    return YES;
}

- (void) recyleAllComponents
{
}

+ (id)cellFromNib
{
    NSString *xibName = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil] objectAtIndex:0];    
}

+ (id)cellFromNibWithIdentifier:(NSString*)identifier
{
    NSString *xibName = NSStringFromClass([self class]);
    ITTWaterFallTableCell *cell = [[[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil] objectAtIndex:0];
    cell.reusableCellId = identifier;
    return cell;    
}
@end
