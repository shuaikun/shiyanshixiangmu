//
//  SZMembershipCardDetailViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMembershipCardDetailViewController.h"
#import "ITTImageView.h"
#import "SZRateView.h"
#import "SZMembershipCardPreviewViewController.h"
#import "SZGoodsDetailRequest.h"
#import "SZPreferentialModel.h"
#import "SZStoreModel.h"
#import "UIUtil.h"
#import "SZMerchantDetailViewController.h"
#import "SZGoodsRecordRequest.h"
#import "AppDelegate.h"
#import "SZNearByBigPhotoViewController.h"
#import "SZNearByFocusPicModel.h"
#import "SZCouponModel.h"

@interface SZMembershipCardDetailViewController ()<UIAlertViewDelegate,ITTImageViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *membershipCountLabel;

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIView *describeView;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

@property (weak, nonatomic) IBOutlet UIView *addMembershipCardView;
@property (weak, nonatomic) IBOutlet UIButton *reGetButton;
@property (weak, nonatomic) IBOutlet UIButton *addCardButton;
@property (weak, nonatomic) IBOutlet UIImageView *addCardImageView;
@property (weak, nonatomic) IBOutlet UIView *unTouchView;
@property (weak, nonatomic) IBOutlet UILabel *unTouchLabel;
@property (weak, nonatomic) IBOutlet UIButton *alreadyAddButton;

@property (weak, nonatomic) IBOutlet UIView *shopDetailView;
@property (weak, nonatomic) IBOutlet UIView *shopDetailSmallView;
@property (weak, nonatomic) IBOutlet UILabel *detailShopNameLabel;
@property (weak, nonatomic) IBOutlet ITTImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (strong, nonatomic) NSString *picurl;

@property (weak, nonatomic) IBOutlet UILabel *phoneShopNameLabel;

@property (weak, nonatomic) SZRateView *rateView;
@property (strong, nonatomic) NSString *telephone;
@property (strong, nonatomic) NSString *detailName;
@property (strong, nonatomic) NSString *store_id;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *code;

@property (assign, nonatomic) int inceaseCount;
@property (assign, nonatomic) BOOL notFirst;

@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;


- (IBAction)onAddMembershipCardButtonClicked:(id)sender;
- (IBAction)onPhoneAppointmentButtonClicked:(id)sender;
- (IBAction)onReGetButtonClicked:(id)sender;
- (IBAction)onEnterMerchantDetailVCButtonClicked:(id)sender;


@end

@implementation SZMembershipCardDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hiddenTopView];
    _topView = [SZPreferentialRelativeTopView loadFromXib];
    _topView.delegate = self;
    if(IS_IOS_7){
        _topView.top = 20;
    }
    [_topView ifCoupon:NO];
    _shopNameLabel.text = _store_name;
    [self.view addSubview:_topView];
    [self beginGooodsDetailRequest];
    [MobClick event:UMMemberShipCardLoading];
}

- (void)setButtonsPatternWithType:(int)type
{
    [_addCardButton setImageName:@"SZ_BTN_ORANGE.png" stretchWithLeft:8 top:0 forState:UIControlStateNormal];
    [_addCardButton setImageName:@"SZ_BTN_ORANGE_H.png" stretchWithLeft:8 top:0 forState:UIControlStateHighlighted];
    [_reGetButton setImageName:@"SZ_BTN_ORANGE.png" stretchWithLeft:8 top:0 forState:UIControlStateNormal];
    [_reGetButton setImageName:@"SZ_BTN_ORANGE_H.png" stretchWithLeft:8 top:0 forState:UIControlStateHighlighted];
    
    _alreadyAddButton.layer.masksToBounds = YES;
    _alreadyAddButton.layer.cornerRadius = 3;
    _unTouchView.layer.masksToBounds = YES;
    _unTouchView.layer.cornerRadius = 3;
    //按钮类型1获取 2即将开始 3已结束 4重新获取 5已获取
    if(type == 1){
        _addCardButton.hidden = NO;
        _addCardImageView.hidden = NO;
        _reGetButton.hidden = YES;
        _unTouchView.hidden = YES;
        _unTouchLabel.hidden = YES;
    }
    else if(type == 2){
        _addCardButton.hidden = YES;
        _addCardImageView.hidden = YES;
        _reGetButton.hidden = YES;
        _unTouchView.hidden = NO;
        _unTouchLabel.hidden = NO;
        _unTouchLabel.text = @"即将开始";
    }
    else if(type == 3){
        _addCardButton.hidden = YES;
        _addCardImageView.hidden = YES;
        _reGetButton.hidden = YES;
        _unTouchView.hidden = NO;
        _unTouchLabel.hidden = NO;
        _unTouchLabel.text = @"已结束";
    }
    else if(type == 5){
        _addCardImageView.hidden = YES;
        _reGetButton.hidden = YES;
        _unTouchView.hidden = YES;
        _unTouchLabel.hidden = YES;
        _addCardButton.hidden = YES;
        _alreadyAddButton.hidden = NO;
    }
    else{
        _addCardButton.hidden = YES;
        _addCardImageView.hidden = YES;
        _reGetButton.hidden = NO;
        _unTouchView.hidden = YES;
        _unTouchLabel.hidden = YES;
    }
}

