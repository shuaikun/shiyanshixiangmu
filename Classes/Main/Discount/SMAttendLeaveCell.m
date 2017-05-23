//
//  SMAttendLeaveCell.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendLeaveCell.h"
#import "SMAttendLeaveModel.h"

@interface SMAttendLeaveCell()

@property (strong, nonatomic) SMAttendLeaveModel *attendLeaveModel;

@property (weak, nonatomic) IBOutlet UILabel *staffnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deptnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;



@property (assign, nonatomic) BOOL isBatchAudit;
@property BOOL isSelected;

@end

@implementation SMAttendLeaveCell

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
    // Initialization code
}

- (IBAction)oneButtonDicClicked:(id)sender {
    NSLog(@"do auditing reg: %@", _attendLeaveModel);
    
    if (_isBatchAudit){
        _isSelected = !_isSelected;
        if (_isSelected){
            [_bgView setBackgroundColor:[UIColor colorWithRed:46.f/255.f green:186.f/255.f blue:232.f/255.f alpha:1.f]];
        }
        else{
            [_bgView setBackgroundColor:[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.f]];
        }
        _attendLeaveModel.isSelected = _isSelected;
    }
    else{
        _attendLeaveModel.isSelected = false;
    }
    
    if(_cellDelegate && [_cellDelegate respondsToSelector:@selector(SMAttendAuditRegCellButtonTapped:index:)]){
        [_cellDelegate SMAttendAuditLeaveCellButtonTapped:_attendLeaveModel index:[self index]];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (SMAttendLeaveCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SMAttendLeaveCell"];
}

- (void)setBatchMode:(BOOL)batchMode
{
    _isBatchAudit = batchMode;
}

- (void)getDataSourceFromModel:(SMAttendLeaveModel *)model from:(id)target{
    
    _cellDelegate = target;
    
    _attendLeaveModel = model;
    NSLog(@"model is %@",model);
    
    if (IS_STRING_NOT_EMPTY( model.staffname ) ){
        [_staffnameLabel setText:model.staffname];
    }
    else{
        //[_staffnameLabel setText: [model.oneopinion stringByAppendingFormat:@" %@", model.oneperson]];
        if (IS_STRING_EMPTY(model.oneopinion)){
            [_staffnameLabel setText:@"<无审核意见>"];
        }
        else{
            [_staffnameLabel setText: model.oneopinion];
        }
        [_staffnameLabel setWidth:200.0];
    }
    
    
    [_deptnameLabel setText:model.deptname];
    [_typeLabel setText:model.type];
    if (IS_STRING_NOT_EMPTY( model.startTime ) ){
        [_startTimeLabel setText:model.startTime];
    }
    else{
        [_startTimeLabel setText:model.starttime];
    }
    
    if (IS_STRING_NOT_EMPTY(model.endTime)){
        [_endTimeLabel setText:model.endTime];
    }
    else{
        [_endTimeLabel setText:model.endtime];
    }
    
    if (IS_STRING_NOT_EMPTY(model.sumTime)){
        [_sumTimeLabel setText:model.sumTime];
    }
    else{
        [_sumTimeLabel setText:model.sumtime];
    }
    
    [_statusLabel setText:model.status];
    [_reasonLabel setText:model.reason];
    
    if ([model.status isEqualToString: @"通过"]){
        [_statusLabel setTextColor:[UIColor colorWithRed:33.f/255.f green:190.f/255.f blue:56.f/255.f alpha:1.f]];
    }
    else if (([model.status isEqualToString: @"不通过"]) || ([model.status isEqualToString: @"未通过"])){
        [_statusLabel setTextColor:[UIColor colorWithRed:190.f/255.f green:17.f/255.f blue:19.f/255.f alpha:1.f]];
    }
    else {
        [_statusLabel setTextColor:[UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f alpha:1.f]];
    }
}

@end
