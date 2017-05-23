//
//  SZFilterView.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZFilterView.h"
#import "UserManager.h"
@interface SZFilterView()

@property (weak, nonatomic) IBOutlet UILabel *classificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;

- (IBAction)oneConditionButtonTapped:(id)sender;


@end

@implementation SZFilterView

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
    [self setDefaultFilter];
}

- (void)setDefaultFilter
{
    NSString *cityCode = [[UserManager sharedUserManager]suggestCityCode];
    if ([cityCode isEqualToString:@"ts"]||[cityCode isEqualToString:@"sz"]) {
        _distanceLabel.text = @"全部距离";
    }else{
        _distanceLabel.text = @"1000米";
    }
    _classificationLabel.text = @"全部分类";
    
    _sortLabel.text = @"默认排序";
}

- (void)setFilterConditionTitle:(NSString *)filterCondition Index:(int)filterConditionIndex
{
    if(filterConditionIndex==kTagFilterConditionClassification){
        _classificationLabel.text = filterCondition;
    }
    else if(filterConditionIndex==kTagFilterConditionDistance){
        _distanceLabel.text = filterCondition;
    }
    else if(filterConditionIndex==kTagFilterConditionSort){
        _sortLabel.text = filterCondition;
    }
}

- (IBAction)oneConditionButtonTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int tag = button.tag;
    if(_delegate && [_delegate respondsToSelector:@selector(filterViewOneConditionButtonTapped:)]){
        [_delegate filterViewOneConditionButtonTapped:tag];
    }
}


@end






