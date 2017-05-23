//
//  SMNormalTableViewCell.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-2.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMNormalTableViewCell.h"
#import "SZMoreNormalModel.h"
@interface SMNormalTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@end

@implementation SMNormalTableViewCell

@synthesize isFirstItem;
@synthesize isLastItem;

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
        self.infoLabel.text= normalModel.infoTitle;
        if (!self.isFirstItem){
             self.topLine.hidden = YES;
        }
        if (normalModel.subTitle!=nil) {
            self.subLabel.text = normalModel.subTitle;
        }
    }
}

@end
