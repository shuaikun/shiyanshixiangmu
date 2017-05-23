//
//  SZCheckVersionTableViewCell.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZCheckVersionTableViewCell.h"
#import "SZMoreVersionModel.h"
@interface SZCheckVersionTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hasNewImgview;

@end

@implementation SZCheckVersionTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configModel:(id)model
{
    if ([model isKindOfClass:[SZMoreVersionModel class]]) {
        SZMoreVersionModel *versionModel = model;
        self.versionLabel.text = versionModel.currentVersion;
        if ([versionModel haveNew]) {
            self.hasNewImgview.hidden = NO;
        }
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
