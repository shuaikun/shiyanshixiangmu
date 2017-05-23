//
//  WWSearchPackageBoxCell.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-20.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWSearchPackageBoxCell.h"
@interface WWSearchPackageBoxCell()
@property (nonatomic, copy) void(^finishCellBlock)(WWSearchPackageInfoModel *model);
@property (strong, nonatomic) WWSearchPackageInfoModel *model;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end

@implementation WWSearchPackageBoxCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WWSearchPackageBoxCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"WWSearchPackageBoxCell"];
}
- (IBAction)buttonDidClicked:(id)sender {
    if (_finishCellBlock) {
        _finishCellBlock(self.model);
    }
}

- (void)showCellWithFinishBlock:(void(^)(WWSearchPackageInfoModel *model))finishBlock data:(WWSearchPackageInfoModel *)model
{
    self.finishCellBlock = finishBlock;
    self.model = model;
    
    [_codeLabel setText:model.package_box_code];
    [_typeLabel setText:model.group_name];
    [_sizeLabel setText:model.mmv];
    [_dateLabel setText:model.date];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
