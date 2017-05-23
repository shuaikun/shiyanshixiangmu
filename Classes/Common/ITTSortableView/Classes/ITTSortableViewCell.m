//
//  ITTITTSortableViewCell.m
//  ITTSortableView
//
//  Created by 胡鹏 on 13-8-28.
//  Copyright (c) 2013年 胡鹏. All rights reserved.
//

#import "ITTSortableViewCell.h"

@interface ITTSortableViewCell()
{
    UILongPressGestureRecognizer *press;
    UITapGestureRecognizer *tap;

}

- (void)registerGestures;

- (void)switchToEditMode;

- (void)click;

- (void)deleteCell;

@end

@implementation ITTSortableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self registerGestures];
    }
    return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
    [self registerGestures];
}

- (void)setEditMode:(BOOL)editMode
{
    _editMode = editMode;
    
    if (!editMode) {
        [self registerGestures];
        
    } else {
        
        [self removeGestureRecognizer:press];
        [self removeGestureRecognizer:tap];
    }
    [self currentModeDidChanged:editMode];
}

- (void)currentModeDidChanged:(BOOL)isEditMode
{
    //..
}
#pragma mark - privat method

- (void)switchToEditMode
{
    [_delegate switchToEditMode];
    
    _editMode = true;
}

- (void)click
{
    [_delegate didSelectCell:self];
}

- (void)registerGestures
{
	self.exclusiveTouch = TRUE;	
    if (!press) {
        press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(switchToEditMode)];
        
    }
    [self addGestureRecognizer:press];
    
    if (!tap) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        
    }
    [self addGestureRecognizer:tap];
}

- (void)deleteCell
{
    [_delegate willDeleteCell:self];
}

@end
