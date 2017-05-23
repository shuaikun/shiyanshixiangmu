//
//  SMOnButtonCell.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-3.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMOnButtonCell.h"

@interface SMOnButtonCell()
@end

@implementation SMOnButtonCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:NO];

    // Configure the view for the selected state     
}

+ (SMOnButtonCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SMOnButtonCell"];
}

- (IBAction)btnDidClicked:(id)sender {
    [self setSelected:NO animated:NO];
    
    if(_delegate && [_delegate respondsToSelector:@selector(SMOnButtonCellDelegateTapped:forObject:)]){
        [_delegate SMOnButtonCellDelegateTapped:kCellAddNew forObject:_index];
    }
}


- (void)setData:(SMOnButtonCellOperType *)operType from:(id)target
{
    _delegate = target;
    
    
     
}

@end
