//
//  SZCommentCell.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZCommentCell.h"
#import "SZRateView.h"
#import "SZMerchantDetailViewController.h"
#import "ITTASIBaseDataRequest.h"
@interface SZCommentCell()
<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) SZRateView *rateView;
@property (strong, nonatomic) SZCommentModel *model;

@end

@implementation SZCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (SZCommentCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SZCommentCell"];
}

+ (CGFloat)getCellHeightFromModel:(SZCommentModel *)model
{
    CGFloat height = [UIUtil getLabelHeightWithFontSize:14 Width:288 String:model.comment];
    NSLog(@"height is %f",height);
    return 188-54+height;
}

- (void)addStarViewWith:(CGFloat)starLevel
{
    _rateView = [SZRateView loadFromXib];
    _rateView.left = 6;
    _rateView.top = 65;
    [_bgView addSubview:_rateView];
    [_rateView setStarLevel:starLevel];
}

- (void)getDataSourceFromModel:(SZCommentModel *)model
{
    self.model = model;
    CGFloat height = [UIUtil getLabelHeightWithFontSize:14 Width:288 String:model.comment];
    _contentLabel.height = ceilf(height);
    _contentLabel.text = model.comment;
    if(model && [model isKindOfClass:[SZCommentModel class]]){
        _shopNameLabel.text = model.store_name;
        _personNameLabel.text = model.user_name;
        if(IS_STRING_NOT_EMPTY(model.score)){
            _rateLabel.text = [NSString stringWithFormat:@"%@分",model.score];
            [self addStarViewWith:[model.score floatValue]];
        }
        //
        _timeLabel.text = [UIUtil getLongTimeString:[model.add_time doubleValue]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteComment:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];

}

- (IBAction)didClickCell:(id)sender
{
    [[UserManager sharedUserManager] getCurrentLocationWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, BOOL isSuccess) {
        
        SZMerchantDetailViewController *merchantViewController = [[SZMerchantDetailViewController alloc]init];
        merchantViewController.requestModel.store_id = _model.store_id;
        merchantViewController.requestModel.lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
        merchantViewController.requestModel.lng = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
        merchantViewController.shareImage = nil;
        [self pushMasterViewController:merchantViewController];
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary *param = @{@"aa_id": _model.aa_id,
                                PARAMS_METHOD_KEY:SZINDEX_USER_DELCOMMENT_METHOD
                                };
        [ITTASIBaseDataRequest requestWithParameters:param
                                   withIndicatorView:nil
                                   withCancelSubject:nil
                                      onRequestStart:nil
                                   onRequestFinished:^(ITTBaseDataRequest *request)
         {
             if (request.isSuccess) {
                 [_delegate deleteCommentForCellModel:self.model];
             }
         }
                                   onRequestCanceled:nil
                                     onRequestFailed:nil];
    }
}
@end






