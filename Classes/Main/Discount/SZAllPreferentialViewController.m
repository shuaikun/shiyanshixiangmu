//
//  SZAllPreferentialViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZAllPreferentialViewController.h"
#import "SZPreferentialCell.h"
#import "SZCouponDetailViewController.h"
#import "SZMembershipCardDetailViewController.h"
#import "SZCustomPickerView.h"
#import "ITTPullTableView.h"
#import "SZGoodsSearchDataListRequest.h"
#import "SZGoodsDetailRequest.h"
#import "SZPreferentialModel.h"
#import "SZStoreModel.h"
#import "SZFilterDataRequest.h"
#import "AppDelegate.h"

@interface SZAllPreferentialViewController ()<UITableViewDelegate,UITableViewDataSource,SZCustomPickerViewDelegate,ITTPullTableViewDelegate>

@property (weak, nonatomic) IBOutlet ITTPullTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) SZCustomPickerView *customPickerView;
@property (strong, nonatomic) NSMutableArray *preferentialArray;
@property (strong, nonatomic) NSString *cate;
@property (strong, nonatomic) NSString *distance_range;
@property (strong, nonatomic) NSString *area;
@property (strong, nonatomic) NSString *sort;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL notShowLoading;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

@end

@implementation SZAllPreferentialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(_customPickerView){
        [_customPickerView hide];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
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
    }*/
    [self.tableView reloadData];
}

- (void)guideImageDidClicked:(UITapGestureRecognizer *)tapGestureR
{
    UIImageView *guideImageView = (UIImageView *)tapGestureR.view;
    guideImageView.tag++;
    switch (guideImageView.tag) {
        case 1:
            guideImageView.image = [UIImage imageNamed:@"SZ_FC_YH"];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *cityCode = [[UserManager sharedUserManager]suggestCityCode];
    if([cityCode isEqualToString:@"sz"]||[cityCode isEqualToString:@"ts"]){
        _distance_range = @"1000";
    }else{
        _distance_range =@"0";
    }
    
    if(_isFromHomePage){
        [self showBackButton:YES];
    }
    else{
        _tableView.height-=45;
        [self showBackButton:NO];
    }
    if(IS_IOS_7){
    }
    else{
        _tableView.height+=45;
    }
    [self addFilterView];
    [_tableView setLoadMoreViewHidden:YES];
    _preferentialArray = [NSMutableArray array];
    [self beginGoodsSearchDataListRequest];
    [self beginFilterDataRequest];
    
}

- (void)showBackButton:(BOOL)needShow
{
    _backBtn.hidden = !needShow;
}

- (void)beginFilterDataRequest
{
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:@"app.index.confdata" forKey:PARAMS_METHOD_KEY];
    [SZFilterDataRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        NSLog(@"start loading");
        [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        if (request.isSuccess) {
            //refresh
        }
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
    } onRequestFailed:^(ITTBaseDataRequest *request) {
    }];
}

- (void)beginGoodsSearchDataListRequest
{
    [[UserManager sharedUserManager] getCurrentLocationWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, BOOL isSuccess) {
        if(isSuccess){
            if(!_isLoading){
                _isLoading = YES;
                _currentPage++;
                NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
                [paramDict setObject:SZINDEX_GOODSSEARCH_DATALIST_METHOD forKey:PARAMS_METHOD_KEY];
                [paramDict setObject:[NSString stringWithFormat:@"%d",_currentPage] forKey:@"curpage"];
                [paramDict setObject:@"6" forKey:@"pagesize"];
                [paramDict setObject:@"1" forKey:@"plat"];
                [paramDict setObject:[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude] forKey:@"lng"];
                [paramDict setObject:[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude] forKey:@"lat"];
                if(IS_STRING_NOT_EMPTY(_cate)){
                    [paramDict setObject:_cate forKey:@"cate"];
                }
                if(IS_STRING_NOT_EMPTY(_distance_range)){
                    [paramDict setObject:_distance_range forKey:@"distance_range"];
                }
                if(IS_STRING_NOT_EMPTY(_area)){
                    [paramDict setObject:_area forKey:@"area"];
                }
                if(IS_STRING_NOT_EMPTY(_sort)){
                    [paramDict setObject:_sort forKey:@"sort"];
                }
                NSLog(@"paramDict is %@",paramDict);
                [SZGoodsSearchDataListRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                    NSLog(@"start loading");
                    if(!_notShowLoading){
                        [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
                    }
                } onRequestFinished:^(ITTBaseDataRequest *request) {
                    _isLoading = NO;
                    [self refreshDataDone];
                    [self loadMoreDataDone];
                    if (request.isSuccess) {
                        NSArray *goods_list = [request.handleredResult objectForKey:@"goods_list"];
                        NSString *totlapage = [request.handleredResult objectForKey:@"totalpage"];
                        NSString *totalnum = [request.handleredResult objectForKey:@"totalnum"];
                        if(goods_list && [goods_list isKindOfClass:[NSArray class]]){
                            NSLog(@"goods_list is %@,totlapage is %@,totalnum is %@",goods_list,totlapage,totalnum);
                            //refresh
                            if(_currentPage == 1){
                                [_preferentialArray removeAllObjects];
                            }
                            [_preferentialArray addObjectsFromArray:goods_list];
                            if(_currentPage == [totlapage intValue]){
                                [_tableView setLoadMoreViewHidden:YES];
                            }else
                            {
                                [_tableView setLoadMoreViewHidden:NO];
                            }
                            [_tableView reloadData];
                        }else
                        {
                            if(_currentPage == 1){
                                _currentPage = 0;
                                [_preferentialArray removeAllObjects];
                                [_tableView setLoadMoreViewHidden:YES];
                                [_tableView reloadData];
                            }
                        }
                    }
                } onRequestCanceled:^(ITTBaseDataRequest *request) {
                } onRequestFailed:^(ITTBaseDataRequest *request) {
                    _isLoading = NO;
                    [self refreshDataDone];
                    [self loadMoreDataDone];
                }];
            }
        }
        else
        {
            [self refreshDataDone];
            [self loadMoreDataDone];
        }
    }];
}

