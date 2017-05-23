//
//  WWGroupItemCell.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-18.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWGroupItemCell.h"
@interface WWGroupItemCell()
@property (nonatomic, copy) void(^finishCellBlock)(WWGroupItemModel *model);
@property (strong, nonatomic) WWGroupItemModel *model;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation WWGroupItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
+ (WWGroupItemCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"WWGroupItemCell"];
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

- (void)showGroupCellWithFinishBlock:(void(^)(WWGroupItemModel *model))finishBlock data:(WWGroupItemModel *)model
{
    self.finishCellBlock = finishBlock;
    [self getDataSourceFromModel:model];
}
- (void)getDataSourceFromModel:(WWGroupItemModel *)model
{
    self.model = model;
    NSLog(@"model is %@",model);
    
    [_titleLabel setText:model.orgName];
}

@end
