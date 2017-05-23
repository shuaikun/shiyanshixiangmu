//
//  SMRptZBNextWeekItemCell.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBNextWeekItemCell.h"

@interface SMRptZBNextWeekItemCell()

@property (weak, nonatomic) IBOutlet UILabel *timenodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workcontentLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *measuresLabel;
@property (weak, nonatomic) IBOutlet UILabel *punishmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;


@end

@implementation SMRptZBNextWeekItemCell

- (void)awakeFromNib
{
    // Initialization code
}

+ (SMRptZBNextWeekItemCell *)cellFromNib{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SMRptZBNextWeekItemCell"];
}

-(void)setData:(SMRptZBNextweekItemModel*)model{
    _timenodeLabel.text = model.timenode;
    _workcontentLabel.text = model.workcontent;
    _levelLabel.text = model.level;
    _measuresLabel.text = model.measures;
    _punishmentLabel.text = model.punishment;
    _personLabel.text = model.person;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
