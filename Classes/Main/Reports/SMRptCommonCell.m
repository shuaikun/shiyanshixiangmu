//
//  SMRptCommonCell.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-2.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptCommonCell.h"

@interface SMRptCommonCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedLabel;
@property (weak, nonatomic) IBOutlet UILabel *pusedLabel;
@property (weak, nonatomic) IBOutlet UILabel *goonLabel;
@property (weak, nonatomic) IBOutlet UILabel *notcompletedLabel;
@property (weak, nonatomic) IBOutlet UILabel *auditingLabel;

@end


@implementation SMRptCommonCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (SMRptCommonCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SMRptCommonCell"];
}


-(void)setData:(SMRptRBModel*)model
{
    if (model != nil){
        self.dateLabel.text = model.date;
        self.statusLabel.text = model.submitstatus;
        self.completedLabel.text = model.ywc;
        self.pusedLabel.text = model.zt;
        self.goonLabel.text = model.jxgj;
        self.notcompletedLabel.text = model.wwc;
        self.auditingLabel.text = model.ldpf;
    }
}



@end
