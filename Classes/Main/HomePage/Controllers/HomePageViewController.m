//
//  HomePageViewController.m
//  iTotemFramework
//
//  Created by Grant on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "HomePageViewController.h"
#import "SZLoginViewController.h"
#import "ITTImageSliderView.h"
#import "ITTPageView.h"
#import "SZPreferentialCell.h"
#import "SZHomeDetailRequest.h"
#import "SZActivityViewController.h"
#import "SZPreferentialModel.h"
#import "SZPreferentialCell.h"
#import "SZNearByViewController.h"
#import "SZLoginViewController.h"
#import "SZActivityModel.h"
#import "AppDelegate.h"
#import "SZAllPreferentialViewController.h"
#import "KeyboardTextView.h"
#import "SZLocationSuggestRequest.h"

#import "ITTRefreshTableHeaderView.h"
#import "SZSitePickView.h"

#import "ITTNetworkTrafficManager.h"

@interface HomePageViewController ()
<
 ITTImageSliderViewDelegate
,ITTRefreshTableHeaderDelegate
,UIScrollViewDelegate
,UIAlertViewDelegate
>
@property (nonatomic, weak) IBOutlet ITTImageSliderView *imageSliderView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *hotDiscountLabel;
@property (nonatomic, weak) IBOutlet UIButton *showMoreDiscountBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (nonatomic, strong) ITTRefreshTableHeaderView *refreshView;

@property (nonatomic, strong) ITTPageView *pageView;
@property (nonatomic, strong) NSMutableArray *preferentialCellArray;
@property (nonatomic, strong) NSArray *activityArray;

@property (nonatomic, weak) IBOutlet UIButton *categoryBtn1;
@property (nonatomic, weak) IBOutlet UIButton *categoryBtn2;
@property (nonatomic, weak) IBOutlet UIButton *categoryBtn3;
@property (nonatomic, weak) IBOutlet UIButton *categoryBtn4;
@property (weak, nonatomic) IBOutlet UIButton *cityPickerBtn;

@property (nonatomic, strong) UIWindow *sitePickWindow;
@property (nonatomic, strong) SZSitePickView *sitePickView;

@property (nonatomic,readwrite) BOOL pullTableIsRefreshing;
@property (nonatomic, strong) UIAlertView *networkAlertView;
@property (nonatomic, strong) UIAlertView *alertView1;//1.2.2
@property (nonatomic, strong) UIAlertView *alertView2;//2.2.1
@property (nonatomic, strong) UIWebView *tempWebView;
@property (nonatomic) BOOL needRelocate;
@end

@implementation HomePageViewController

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
    // Do any additional setup after loading the view from its nib.
    NSArray *categoryBtnArray = @[_categoryBtn1,_categoryBtn2,_categoryBtn3,_categoryBtn4];
    for (UIButton *btn in categoryBtnArray) {
        btn.layer.borderColor = [UIColor colorWithRed:220.f/255.f green:220.f/255.f blue:220.f/255.f alpha:1.f].CGColor;
        btn.layer.borderWidth = 1.f;
        btn.layer.cornerRadius = 4.f;
    }
    _preferentialCellArray = [NSMutableArray array];
    _imageSliderView.delegate = self;
    _imageSliderView.backgroundColor = [UIColor clearColor];
    _imageSliderView.placeHolderImageUrl = @"SZ_HOME_ACTI_DEF.png";
    [_showMoreDiscountBtn setupBorderWidth:UIEdgeInsetsMake(0, 0, 1, 0) allColor:[UIColor colorWithRed:231.f/255.f green:231.f/255.f blue:231.f/255.f alpha:1.f]];
    [_cityPickerBtn setTitle:[[UserManager sharedUserManager] city] forState:(UIControlStateNormal)];
    [self setupRefrashHeader];
    if (![self detectNetworkType]) {
        return;
    }
    if ([[UserManager sharedUserManager] city] != nil &&
        !_needRelocate)
    {
        [self startDetailRequst];
        return;
    }
    [self startRefrash];
}

