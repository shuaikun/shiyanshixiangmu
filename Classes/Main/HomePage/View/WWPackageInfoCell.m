//
//  WWPackageInfoCell.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-19.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWPackageInfoCell.h"

@interface WWPackageInfoCell()
@property (nonatomic, copy) void(^finishCellBlock)(WWQrcodeModel *model);
@property (strong, nonatomic) WWQrcodeModel *model;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end

@implementation WWPackageInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WWPackageInfoCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"WWPackageInfoCell"];
}
- (IBAction)buttonDidClicked:(id)sender {
    if (_finishCellBlock) {
        _finishCellBlock(self.model);
    }
}

- (void)showCellWithFinishBlock:(void(^)(WWQrcodeModel *model))finishBlock data:(WWQrcodeModel *)model
{
    self.finishCellBlock = finishBlock;
    self.model = model;
    
    [_codeLabel setText:model.containerIdentifier];
    [_typeLabel setText:model.containerType];
    [_sizeLabel setText:model.containerSize];
    [_dateLabel setText:model.createdAt];
    
}


- (void)awakeFromNib {
    [super awakeFromNib]; 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
