//
//  SZNormalTableViewCell.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNormalTableViewCell.h"
#import "SZMoreNormalModel.h"
@interface SZNormalTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@end
@implementation SZNormalTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)configModel:(id)model
{
    if ([model isKindOfClass:[SZMoreNormalModel class]]) {

        SZMoreNormalModel *normalModel = model;
        if (normalModel.modelId == 3) {
            self.topLine.hidden = NO;
        }else if(normalModel.modelId == 4){
            self.topLine.hidden = YES;
            self.arrowImage.hidden = YES;
        }else if (normalModel.modelId == 1){
            self.topLine.hidden = NO;
        }else
        {
            self.topLine.hidden = YES;
        }
        self.infoLabel.text= normalModel.infoTitle;
        if (normalModel.subTitle!=nil) {
            self.subLabel.text = normalModel.subTitle;
        }
    }
}

@end
