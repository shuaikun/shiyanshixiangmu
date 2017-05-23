//
//  WWQrcodeListItemCell.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-17.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWQrcodeListItemCell.h"
#import "ITTImageView.h"
@interface WWQrcodeListItemCell()<ITTImageViewDelegate>

@property (weak, nonatomic) IBOutlet ITTImageView *shopImageView;

@property (strong, nonatomic) WWQrcodeListItemModel *newsModel;

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIView *hrView;

@property (weak, nonatomic) IBOutlet UILabel *wasteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *attrLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightPHLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;


- (IBAction)onShowDetailButtonClicked:(id)sender;

@end

@implementation WWQrcodeListItemCell

- (void)awakeFromNib {
    [super awakeFromNib]; 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WWQrcodeListItemCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"WWQrcodeListItemCell"];
}

- (void)getDataSourceFromModel:(WWQrcodeListItemModel *)model
{
    self.newsModel = model;
    NSLog(@"model is %@",model);
    
    [_wasteNameLabel setText:model.wasteName];
    [_attrLabel setText:[NSString stringWithFormat:@"%@, %@, %@", model.wasteType, model.wasteForm, model.dangesFeatures]];
    [_weightPHLabel setText:[NSString stringWithFormat:@"%@, %@", model.wasteWeight, model.ph]];
    [_lblDate setText:model.productionDate];
    [_remarkLabel setText:model.remark];
    if ([model.remark length] == 0){
        [_remarkLabel setHidden:YES];
        _hrView.top -= 20;
        [self setFrame:CGRectMake(0, 0, self.width, _hrView.top+_hrView.height + 2)];
    }
    
    [_shopImageView loadImage:model.wasteImage placeHolder:[UIImage imageNamed:@"SZ_Mine_Default_Big_Placeholder.png"]];
    
    
    //_shopImageView.hidden = YES;
    
    if (_shopImageView.hidden == YES){
        
        [self setFrame:CGRectMake(0, 0, self.width, _hrView.top+_hrView.height + 2)];
    }
    
}

- (IBAction)onShowDetailButtonClicked:(id)sender
{
    
}

@end
