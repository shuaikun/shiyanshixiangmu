//
//  SMAttendTxCell.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-22.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendTxCell.h"

@interface SMAttendTxCell()

@property (weak, nonatomic) IBOutlet UILabel *staffNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UILabel *extraworkLabel;
@property (weak, nonatomic) IBOutlet UILabel *restLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;


@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (strong, nonatomic) SMAttendTxModel *txModel;
@property (assign, nonatomic) BOOL isBatchAudit;
@property BOOL isSelected;

@end

@implementation SMAttendTxCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (SMAttendTxCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SMAttendTxCell"];
}

- (void)setBatchMode:(BOOL)batchMode
{
    _isBatchAudit = batchMode;
}

- (void)getDataSourceFromModel:(SMAttendTxModel *)model from:(id)target{
    
    _txModel = model;
    
    _delegate = target;
    
    [_staffNameLabel setText:model.staffName];
    [_statusLabel setText:model.status];
    [_extraworkLabel setText:model.extrawork];
    [_restLabel setText:model.rest];
    [_remarkLabel setText:model.remark];
    
    //0 暂存， 1： 提交， 2:通过， 3:不通过
    if ([model.status isEqualToString: @"0"]){
        [_statusLabel setText:@"暂存"];
    }
    else if ([model.status isEqualToString: @"1"]){
        [_statusLabel setText:@"审核中"];
    }
    else if ([model.status isEqualToString: @"2"] || [model.status isEqualToString: @"4"]){
        [_statusLabel setTextColor:[UIColor colorWithRed:33.f/255.f green:190.f/255.f blue:56.f/255.f alpha:1.f]];
        [_statusLabel setText:@"通过"];
    }
    else if ([model.status isEqualToString: @"3"] || [model.status isEqualToString: @"5"]){
        [_statusLabel setTextColor:[UIColor colorWithRed:190.f/255.f green:17.f/255.f blue:19.f/255.f alpha:1.f]];
        [_statusLabel setText:@"不通过"];
    }
    else {
        [_statusLabel setTextColor:[UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f alpha:1.f]];
    }
}


- (IBAction)oneButtonDicClicked:(id)sender {
    NSLog(@"do auditing reg: %@", _txModel);
    
    if (_isBatchAudit){
        _isSelected = !_isSelected;
        if (_isSelected){
            [_bgView setBackgroundColor:[UIColor colorWithRed:46.f/255.f green:186.f/255.f blue:232.f/255.f alpha:1.f]];
        }
        else{
            [_bgView setBackgroundColor:[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.f]];
        }
        _txModel.isSelected = _isSelected;
    }
    else{
        _txModel.isSelected = false;
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(SMAttendTxCellButtonTapped:index:)]){
        [_delegate SMAttendTxCellButtonTapped:_txModel index:[self index]];
    }
    
    
}


@end