//
//  OnePiece.m
//  ITTSortableView
//
//  Created by 胡鹏 on 13-8-28.
//  Copyright (c) 2013年 胡鹏. All rights reserved.
//

#import "OnePieceCell.h"


@interface OnePieceCell()

@property (strong, nonatomic) IBOutlet UILabel *indexLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@end


@implementation OnePieceCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _deleteButton.hidden = !self.editMode;
    
    [_deleteButton addTarget:self action:@selector(deleteCell) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setIndex:(NSInteger)index
{
    _indexLabel.text = [NSString stringWithFormat:@"%d",index];
}

- (void)currentModeDidChanged:(BOOL)isEditMode
{
    _deleteButton.hidden = !isEditMode;
}

@end
