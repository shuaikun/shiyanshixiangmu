//
//  SZMerchantDetailViewController.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-16.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMerchantDetailViewController.h"
#import "ITTImageSliderView.h"
#import "ITTPageView.h"
#import "SZStarView.h"
#import "SZMerchantDiscountView.h"
#import "SZMerchantDetailPhotoView.h"
#import "SZMerchantDetailShopInfomationView.h"
#import "SZMerchantDetailCommentView.h"
#import "SZMerchantDetailAroundView.h"
#import "SZFetchCommentViewController.h"
#import "SZMerchantDetailPhotoAlbumViewController.h"
#import "SZNearByMerchantDetailRequest.h"
#import "SZNearByMerchantDetailModel.h"
#import "SZNearByCollectStoreRequest.h"
#import "SZNearByProductPhotoViewController.h"
#import "SZNearByBigPhotoViewController.h"
#import "SZNearByShopAddressMapViewController.h"
#import "AppDelegate.h"
#import "SZCouponDetailViewController.h"
#import "SZMembershipCardDetailViewController.h"
#import "SZUserCommentViewController.h"
#import "SZRateView.h"
typedef NS_ENUM(NSUInteger, SZStoreCollectFlag){
    kFlagIsCollect = 0,
    kFlagIsNotCollect,
};

@interface SZMerchantDetailViewController ()<ITTImageSliderViewDelegate>
{
    BOOL _firstShow;
}
@property (nonatomic, strong) SZMerchantDiscountView *discountView;
@property (nonatomic, strong) SZMerchantDetailPhotoView *photoView;
@property (nonatomic, strong) SZMerchantDetailShopInfomationView *shopInfoView;
@property (nonatomic, strong) SZMerchantDetailCommentView *commentView;
@property (nonatomic, strong) SZMerchantDetailAroundView *aroundView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet ITTImageSliderView *imageSliderView;
@property (strong, nonatomic) ITTPageView *pageView;

@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet SZRateView *topStarView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomStoreNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (readwrite, nonatomic) NSInteger act;
@property (readwrite, nonatomic) SZStoreCollectFlag collectFlag;
@property (readwrite, nonatomic) BOOL isCollectFinished;


@property (nonatomic, strong) SZNearByMerchantDetailModel *detailModel;

- (IBAction)handleBackClick:(id)sender;
- (IBAction)handleShareBtnClick:(id)sender;
- (IBAction)handleCollectBtnClick:(id)sender;
- (IBAction)handleTakePhoneBtnClick:(id)sender;

@end

@implementation SZMerchantDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.requestModel = [SZNearByMerchantDetailRequestModel new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _collectFlag = kFlagIsNotCollect;
    _isCollectFinished = YES;
    _firstShow = YES;
    self.baseTopView.hidden = YES;
    [MobClick event:UMMerchantDetailLoading];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self startMerchantDetailRequest];
}

- (void)doInitSliderView
{
    NSMutableArray *pics = [self.detailModel focusPics];
    _imageSliderView.delegate = self;
    _imageSliderView.backgroundColor = [UIColor clearColor];
    _imageSliderView.placeHolderImageUrl = @"SZ_NEARBY_TOP_DEFAULT.png";
    NSMutableArray *imageUrls = [[NSMutableArray alloc]init];
    for (SZNearByFocusPicModel *model in pics) {
        NSLog(@"model.pic_url shit is %@",model.pic_url);
        [imageUrls addObject:model.pic_url];
    }
    [_imageSliderView setImageUrls:imageUrls];
    if (_pageView==nil) {
        _pageView = [[ITTPageView alloc] initWithPageNum:[imageUrls count]];
        _pageView.top = _imageSliderView.bottom - 17;
        _pageView.left = (CGRectGetWidth(self.view.bounds) - CGRectGetWidth(_pageView.frame)) / 2;
        [_imageSliderView.superview addSubview:_pageView];
        [_imageSliderView startAutoScrollWithDuration:3];
        if ([imageUrls count]==0) {
            _imageSliderView.height = 0;
        }else if ([imageUrls count]==1){
            _pageView.hidden = YES;
        }
    }else{
        [_pageView removeFromSuperview];
        _pageView = [[ITTPageView alloc] initWithPageNum:[imageUrls count]];
        _pageView.top = _imageSliderView.bottom - 17;
        _pageView.left = (CGRectGetWidth(self.view.bounds) - CGRectGetWidth(_pageView.frame)) / 2;
        [_imageSliderView.superview addSubview:_pageView];
        [_imageSliderView startAutoScrollWithDuration:3];
        if ([imageUrls count]==0) {
            _imageSliderView.height = 0;
        }else if ([imageUrls count]==1){
            _pageView.hidden = YES;
        }
    }
}