- (void)addFilterView
{
    CGRect frame = self.filterView.frame;
    _filterView = [SZFilterView loadFromXib];
    _filterView.frame = frame;
    _filterView.delegate = self;
    NSString *cityCode = [[UserManager sharedUserManager]suggestCityCode];
    if ([cityCode isEqualToString:@"ts"]||[cityCode isEqualToString:@"sz"]) {
        [_filterView setFilterConditionTitle:@"1000米" Index:202];
        _distance_range = @"1000";
    }else {
        [_filterView setFilterConditionTitle:@"全部距离" Index:202];
        _distance_range = @"0";
    }
    [self.view addSubview:self.filterView];
}

- (void)filterViewOneConditionButtonTapped:(int)filterConditionIndex
{
    if(!_customPickerView){
        _customPickerView = [SZCustomPickerView loadFromXib];
        _customPickerView.delegate = self;
    }
    NSString *cityCode = [[UserManager sharedUserManager]suggestCityCode];
    if ([cityCode isEqualToString:@"ts"]||[cityCode isEqualToString:@"sz"]) {
        [_customPickerView updateDataWithCondition:filterConditionIndex outPlace:NO];
    }else {
        [_customPickerView updateDataWithCondition:filterConditionIndex outPlace:YES];
    }
}

- (void)pickViewSelectedString:(NSString *)string Condition:(int)filterCondition SearchCondition:(int)searchCondition SearchId:(NSString *)searchId
{
    NSLog(@"string is %@,searchId is %@",string,searchId);
    [_filterView setFilterConditionTitle:string Index:filterCondition];
    // c r a s
    NSDictionary *attribute;
    switch (searchCondition) {
        case kTagSearchConditionCate:
        {
            _cate = searchId;
            attribute = @{@"cate":@"分类"};
        }
        break;
        case kTagSearchConditionRange:
        {
            attribute = @{@"distance":@"距离"};
            _distance_range = searchId;
            _area = @"";
        }
        break;
        case kTagSearchConditionArea:
        {
            attribute = @{@"area":@"商圈"};
            _distance_range = @"";
            _area = searchId;
        }
        break;
        case kTagSearchConditionSort:
        {
            _sort = searchId;
            attribute = @{@"sort":@"排序"};
        }
        break;
        default:
        {
            
        }
        break;
    }
    [MobClick event:UMDiscountFilter attributes:attribute];
    //update data here
    _currentPage = 0;
    [_tableView setLoadMoreViewHidden:YES];
    [self beginGoodsSearchDataListRequest];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [_preferentialArray count];
    if(count == 0){
        _noDataLabel.hidden = NO;
    }
    else{
        _noDataLabel.hidden = YES;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SZPreferentialCell";
    SZPreferentialCell *cell = (SZPreferentialCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [SZPreferentialCell cellFromNib];
    }
    cell.index = indexPath.row;
    [cell getDataSourceFromModel:[_preferentialArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView *)pullTableView
{
    _currentPage = 0;
    _notShowLoading = YES;
    [self beginGoodsSearchDataListRequest];
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView *)pullTableView
{
    _notShowLoading = YES;
    [self beginGoodsSearchDataListRequest];
}

- (void)refreshDataDone
{
    _tableView.pullTableIsRefreshing = NO;
    [_tableView setRefreshViewHidden:NO];
}

- (void)loadMoreDataDone
{
    _tableView.pullTableIsLoadingMore = NO;
     [_tableView setLoadMoreViewHidden:NO];
}

@end









