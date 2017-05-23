//
//  SMRptRBItemCell.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-2.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptRBItemCell.h"

@interface SMRptRBItemCell()

@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *workcontentLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end


@implementation SMRptRBItemCell

- (void)awakeFromNib
{
    // Initialization code
}

+ (SMRptRBItemCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SMRptRBItemCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(SMRptRBItemModel*)model
{
    [_percentageLabel setText: [NSString stringWithFormat:@"%@%@", model.percentage, @"%"]];
    [_workcontentLabel setText: model.workcontent];
    [_levelLabel setText:model.level];
    [_statusLabel setText:model.status];
}


@end