- (void)doInitDescriptionView
{
    self.topStarView = [SZRateView loadFromXib];
    self.topStarView.frame = CGRectMake(15, 45, 83, 14);
    self.topStarView.starLevel  = [self.detailModel.store.score floatValue];
    self.telLabel.text = [self.detailModel.store.enterType isEqualToString:@"-1"]?@"电话":@"电话预约";
    [self.descriptionView addSubview:self.topStarView];
    self.merchantNameLabel.text = self.detailModel.store.store_name;
    self.bottomStoreNameLabel.text = self.detailModel.store.store_name;
    self.scoreLabel.text = [NSString stringWithFormat:@"%@分",self.detailModel.store.score];
    NSInteger price = [self.detailModel.store.capita integerValue];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%d",price];
    self.descriptionView.top = _imageSliderView.bottom;
    self.descriptionView.height = 80;
}

- (void)doInitMerchantDiscountView
{
    __block SZMerchantDetailViewController *vc = self;
    if (_discountView==nil) {
        _discountView = [[SZMerchantDiscountView alloc]initWithFrame:CGRectMake(0, self.descriptionView.bottom, 320, 0) discounts:self.detailModel.goods];
        _discountView.callBack = ^(float offset, BOOL show){
            if (show) {
                [UIView animateWithDuration:0.3f animations:^(void){
                    vc.scrollerView.contentSize = CGSizeMake(320, vc.scrollerView.contentSize.height + offset);
                    vc.photoView.top = vc.discountView.bottom;
                    vc.shopInfoView.top = vc.photoView.bottom;
                    vc.commentView.top = vc.shopInfoView.bottom;
                    vc.aroundView.top = vc.commentView.bottom;
                }];
            }else{
                [UIView animateWithDuration:0.3f animations:^(void){
                    vc.scrollerView.contentSize = CGSizeMake(320, vc.scrollerView.contentSize.height - offset);
                    vc.photoView.top = vc.discountView.bottom;
                    vc.shopInfoView.top = vc.photoView.bottom;
                    vc.commentView.top = vc.shopInfoView.bottom;
                    vc.aroundView.top = vc.commentView.bottom;
                }];
            }
        };
        _discountView.clickCallBack = ^(SZNearByGoodModel *good){
            if([good.type isEqualToString:@"1"]){
                SZCouponDetailViewController *couponDetailViewController = [[SZCouponDetailViewController alloc] initWithNibName:@"SZCouponDetailViewController" bundle:nil];
                couponDetailViewController.goods_id = good.goods_id;
                couponDetailViewController.store_name = good.goods_name;
                [vc pushMasterViewController:couponDetailViewController];
            }
            else if([good.type isEqualToString:@"2"]){
                SZMembershipCardDetailViewController *membershipCardDetailViewController = [[SZMembershipCardDetailViewController alloc] initWithNibName:@"SZMembershipCardDetailViewController" bundle:nil];
                membershipCardDetailViewController.goods_id = good.goods_id;
                membershipCardDetailViewController.store_name = good.goods_name;
                [vc pushMasterViewController:membershipCardDetailViewController];
            }
        };
        [self.scrollerView addSubview:_discountView];
    }
    _discountView.top = _descriptionView.bottom;
}

