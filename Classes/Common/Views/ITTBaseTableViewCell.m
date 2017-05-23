//
//  ITTBaseTableViewCell.m
//  iTotemFramework
//
//  Created by Sword Zhou on 8/20/13.
//  Copyright (c) 2013 iTotemStudio. All rights reserved.
//

#import "ITTBaseTableViewCell.h"
#import "ITTXibViewUtils.h"

@implementation ITTBaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (id)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:NSStringFromClass([self class])];
}

@end
