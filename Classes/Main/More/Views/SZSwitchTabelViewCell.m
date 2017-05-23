//
//  SZSwitchTabelViewCell.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZSwitchTabelViewCell.h"
#import "SZMoreSwitchModel.h"
@interface SZSwitchTabelViewCell()
@property (nonatomic, assign) BOOL open;
@property (weak, nonatomic) IBOutlet UIImageView *switchImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *topLine;

@end

@implementation SZSwitchTabelViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.open = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwitch:)];
    tap.numberOfTapsRequired = 1;
    [self.switchImageView addGestureRecognizer:tap];
}

- (void)handleSwitch:(UITapGestureRecognizer  *)tap
{
    if (self.open) {
        [self.switchImageView setHighlighted:YES];
    }else{
        [self.switchImageView setHighlighted:NO];
    }
    self.open = !self.open;
    if (self.switchCallBack!=nil) {
        self.switchCallBack(self.open);
    }
}

- (void)configModel:(id)model
{
    if ([model isKindOfClass:[SZMoreSwitchModel class]]) {

        SZMoreSwitchModel *models = model;
        if (models.modelId == 0) {
            self.topLine.hidden = NO;
        }else{
            self.topLine.hidden = YES;
        }
        self.descriptionLabel.text = [models infoTitle];
        BOOL isOpen = models.isOpen;
        self.open = isOpen;
        [self.switchImageView setHighlighted:!self.open];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