- (void)doInitMerchantPhotoView
{
    __block SZMerchantDetailViewController *vc = self;
    if (_photoView==nil) {
        _photoView = [[SZMerchantDetailPhotoView alloc]initWithFrame:CGRectMake(0, _discountView.bottom, 320, 203) pics:[self.detailModel productPics]];
        _photoView.moreClick = ^(void){
            SZMerchantDetailPhotoAlbumViewController *album = [[SZMerchantDetailPhotoAlbumViewController alloc]init];
            album.storeId = vc.requestModel.store_id;
            [vc pushMasterViewController:album];
        };
        _photoView.moreNumber = self.detailModel.productPic_totleNumber;
        _photoView.picClick = ^(SZNearByProductPicModel *pic){
            SZNearByProductPhotoViewController *photo = [[SZNearByProductPhotoViewController alloc]init];
            photo.pic = pic;
            [vc pushMasterViewController:photo];
        };
        [self.scrollerView addSubview:_photoView];
    }
    _photoView.top = _discountView.bottom;
}

- (void)doInitShopInfomationView
{
    __block SZMerchantDetailViewController *vc = self;
    if (_shopInfoView==nil) {
        if (self.detailModel.store!=nil) {
            _shopInfoView = [[SZMerchantDetailShopInfomationView alloc]initWithFrame:CGRectMake(0, _photoView.bottom, 320, 177)];
            _shopInfoView.address = self.detailModel.store.address;
            _shopInfoView.time = self.detailModel.store.open_time;
            _shopInfoView.addtion = self.detailModel.store.description;
            NSString *distance = self.detailModel.store.distance;
            _shopInfoView.distance = distance;
            _shopInfoView.mapClick = ^(void){
                SZNearByShopAddressMapViewController *shopMap = [[SZNearByShopAddressMapViewController alloc]init];
                shopMap.storeModel = vc.detailModel.store;
                [vc pushMasterViewController:shopMap];
            };
            
            if (!IS_STRING_EMPTY(self.detailModel.store.is_collected)&&[self.detailModel.store.is_collected isEqualToString:@"1"]) {
                _collectFlag = kFlagIsCollect;
                _act = -1;//如果已经收藏了，那么需要做的操作就是取消收藏
            }else{
                _collectFlag = kFlagIsNotCollect;
                _act = 1;//如果没有收藏，那么需要做的操作就是进行收藏
            }
            UIImage *collectBgImage = _collectFlag==kFlagIsCollect?[UIImage imageNamed:@"SZ_NEARBY_COLLECTED.png"]:[UIImage imageNamed:@"SZ_NearBy_Collect_Normal.png"];
            [self.collectionBtn setBackgroundImage:collectBgImage forState:UIControlStateNormal];
        }else{
            _shopInfoView = [[SZMerchantDetailShopInfomationView alloc]initWithFrame:CGRectMake(0, _photoView.bottom, 320, 0)];
            
        }
        [self.scrollerView addSubview:_shopInfoView];

    }
    _shopInfoView.top = _photoView.bottom;
}