- (void)beginGooodsDetailRequest
{
    __weak typeof(self) weakSelf = self;
    [[UserManager sharedUserManager] getCurrentLocationWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, BOOL isSuccess) {
        if(isSuccess){
            
            typeof(SZMembershipCardDetailViewController) *strongSelf = weakSelf;
            NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:SZINDEX_GOODS_DETAIL_METHOD forKey:PARAMS_METHOD_KEY];
            if ([[UserManager sharedUserManager] isLogin]) {
                [paramDict setObject:[[UserManager sharedUserManager] userId] forKey:PARAMS_USER_ID];
            }
            [paramDict setObject:strongSelf.goods_id forKey:@"goods_id"];
            [paramDict setObject:[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude] forKey:@"lng"];
            [paramDict setObject:[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude] forKey:@"lat"];
            NSLog(@"paramDict is %@",paramDict);
            [SZGoodsDetailRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                NSLog(@"start loading");
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            } onRequestFinished:^(ITTBaseDataRequest *request) {
                if (request.isSuccess) {
                    
                    NSString *state = [request.handleredResult objectForKey:@"state"];
                    if([state isEqualToString:@"1"]){
                        strongSelf.noDataLabel.hidden = YES;
                        strongSelf.backgroundView.hidden = NO;
                        SZPreferentialModel *preferentialModel = [request.handleredResult objectForKey:@"preferentialModel"];
                        SZStoreModel *storeModel = [request.handleredResult objectForKey:@"storeModel"];
                        if(preferentialModel && storeModel){
                            NSLog(@"preferentialModel is %@,storeModel is %@",preferentialModel,storeModel);
                            //refresh
                            [strongSelf getDataSourceFromPreferentialModel:preferentialModel];
                            [strongSelf getDataSourceFromStoreModel:storeModel];
                        }
                    }
                    else{
                        strongSelf.noDataLabel.hidden = NO;
                    }
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
            }];
        }
    }];
}

- (void)preferentialRelativeTopViewBackButtonClicked
{
    [self popMasterViewController];
}

- (void)preferentialRelativeTopViewShareButtonClicked
{
    [MobClick event:UMMemberShipCardShare];
    NSString *title = _shopNameLabel.text;
    NSString *url = APP_DOWNLOAD_URL;
    NSString *content = [NSString stringWithFormat:@"亲们，我在泰优惠APP发现了%@的会员卡，%@。安装泰优惠APP即可获得，一起来下载吧 %@",_shopNameLabel.text,_discountLabel.text,url];
    AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
    [appDelegate shareWithTitle:title content:content image:self.shareImage];
}

- (void)preferentialRelativeTopViewShowPictureButtonClicked
{
    SZMembershipCardPreviewViewController *membershipCardPreviewViewController = [[SZMembershipCardPreviewViewController alloc] initWithNibName:@"SZMembershipCardPreviewViewController" bundle:nil];
    if(IS_STRING_NOT_EMPTY(_picurl)){
        membershipCardPreviewViewController.picurl = _picurl;
    }
    if (IS_STRING_NOT_EMPTY(_code)) {
        membershipCardPreviewViewController.number = [NSString stringWithFormat:@"NO.%@",_code];
    }

    membershipCardPreviewViewController.name = _shopNameLabel.text;
    membershipCardPreviewViewController.discount = _couponModel.goods_name;
    membershipCardPreviewViewController.picurl = _picurl;
    [self pushMasterViewController:membershipCardPreviewViewController];
}

