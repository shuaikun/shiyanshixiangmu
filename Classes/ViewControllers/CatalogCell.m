//
//  CatalogCell.m
//  iTotemFramework
//
//  Created by Sword on 13-1-30.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "CatalogCell.h"
#import "Catalog.h"
#import "ITTXibViewUtils.h"

@interface CatalogCell()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *selectedBackgroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (strong, nonatomic) IBOutlet UISwitch *modalSwitch;

@end

@implementation CatalogCell

@synthesize delegate = _delegate;
@synthesize index = _index;
@synthesize numberOfRowsInSection = _numberOfRowsInSection;
@synthesize catalog = _catalog;

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.nameLabel.text = self.catalog.name;
    [self updateBackgroundView];
    self.modalSwitch.hidden = TRUE;
    self.arrowImageView.hidden = FALSE;
    if (CatalogTypeModalView == self.catalog.catalogType) {
        self.modalSwitch.hidden = FALSE;
        self.arrowImageView.hidden = TRUE;
    }
    else if (CatalogTypeTrasition == self.catalog.catalogType) {
        self.arrowImageView.hidden = TRUE;        
    }
}

- (void)dealloc
{
    _delegate = nil;
}

- (void)updateBackgroundView
{
    if (0 == _index) {
        self.backgroundImageView.image = [UIImage imageNamed:@"bg_cell_top.png"];
        self.selectedBackgroundImageView.image = [UIImage imageNamed:@"bg_cell_top_selected.png"];
    }
    else if(_index == _numberOfRowsInSection - 1) {
        self.backgroundImageView.image = [UIImage imageNamed:@"bg_cell_bottom.png"];
        self.selectedBackgroundImageView.image = [UIImage imageNamed:@"bg_cell_bottom_selected.png"];
    }
    else {
        self.backgroundImageView.image = [UIImage imageNamed:@"bg_cell_middle.png"];
        self.selectedBackgroundImageView.image = [UIImage imageNamed:@"bg_cell_middle_selected.png"];
    }
}

- (IBAction)onModalSwitchValueChanged:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(catalogCellDidUseModalView:used:)]) {
        [_delegate catalogCellDidUseModalView:self used:self.modalSwitch.on];
    }
}


+ (CatalogCell*)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"CatalogCell"];
}

@end