- (void)doInitCommentView
{
    __block SZMerchantDetailViewController *vc = self;
    if (_commentView==nil) {
        _commentView = [[SZMerchantDetailCommentView alloc]initWithFrame:CGRectMake(0, _shopInfoView.bottom, 320, 164) andCommentModel:self.detailModel.comment andTotleNumber:self.detailModel.comment_totleNumber];
        _commentView.moreClick = ^(void){
            SZFetchCommentViewController *commentVC  = [[SZFetchCommentViewController alloc]init];
            commentVC.store_id = vc.requestModel.store_id;
            [vc pushMasterViewController:commentVC];
        };
        _commentView.addCommentClick = ^(void){
            SZUserCommentViewController *userCommentVC = [[SZUserCommentViewController alloc]init];
            userCommentVC.storeid = vc.requestModel.store_id;
            [vc pushMasterViewController:userCommentVC];
        };
        [self.scrollerView addSubview:_commentView];
    }else{
        [_commentView removeFromSuperview];
        _commentView = [[SZMerchantDetailCommentView alloc]initWithFrame:CGRectMake(0, _shopInfoView.bottom, 320, 164) andCommentModel:self.detailModel.comment andTotleNumber:self.detailModel.comment_totleNumber];
        _commentView.moreClick = ^(void){
            SZFetchCommentViewController *commentVC  = [[SZFetchCommentViewController alloc]init];
            commentVC.store_id = vc.requestModel.store_id;
            [vc pushMasterViewController:commentVC];
        };
        _commentView.addCommentClick = ^(void){
            SZUserCommentViewController *userCommentVC = [[SZUserCommentViewController alloc]init];
            userCommentVC.storeid = vc.requestModel.store_id;
            [vc pushMasterViewController:userCommentVC];
        };
        [self.scrollerView addSubview:_commentView];
    }
    _commentView.top = _shopInfoView.bottom;
}

- (void)doInitAroundView
{
    __block SZMerchantDetailViewController *vc = self;
    if (_aroundView==nil) {
        _aroundView = [[SZMerchantDetailAroundView alloc]initWithFrame:CGRectMake(0, _commentView.bottom, 320, 100) aroundShops:self.detailModel.aroundShops];
        _aroundView.click = ^(NSString* storeId){
            SZMerchantDetailViewController *detail = [[SZMerchantDetailViewController alloc]init];
            detail.requestModel.store_id = storeId;
            [vc pushMasterViewController:detail];
        };
        [self.scrollerView addSubview:_aroundView];
    }
    _aroundView.top = _commentView.bottom;
    self.scrollerView.contentSize = CGSizeMake(320, _aroundView.bottom + 20);
}

- (void)startMerchantDetailRequest
{
    [[UserManager sharedUserManager] getCurrentLocationWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, BOOL isSuccess) {
        if (isSuccess) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if ([[UserManager sharedUserManager]isLogin]) {
                NSString *userid = [[UserManager sharedUserManager]userId];
                [params setObject:userid forKey:@"user_id"];
            }
            [params setObject:self.requestModel.store_id forKey:@"store_id"];
            [params setObject:[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude] forKey:@"lat"];
            [params setObject:[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude] forKey:@"lng"];
            [params setObject:SZ_STORE_DETAIL forKey:PARAMS_METHOD_KEY];
            [params setObject:@"1" forKey:@"plat"];

            [SZNearByMerchantDetailRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:CANCEL_SUBJECT_ON_MERCHANT_DETAIL_REQUEST onRequestStart:^(ITTBaseDataRequest *request){
                [PROMPT_VIEW showActivityWithMask:@"数据载入中..."];
            } onRequestFinished:^(ITTBaseDataRequest *request){
                if ([request.result isSuccess]) {
                     self.detailModel = [request.handleredResult objectForKey:NETDATA];
                    if ([self.detailModel.store.state isEqualToString:@"1"]) {
                        self.descriptionView.hidden = NO;
                        [self doTotleInit];
                    }else{
                        self.noDataLabel.hidden = NO;
                        self.bottomView.hidden = YES;
                        self.shareBtn.enabled = NO;
                        self.collectionBtn.enabled = NO;
                    }
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request){

            } onRequestFailed:^(ITTBaseDataRequest *request){

            }];
        }
    }];
}