- (void)startRefrash
{
    //    首页规则：
    //    1.初次进入首页时
    //    1.1 如果是本地用户，会直接默认对应的城市，用户可以通过页面顶部进行城市切换
    //    1.2 如果是异地用户，分为两种情况
    //    1.2.1 唐山、宿州两个城市内的异地，会出现提示“系统定位您在唐山（宿州），是否切换？”，如果选择了切换，则页面切换成对应的另一个城市：宿州（唐山）；如果选择了取消，则页面默认当时所在的城市；
    //    1.2.2 唐山、宿州两个城市外的异地，出现提示“您所在的城市***尚未开通，请您从已开通的城市中选择！”，确定后显示“选择城市”的弹出层，让用户选择，弹出层增加关闭按钮。
    //
    //
    //    2.再次进入首页时，默认显示之前记录的城市
    //    2.1. 如果是本地用户，直接默认之前记录的城市，没有提示信息
    //    2.2. 如果是异地用户，分为两种情况
    //    2.2.1 唐山、宿州两个城市内的异地，默认之前记录的城市，但是会提示“系统定位您在唐山（宿州），是否切换？”
    //    2.2.2 唐山、宿州两个城市外的异地，默认之前记录的城市
    //    城市有“唐山”“宿州”两个城市。
    [[UserManager sharedUserManager] getCurrentLocationWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, BOOL isSuccess) {
        if (isSuccess) {
            NSDictionary *params = @{PARAMS_METHOD_KEY: SZINDEX_LOCATION_METHORD,
                                     @"lng":[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude],
                                     @"lat":[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude],
                                     PARAMS_PLAT: SZIOSPLATFORM_NUM};
            [SZLocationSuggestRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil
                                             onRequestStart:^(ITTBaseDataRequest *request) {
                                                 if (!self.pullTableIsRefreshing) {
                                                    [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
                                                 }

                                             }
                                          onRequestFinished:^(ITTBaseDataRequest *request) {
                                              if (request.isSuccess) {
                                                  NSString *cityCode = [[UserManager sharedUserManager] cityCode];
                                                  NSString *suggestCityCode = request.handleredResult[NETDATA];
                                                  [[UserManager sharedUserManager]setSuggestCityCode:suggestCityCode];
                                                  if (cityCode.length == 0)//1.初次进入首页时
                                                  {
                                                      [[UserManager sharedUserManager] setCityCode:suggestCityCode];
                                                      if (cityCode.length == 0) {//1.2.2唐山、宿州两个城市外的异地
                                                          self.alertView1 = [[UIAlertView alloc] initWithTitle:nil message:@"您所在的城市尚未开通，请您从已开通的城市中选择！"  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                          [self.alertView1 show];
                                                      }
                                                      else //1.1 如果是本地用户
                                                      {
                                                          [_cityPickerBtn setTitle:[[UserManager sharedUserManager] city] forState:(UIControlStateNormal)];
                                                          [self startDetailRequst];
                                                      }
                                                  }else//2.再次进入首页时
                                                  {
                                                      if ([cityCode isEqualToString:suggestCityCode]) {//2.1 如果是本地用户
                                                          
                                                      }else if([suggestCityCode isEqualToString:@"other"])//2.2.1唐山、宿州两个城市外的异地
                                                      {
                                                          [self startDetailRequst];
                                                          
                                                      }else//2.2.2 唐山、宿州两个城市内的异地
                                                      {
                                                          NSString *cityName = [[UserManager sharedUserManager] getCityNameWithCode:suggestCityCode];
                                                          NSString *msg = [NSString stringWithFormat:@"系统定位您在 %@，是否切换？",cityName];
                                                          self.alertView2 = [[UIAlertView alloc] initWithTitle:nil message:msg  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"切换", nil];
                                                          [self.alertView2 show];
                                                      }
                                                  }
                                              }
                                              //不用处理 isSuccess 为 NO 的情况
                                          } onRequestCanceled:^(ITTBaseDataRequest *request) {
                                              [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
                                              self.pullTableIsRefreshing = NO;
                                          } onRequestFailed:^(ITTBaseDataRequest *request) {
                                              [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
                                              self.pullTableIsRefreshing = NO;
                                          }];
        }else
        {
            [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
        }
        
    }];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    return;
    if ([[UserManager sharedUserManager] isFirstOpenForViewControllerClass:[self class]]) {
        UIImageView *guideImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        if (!IS_IOS_7) {
            guideImageView.height += 65.f;
        }
        UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideImageDidClicked:)];
        [guideImageView addGestureRecognizer:tapGestureR];
        guideImageView.tag = 0;
        guideImageView.userInteractionEnabled = YES;
        [self guideImageDidClicked:tapGestureR];
        UIWindow *myWindow = [[AppDelegate GetAppDelegate] window];
        [myWindow addSubview:guideImageView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
}

- (BOOL)detectNetworkType
{
    if ([[[ITTNetworkTrafficManager sharedManager] networkType] isEqualToString:@"unavailable"]) {
//        self.networkAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"关闭飞行模式或者使用无线局域网来访问数据"  delegate:self cancelButtonTitle:@"设置" otherButtonTitles:@"好", nil];
        self.networkAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"关闭飞行模式或者使用无线局域网来访问数据"  delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [self.networkAlertView show];
        return NO;
    }else
    {
        return YES;
    }
}

#pragma mark - Network Request
- (void)startDetailRequst
{
    __weak typeof(self) weakSelf = self;
    [[UserManager sharedUserManager] getCurrentLocationWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, BOOL isSuccess) {
        if (isSuccess) {
            NSDictionary *params = @{PARAMS_METHOD_KEY: SZINDEX_DETAILIST_METHORD,
                                     @"lng":[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude],
                                     @"lat":[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude],
                                     PARAMS_PLAT: SZIOSPLATFORM_NUM};
            

            [SZHomeDetailRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                if (!weakSelf.pullTableIsRefreshing) {
                    [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
                }
            } onRequestFinished:^(ITTBaseDataRequest *request) {
                if (weakSelf && request.isSuccess) {
                    weakSelf.pullTableIsRefreshing = NO;
                    typeof(weakSelf) strongSelf = weakSelf;
                    
                    strongSelf.activityArray = request.handleredResult[NETDATA][SZHomeDetailRequestActivityList];
                    NSMutableArray *urlArray = [NSMutableArray array];
                    for (SZActivityModel *activitModel in _activityArray) {
                        NSString *url = [NSString stringWithFormat:@"%@",activitModel.pic_url];

                        [urlArray addObject:url];
                    }
                    [strongSelf setupSliderWithUrlArray:urlArray];
                    [strongSelf setupHotDiscountWithArray:request.handleredResult[NETDATA][SZHomeDetailRequestGoodsList]];
                }
                [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
                
                //不用处理 isSuccess 为 NO 的情况
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
                [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
                self.pullTableIsRefreshing = NO;
            } onRequestFailed:^(ITTBaseDataRequest *request) {
                [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
                self.pullTableIsRefreshing = NO;
            }];
        }else
        {
            self.pullTableIsRefreshing = NO;
        }
    }];
}

#pragma mark - setup UI
- (void)setupSliderWithUrlArray:(NSArray *)urlArray
{
    [_imageSliderView setImageUrls:urlArray];
    [_pageView removeFromSuperview];
    if (urlArray.count>1) {
        self.pageView = [[ITTPageView alloc] initWithPageNum:[urlArray count]];
        _pageView.top = _imageSliderView.bottom - 17;
        _pageView.left = (CGRectGetWidth(self.view.bounds) - CGRectGetWidth(_pageView.frame)) / 2;
        [_imageSliderView.superview addSubview:_pageView];
        [_imageSliderView startAutoScrollWithDuration:3];
    }
    
}

- (void)setupHotDiscountWithArray:(NSArray *)array
{
    [_preferentialCellArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.activityArray.count == 0) {
        _hotDiscountLabel.top = _imageSliderView.top;
        _imageSliderView.hidden = YES;
    }else
    {
        _imageSliderView.hidden = NO;
        _hotDiscountLabel.top = _imageSliderView.bottom+13;
    }
    CGFloat curTop = _hotDiscountLabel.bottom;
    for (SZCouponModel *discountModel in array) {
        SZPreferentialCell *cell = [SZPreferentialCell cellFromNib];
        [cell getDataSourceFromModel:discountModel];
        [_preferentialCellArray addObject:cell];
        cell.top = curTop,curTop+=cell.height;
        [_hotDiscountLabel.superview addSubview:cell];
        
    }
    _showMoreDiscountBtn.top = curTop+9;
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _showMoreDiscountBtn.bottom+60);
}

#pragma mark - ITTImageSliderViewDelegate
- (void)imageClickedWithIndex:(int)imageIndex
{
    ITTDINFO(@"image clicked at index:%d",imageIndex);
    SZActivityModel *activityModel = [self.activityArray objectAtIndex:imageIndex];
    SZActivityViewController *activityVC = [[SZActivityViewController alloc] initWithNibName:@"SZActivityViewController" bundle:nil];
    NSString *userId = [[UserManager sharedUserManager] userId];
    [activityVC setupUrlWithACCId:activityModel.aac_id userId:userId];
    [self pushMasterViewController:activityVC];
    [MobClick event:UMHomePageFocusPicClick];
    [MobClick event:UMHomePageActivityClick];
}

- (void)imageDidScrollWithIndex:(int)imageIndex
{
    [_pageView setCurrentPage:imageIndex];
}
- (IBAction)searchBtnDidClicked:(id)sender {
    [self hideKeyboard:sender];
    if (_searchField.text.length != 0) {
        SZNearByViewController *categoryVC = [[SZNearByViewController alloc] initWithNibName:@"SZNearByViewController" bundle:nil];
        categoryVC.pageFrom = SZNearByPageFromSearch;
        categoryVC.keyWord = _searchField.text;
        _searchField.text = @"";
        [self pushMasterViewController:categoryVC];
        [MobClick event:UMHomePageSearchBarSearch];
    }
}

#pragma mark - Actions
- (IBAction)categoryFoodBtnDidClicked:(id)sender {
    [MobClick event:UMHomePageFoodClick];
    [self makeNearByViewControllerWithFrom:SZNearByPageFromFood];
}
- (IBAction)categoryPlayBtnDidClicked:(id)sender {
    [MobClick event:UMHomePagePlayClick];
    [self makeNearByViewControllerWithFrom:SZNearByPageFromPlay];
}
- (IBAction)categoryLifeBtnDidClicked:(id)sender {
    [MobClick event:UMHomePageLifeClick];
    [self makeNearByViewControllerWithFrom:SZNearByPageFromLife];
}
- (IBAction)categoryMoreBtnDidClicked:(id)sender {
    [MobClick event:UMHomePageMoreClick];
    [self makeNearByViewControllerWithFrom:SZNearByPageFromMore];
}
- (IBAction)showMoreDiscountBtnDidClicked:(id)sender {
    
    SZAllPreferentialViewController *discountVC = [[SZAllPreferentialViewController alloc] initWithNibName:@"SZAllPreferentialViewController" bundle:nil];
    discountVC.isFromHomePage = YES;
    [self pushMasterViewController:discountVC];
}
- (IBAction)cityPickerBtnDidClicked:(id)sender {
    [self showSitePickWindow];
}

- (void)guideImageDidClicked:(UITapGestureRecognizer *)tapGestureR
{
    UIImageView *guideImageView = (UIImageView *)tapGestureR.view;
    guideImageView.tag++;
    switch (guideImageView.tag) {
        case 1:
            guideImageView.image = [UIImage imageNamed:@"SZ_FC_HOME"];
            break;
        default:
        {
            [UIView animateWithDuration:0.3 animations:^{
                guideImageView.alpha = 0.f;
            } completion:^(BOOL finished) {
                [guideImageView removeFromSuperview];
            }];
        }
            break;
    }
}

#pragma mark - private Function
- (void)makeNearByViewControllerWithFrom:(SZNearByPageFrom)pageFrom
{
    SZNearByViewController *categoryVC = [[SZNearByViewController alloc] initWithNibName:@"SZNearByViewController" bundle:nil];
    categoryVC.pageFrom = pageFrom;
    [self pushMasterViewController:categoryVC];
}

#pragma mark - 下拉刷新
- (void)setupRefrashHeader
{
    self.scrollView.delegate = self;
    /* Refresh View */
    _refreshView = [[ITTRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.scrollView.bounds.size.height, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
    _refreshView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _refreshView.delegate = self;
    [self.scrollView addSubview:_refreshView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    [_refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_refreshView egoRefreshScrollViewWillBeginDragging:scrollView];
}

/*
 *set Load more view hidden
 */

- (void)setRefreshViewHidden:(BOOL)isHidden
{
    if (isHidden)
        [_refreshView removeFromSuperview];
    else
        [self.scrollView addSubview:_refreshView];
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(ITTRefreshTableHeaderView*)view
{
    self.pullTableIsRefreshing = YES;
    [_refreshView startAnimatingWithScrollView:self.scrollView];
    [self startRefrash];
    
}

- (void)showSitePickWindow
{
    if (_sitePickWindow == nil) {
        self.sitePickWindow = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
        CALayer *hudLayer = [CALayer layer];
        hudLayer.frame = CGRectMake(0, 0, _sitePickWindow.width, _sitePickWindow.height);
        hudLayer.backgroundColor = [UIColor blackColor].CGColor;
        hudLayer.opacity = 0.6;
        
        _sitePickWindow.backgroundColor = [UIColor clearColor];
        _sitePickWindow.windowLevel =UIWindowLevelNormal;
        _sitePickWindow.alpha =1.f;
        _sitePickWindow.hidden =NO;
        [_sitePickWindow.layer addSublayer:hudLayer];
        self.sitePickView = [ITTXibViewUtils loadViewFromXibNamed:@"SZSitePickView"];
        [_sitePickWindow addSubview:_sitePickView];
    }
    [_sitePickWindow makeKeyAndVisible];
    [_sitePickView showSitePickViewWithFinishBlock:^(NSString *site) {
        AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
        [[appDelegate window] makeKeyAndVisible];

        if (![[_cityPickerBtn titleForState:UIControlStateNormal] isEqualToString:site]) {
            [_cityPickerBtn setTitle:site forState:UIControlStateNormal];
            NSString *apnsId = [[UserManager sharedUserManager] apnsId];
            [[AppDelegate GetAppDelegate] postDeviceTokenAndUserInfo:apnsId isOpen:[[UserManager sharedUserManager] needNotificaionMsg]];
            [appDelegate resetTabs];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && alertView == self.alertView1) {
         [self showSitePickWindow];
    }
    else if(buttonIndex == 1 && alertView == self.alertView2) {
        [self showSitePickWindow];
    }else if(buttonIndex == 0 && alertView == self.networkAlertView) {
//        int (*openApp)(CFStringRef, Boolean);
//        void *hndl = dlopen("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices");
//        openApp = (int(*)(CFStringRef, Boolean)) dlsym(hndl, "SBSLaunchApplicationWithIdentifier");
//        openApp(CFSTR("com.apple.Preferences"), FALSE);
//        dlclose(hndl);
//        self.tempWebView = [[UIWebView alloc] init];
//        [self.tempWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"prefs:\\"]]];
    }
}
#pragma mark - public
- (void)needLocationSuggest:(BOOL)need
{
    self.needRelocate = need;
}
@end
