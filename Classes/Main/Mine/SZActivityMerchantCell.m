//
//  SZActivityMerchantCell.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZActivityMerchantCell.h"
#import "ITTXibViewUtils.h"
#import "ITTImageView.h"
#import "SZCouponDetailViewController.h"
#import "SZMerchantDetailViewController.h"
#import "SZRateView.h"
#import "SZMembershipCardPreviewViewController.h"
#import "SZNearByCollectStoreRequest.h"
@interface SZActivityMerchantCell()<ITTImageViewDelegate>
{
    NSString *_storeid;
    NSString *_lng;
    NSString *_lat;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet ITTImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *distanceIcon;
@property (weak, nonatomic) IBOutlet UIImageView *quanImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) SZRateView *rateView;
@property (strong, nonatomic) NSString *bigPicUrl;

- (IBAction)onShowDetailButtonClicked:(id)sender;
- (IBAction)onDeleteOneMerchantButtonClicked:(id)sender;

@end

@implementation SZActivityMerchantCell

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

+ (SZActivityMerchantCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SZActivityMerchantCell"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _shopImageView.delegate = self;
    _shopImageView.enableTapEvent = YES;
    [self addGestureRecognizer];
}

- (void)addGestureRecognizer
{
    UISwipeGestureRecognizer *rswipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveBgViewRight)];
    rswipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rswipeGestureRecognizer];
    UISwipeGestureRecognizer *lswipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveBgViewLeft)];
    lswipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:lswipeGestureRecognizer];
}

- (void)moveBgViewRight
{
    if(!_ifNearby){
        [UIView animateWithDuration:0.3 animations:^{
            _bgView.left = 70;
        }];
    }
}

- (void)moveBgViewLeft
{
    if(!_ifNearby){
        [UIView animateWithDuration:0.3 animations:^{
            _bgView.left = 10;
        }];
    }
}

- (void)imageViewDidClicked:(ITTImageView *)imageView
{
    if(IS_STRING_NOT_EMPTY(_bigPicUrl)){
//        SZNearByBigPhotoViewController *bigPhoto = [[SZNearByBigPhotoViewController alloc]init];
//        bigPhoto.pics = [NSMutableArray arrayWithObjects:_bigPicUrl, nil];
//        [self pushMasterViewController:bigPhoto];
        
        SZMembershipCardPreviewViewController *bigPhoto = [[SZMembershipCardPreviewViewController alloc]init];
        bigPhoto.picurl = _bigPicUrl;
        [self pushMasterViewController:bigPhoto];
    }
}

- (void)addStarViewWithStar:(CGFloat)starLevel
{
    if (_rateView == nil) {
        _rateView = [SZRateView loadFromXib];
        _rateView.left = 128;
        _rateView.top = 28;
        [_bgView addSubview:_rateView];
    }
    [_rateView setStarLevel:starLevel];
}

- (void)getDataSourceFromModel:(SZActivityMerchantModel *)model
{
    if (model!=nil&&[model isKindOfClass:[SZActivityMerchantModel class]]) {
        NSLog(@"model shit is %@",model);
        if(_isFromCollect){
            _distanceLabel.hidden = YES;
            _distanceIcon.hidden = YES;
        }
        _storeid = model.store_id;
        _lng = model.lng;
        _lat = model.lat;
        if(IS_STRING_NOT_EMPTY(model.distance)){
            _distanceLabel.text = model.distance;
            self.distanceIcon.hidden = NO;
        }
        else{
            self.distanceLabel.text = @"";
            self.distanceLabel.hidden = YES;
        }
        /*修改by成焱,主要是当只有卡的时候，显示的时候就会距离右边有一定的距离*/
        int flag = [model.supply_card intValue];
        if (flag==0) {
            self.quanImageView.hidden = YES;
            self.cardImageView.hidden = YES;
        }else if (flag==1){
            self.quanImageView.hidden = NO;
            self.cardImageView.hidden = YES;
            self.quanImageView.image = [UIImage imageNamed:@"SZ_NearBy_Merchant_Card.png"];
        }else if (flag==2){
            self.quanImageView.hidden = NO;
            self.cardImageView.hidden = YES;
            self.quanImageView.image = [UIImage imageNamed:@"SZ_NearBy_Merchant_Quan.png"];
        }else{
            self.quanImageView.hidden = NO;
            self.cardImageView.hidden = NO;
            self.cardImageView.image = [UIImage imageNamed:@"SZ_NearBy_Merchant_Card.png"];
            self.quanImageView.image = [UIImage imageNamed:@"SZ_NearBy_Merchant_Quan.png"];
        }
        
        _bigPicUrl = nil;
        if ([model.is_pic isEqualToString:@"1"] && IS_STRING_NOT_EMPTY(model.show_url)) {
            _bigPicUrl = model.show_url;

        }
        [_shopImageView loadImage:model.pic_url placeHolder:[UIImage imageNamed:@"SZ_Mine_Default_Big_Placeholder.png"]];
        self.shopNameLabel.text = model.store_name;
        self.addressLabel.text = model.address;
        
        NSInteger price = [model.capita integerValue];
        self.priceLabel.text = [NSString stringWithFormat:@"¥%d",price];
        
        [self addStarViewWithStar:[model.store_score floatValue]];
        
        _bgView.left = 10;
    }
}

- (IBAction)onShowDetailButtonClicked:(id)sender
{
    SZMerchantDetailViewController *merchantViewController = [[SZMerchantDetailViewController alloc]init];
    merchantViewController.requestModel.store_id = _storeid;
    merchantViewController.requestModel.lat = _lat;
    merchantViewController.requestModel.lng = _lng;
    merchantViewController.shareImage = self.shopImageView.image==[UIImage imageNamed:@"SZ_Mine_Default_Big_Placeholder.png"]?nil:self.shopImageView.image;
    [self pushMasterViewController:merchantViewController];
}

- (IBAction)onDeleteOneMerchantButtonClicked:(id)sender
{
    [self beginGooodsRecordRequest];
}

- (void)beginGooodsRecordRequest
{
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_storeid,@"store_id",userId,@"user_id",@"-1",@"act",SZNEARBY_COLLECTSTOREC,PARAMS_METHOD_KEY, nil];
        [SZNearByCollectStoreRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:CANCEL_SUBJECT_ON_COLLECT_STORE_REQUEST
                                            onRequestStart:nil
                                         onRequestFinished:^(ITTBaseDataRequest *request){
                                                if (request.isSuccess) {
                                                    [PROMPT_VIEW showMessage:@"删除成功"];
                                                    if(_delegate && [_delegate respondsToSelector:@selector(merchantCellFinishDeleteIndex:)]){
                                                        [_delegate merchantCellFinishDeleteIndex:_index];
                                                    }
                                                }
                                            } onRequestCanceled:nil
                                           onRequestFailed:nil];
    }];
    

}

@end













