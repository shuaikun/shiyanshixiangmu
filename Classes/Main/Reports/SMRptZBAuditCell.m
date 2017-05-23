//
//  SMRptZBAuditCell.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-13.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBAuditCell.h"

@interface SMRptZBAuditCell()

@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deptnameLabel;

@end

@implementation SMRptZBAuditCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (SMRptZBAuditCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SMRptZBAuditCell"];
}
-(void)setData:(SMRptZBAuditModel*)model
{
    _conditionLabel.text = model.condition;
    _dateLabel.text = model.date;
    _usernameLabel.text = model.username;
    _deptnameLabel.text = model.deptname;
    
    if ([model.condition isEqualToString:@"已审核"]){
        [_conditionLabel setTextColor:[UIColor colorWithRed:33.f/255.f green:190.f/255.f blue:56.f/255.f alpha:1.f]];
    }
}

@end