- (void)doTotleInit
{
    [self doInitSliderView];
    [self doInitDescriptionView];
    [self doInitMerchantDiscountView];
    [self doInitMerchantPhotoView];
    [self doInitShopInfomationView];
    [self doInitCommentView];
    [self doInitAroundView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imageDidScrollWithIndex:(int)imageIndex
{
    [_pageView setCurrentPage:imageIndex];
}

- (void)imageClickedWithIndex:(int)imageIndex
{
    if ([self.detailModel.focusPics count]!=0) {
        SZNearByBigPhotoViewController *bigPhoto = [[SZNearByBigPhotoViewController alloc]init];
        bigPhoto.currentIndex = imageIndex;
        bigPhoto.pics = self.detailModel.focusPics;
        bigPhoto.currentIndex = imageIndex;
        [self pushMasterViewController:bigPhoto];
    }
}

- (IBAction)handleBackClick:(id)sender {
    [self popMasterViewController];
}

- (IBAction)handleShareBtnClick:(id)sender {
    [MobClick event:UMMerchantDetailShare];
    NSString *title = self.detailModel.store.store_name;
    NSMutableString *content =  [[NSMutableString alloc]init];
    [content appendString:@"亲们,我在泰优惠APP发现一家不错的店,"];
    NSString *(^safetyStr)(NSString * obj) = ^(NSString * obj){
        if (IS_STRING_NOT_EMPTY(obj)) {
            return obj;
        }else{
            return @"";
        }
    };
    [content appendString:safetyStr(self.detailModel.store.store_name)];
    [content appendString:@","];
    [content appendString:safetyStr(self.detailModel.store.address)];
    [content appendString:@" \n评分:"];
    [content appendString:safetyStr(self.detailModel.store.score)];
    [content appendString:@",人均:￥"];
    NSString *money = safetyStr(self.detailModel.store.capita);
    if ([money isEqualToString:@""]) {
        money = @"0";
    }
    [content appendString:money];
    [content appendString:@",\n推荐你也来下载吧，"];//TODO:
    [content appendString:APP_DOWNLOAD_URL];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app shareWithTitle:title content:content image:self.shareImage];
}

- (IBAction)handleCollectBtnClick:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    if (_isCollectFinished==YES) {
        NSString *storeid = self.requestModel.store_id;
        [[UserManager sharedUserManager]userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
            typeof(weakSelf) strongSelf = weakSelf;
            NSString *act = [NSString stringWithFormat:@"%d",strongSelf.act];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:storeid,@"store_id",userId,@"user_id",act,@"act",SZNEARBY_COLLECTSTOREC,PARAMS_METHOD_KEY, nil];
            [SZNearByCollectStoreRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:CANCEL_SUBJECT_ON_COLLECT_STORE_REQUEST
                                                onRequestStart:^(ITTBaseDataRequest *request){
                                                    _isCollectFinished = NO;
                                                } onRequestFinished:^(ITTBaseDataRequest *request){
                                                    if (request.isSuccess) {
                                                        if (strongSelf.act==1) {
                                                            [PROMPT_VIEW showMessage:@"收藏成功"];
                                                            strongSelf.collectFlag = kFlagIsCollect;
                                                            strongSelf.act = -1;
                                                        }else{
                                                            [PROMPT_VIEW showMessage:@"取消收藏成功"];
                                                            strongSelf.collectFlag = kFlagIsNotCollect;
                                                            strongSelf.act = 1;
                                                        }
                                                        UIImage *collectBgImage = _collectFlag==kFlagIsCollect?[UIImage imageNamed:@"SZ_NEARBY_COLLECTED.png"]:[UIImage imageNamed:@"SZ_NearBy_Collect_Normal.png"];
                                                        [self.collectionBtn setBackgroundImage:collectBgImage forState:UIControlStateNormal];
                                                        strongSelf.isCollectFinished = YES;
                                                    }
                                                } onRequestCanceled:^(ITTBaseDataRequest *request){
                                                    _isCollectFinished = YES;
                                                } onRequestFailed:^(ITTBaseDataRequest *request){
                                                    _isCollectFinished = YES;
                                                }];
        }];
        
    }
}

- (IBAction)handleTakePhoneBtnClick:(id)sender {
    if (!IS_STRING_EMPTY([self.detailModel.store tel])) {
        [MobClick event:UMMerchantDetailCallPhone];
        [self takePhoneCall:[[self.detailModel.store tel] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    }
}
@end
