//
//  SMRptZBWeekItemCell.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBWeekItemCell.h"

@interface SMRptZBWeekItemCell()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *workcontentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timenodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *measuresLabel;
@property (weak, nonatomic) IBOutlet UILabel *issueLabel;
@property (weak, nonatomic) IBOutlet UILabel *solvemeasureLabel;
@property (weak, nonatomic) IBOutlet UILabel *punishmentLabel;


@end

@implementation SMRptZBWeekItemCell

+ (SMRptZBWeekItemCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SMRptZBWeekItemCell"];
}
-(void)setData:(SMRptZBWeekItemModel*)model
{
    _statusLabel.text = model.status;
    _workcontentLabel.text = model.workcontent;
    _timenodeLabel.text = model.timenode;
    _measuresLabel.text = model.measures;
    _issueLabel.text = model.issue;
    _solvemeasureLabel.text = model.solvemeasure;
    _punishmentLabel.text = model.punishment;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
