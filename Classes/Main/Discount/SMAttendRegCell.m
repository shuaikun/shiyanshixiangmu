//
//  SMAttendRegCell.m
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-7.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendRegCell.h"
#import "ITTXibViewUtils.h"
#import "SMAttendRegModel.h"

@interface SMAttendRegCell()
@property (weak, nonatomic) IBOutlet UILabel *staffnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deptnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;

@property (strong, nonatomic) SMAttendRegModel *attendRegModel;
@property BOOL isSelected;
@property (assign, nonatomic) BOOL isBatchAudit;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation SMAttendRegCell
- (IBAction)oneButtonDicClicked:(id)sender {
    NSLog(@"do auditing reg: %@", _attendRegModel);
    
    if (_isBatchAudit){
        _isSelected = !_isSelected;
        if (_isSelected){            
            [_bgView setBackgroundColor:[UIColor colorWithRed:46.f/255.f green:186.f/255.f blue:232.f/255.f alpha:1.f]];
        }
        else{
            [_bgView setBackgroundColor:[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.f]];
        }
        _attendRegModel.isSelected = _isSelected;
    }
    else{
        _attendRegModel.isSelected = false;
    }
    if(_cellDelegate && [_cellDelegate respondsToSelector:@selector(SMAttendAuditRegCellButtonTapped:index:)]){
        [_cellDelegate SMAttendAuditRegCellButtonTapped:_attendRegModel index:[self index]];
    }
}

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

    // Configure the view for the selected state
}




+ (SMAttendRegCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SMAttendRegCell"];
}
- (void)setBatchMode:(BOOL)batchMode
{
    _isBatchAudit = batchMode;
}
- (void)getDataSourceFromModel:(SMAttendRegModel *)model from:(id)target{

    [_bgView setBackgroundColor:[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.f]];
    
    _cellDelegate = target;
    
    _attendRegModel = model;
    NSLog(@"model is %@",model);
 
    [_staffnameLabel setWidth:200.0];
    if (IS_STRING_NOT_EMPTY( model.staffname ) ){
        [_staffnameLabel setText:model.staffname];
    }
    else if (IS_STRING_NOT_EMPTY( model.oneopinion)){
        //[_staffnameLabel setText: [model.oneopinion stringByAppendingFormat:@" %@", model.oneperson]];
        [_staffnameLabel setText: model.oneopinion];
    }
    else {
        [_staffnameLabel setText:@"<暂无审核意见>"];
    }
    
    
    
    
    [_deptnameLabel setText:model.deptname];
    [_dateLabel setText:model.date];
    [_timeLabel setText:model.time];
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