- (void)getDataSourceFromPreferentialModel:(SZPreferentialModel *)model
{
    _membershipCountLabel.text = [NSString stringWithFormat:@"已有会员%@人",model.sales];
    _inceaseCount = [model.sales intValue];
    _number = model.sales;
    _code = model.code;
    _describeLabel.text = model.descrip;
    CGFloat height = [UIUtil getLabelHeightWithFontSize:13 Width:302 String:model.descrip];
    _describeLabel.height = ceilf(height);
    _describeView.height = 68-50+_describeLabel.height;
    _cardView.height = 234-68+_describeView.height;
    _shopDetailView.top = _cardView.height+2;
    [_scrollView setContentSize:CGSizeMake(320, _shopDetailView.top+_shopDetailView.height)];
    //
    if(IS_STRING_NOT_EMPTY(model.goods_name.fifth)){
        _discountLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",model.goods_name.first,model.goods_name.second,model.goods_name.third,model.goods_name.forth,model.goods_name.fifth];
    }
    else if(IS_STRING_NOT_EMPTY(model.goods_name.third)){
        _discountLabel.text = [NSString stringWithFormat:@"%@ %@ %@",model.goods_name.first,model.goods_name.second,model.goods_name.third];
    }
    else{
        _discountLabel.text = model.goods_name.first;
    }
    [self setButtonsPatternWithType:[model.button intValue]];
    if([model.is_pic isEqualToString:@"1"]){
        _picurl = model.show_url;
    }
}

- (void)getDataSourceFromStoreModel:(SZStoreModel *)model
{
    if(IS_STRING_NOT_EMPTY(model.pic_url)){
        _shopImageView.enableTapEvent = YES;
        _shopImageView.delegate = self;
        [_shopImageView loadImage:model.pic_url placeHolder:[UIImage imageNamed:@"SZ_Mine_Default_Big_Placeholder.png"]];
    }
    _telephone = model.tel;
    _store_id = model.store_id;
    _detailShopNameLabel.text = model.store_name;
    _phoneShopNameLabel.text = model.store_name;
    _detailName = model.store_name;
    if(IS_STRING_EMPTY(_shopNameLabel.text)){
        _shopNameLabel.text = model.store_name;
    }
    _priceLabel.text = [NSString stringWithFormat:@"%d元",[model.capita intValue]];
    _addressLabel.text = model.address;
    _distanceLabel.text = model.distance;
    _rateLabel.text = [NSString stringWithFormat:@"%.1f分",[model.score floatValue]];
    _telLabel.text = [model.enterType isEqualToString:@"-1"]?@"电话":@"电话预约";
    [self addStarViewWithStatNumber:[model.score floatValue]];
}

- (void)addStarViewWithStatNumber:(float)number
{
    _rateView = [SZRateView loadFromXib];
    _rateView.left = 140;
    _rateView.top = 14;
    [_shopDetailSmallView addSubview:_rateView];
    [_rateView setStarLevel:number];
}

- (void)imageViewDidClicked:(ITTImageView *)imageView
{
    SZNearByBigPhotoViewController *bigPhoto = [[SZNearByBigPhotoViewController alloc]init];
    SZNearByFocusPicModel *picModl = [[SZNearByFocusPicModel alloc] init];
    picModl.pic_url = _shopImageView.imageUrl;
    bigPhoto.pics = [NSMutableArray arrayWithObjects:picModl, nil];
    [self pushMasterViewController:bigPhoto];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)beginGooodsRecordRequest
{

    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:SZINDEX_GOODS_RECORD_METHOD forKey:PARAMS_METHOD_KEY];
        [paramDict setObject:userId forKey:PARAMS_USER_ID];
        [paramDict setObject:_goods_id forKey:@"goods_id"];
        [paramDict setObject:@"1" forKey:@"type"]; // 1下载0删除（默认下载操作）
        [SZGoodsRecordRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                if(_notFirst){
                    [PROMPT_VIEW showMessage:@"重新获取成功！"];
                }
                else{
                    [PROMPT_VIEW showMessage:@"获取成功，已为您添加至我的会员卡！"];
                    _membershipCountLabel.text = [NSString stringWithFormat:@"已有会员%d人",_inceaseCount+1];
                }
                _addCardImageView.hidden = YES;
                _addCardButton.hidden = YES;
                _reGetButton.hidden = YES;
                _alreadyAddButton.hidden = NO;

            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
        }];
    }];
}

- (IBAction)onAddMembershipCardButtonClicked:(id)sender
{
    [self beginGooodsRecordRequest];
}

- (IBAction)onPhoneAppointmentButtonClicked:(id)sender
{
    if(IS_STRING_NOT_EMPTY(_telephone)){
        [MobClick event:UMMemberShipCardCallPhone];
        [self takePhoneCall:_telephone];
    }
}


- (IBAction)onReGetButtonClicked:(id)sender
{
    _notFirst = YES;
    [self beginGooodsRecordRequest];
}

- (IBAction)onEnterMerchantDetailVCButtonClicked:(id)sender
{
    SZMerchantDetailViewController *merchantViewController = [[SZMerchantDetailViewController alloc]init];
    merchantViewController.requestModel.store_id = _store_id;
    merchantViewController.requestModel.lat = _lat;
    merchantViewController.requestModel.lng = _lng;
    [self pushMasterViewController:merchantViewController];
}

@end

















