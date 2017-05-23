//
//  WWWasteTypeViewCell.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-07-25.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWWasteTypeViewCell.h"

@interface WWWasteTypeViewCell()
@property (nonatomic, copy) void(^finishCellBlock)(WWWasteTypeModel *model);
@property (strong, nonatomic) WWWasteTypeModel *model;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *containerTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wasteCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wasteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wasteTypeLabel;


@end

@implementation WWWasteTypeViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
+ (WWWasteTypeViewCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"WWWasteTypeViewCell"];
}

- (void)showWasteTypeCellWithFinishBlock:(void(^)(WWWasteTypeModel *backModel))finishBlock data:(WWWasteTypeModel *)model
{
    self.finishCellBlock = finishBlock;
    
    [self getDataSourceFromModel:model];
}
- (void)getDataSourceFromModel:(WWWasteTypeModel *)model
{
    self.model = model;
    NSLog(@"model is %@",model);
    
    [_wasteNameLabel setText:model.wasteName];
    [_wasteCodeLabel setText:model.wasteCode];
    [_wasteTypeLabel setText:model.wasteType];
    [_containerTypeLabel setText:model.containerType];
    [_descLabel setText:model.descriptions];
}

- (IBAction)selectButtonDidClicked:(id)sender {
    if (_finishCellBlock) {
        _finishCellBlock(self.model);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
