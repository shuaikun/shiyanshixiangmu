//
//  SMRptRBAuditListCell.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-12.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptRBAuditListCell.h"

@interface SMRptRBAuditListCell()

@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deptnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tommemoLabel;
@property (weak, nonatomic) IBOutlet UILabel *summarizeLabel;


@end

@implementation SMRptRBAuditListCell




- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (SMRptRBAuditListCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SMRptRBAuditListCell"];
}
-(void)setData:(SMRptRBAuditListModel*)model
{
    _conditionLabel.text = model.condition;
    _dateLabel.text = model.date;
    _usernameLabel.text = model.username;
    _deptnameLabel.text = model.deptname;
    _tommemoLabel.text = model.tommemo;
    _summarizeLabel.text = model.summarize;
    
    if ([model.condition isEqualToString:@"已审核"]){
        [_conditionLabel setTextColor:[UIColor colorWithRed:33.f/255.f green:190.f/255.f blue:56.f/255.f alpha:1.f]];
    }
    
}


@end
