//
//  SZMyHistoryViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMyHistoryViewController.h"
#import "SZActivityMerchantCell.h"
#import "SZPreferentialCell.h"
#import "SZUserHistoryRequest.h"
#import "SZActivityMerchantModel.h"
#import "SZCouponModel.h"
#import "ITTPullTableView.h"

@interface SZMyHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,ITTPullTableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UIView *merchantView;
@property (weak, nonatomic) IBOutlet UIView *preferentialView;
@property (weak, nonatomic) IBOutlet UIButton *merchantButton;
@property (weak, nonatomic) IBOutlet UIButton *preferentialButton;
@property (weak, nonatomic) IBOutlet ITTPullTableView *tableView;
@property (strong, nonatomic) NSMutableArray *merchantArray;
@property (strong, nonatomic) NSMutableArray *preferentialArray;
@property (assign, nonatomic) BOOL ifMerchant;
@property (assign, nonatomic) int currentMerchantPage;
@property (assign, nonatomic) int currentPreferPage;
@property (assign, nonatomic) BOOL isLoading;
@property (weak, nonatomic) IBOutlet UILabel *noMerchantDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *noCouponDataLabel;

- (IBAction)onMerchantButtonClicked:(id)sender;
- (IBAction)onPreferentialButtonClicked:(id)sender;

@end

@implementation SZMyHistoryViewController

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
    [self setTitle:@"最近浏览"];
    [self hiddenLineView];
    _ifMerchant = YES;
    _merchantArray = [NSMutableArray array];
    _preferentialArray = [NSMutableArray array];
    [_tableView setRefreshViewHidden:YES];
    if (IS_IOS_7) {
        _tableView.contentOffset = CGPointMake(0,20);
        _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
    [self beginUserHistoryRequest];
}

- (void)beginUserHistoryRequest
{
    __weak typeof(self) weakSelf = self;
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf.isLoading){
            strongSelf.isLoading = YES;
            NSString *type;
            NSString *page;
            BOOL firstLoad = NO;
            if(strongSelf.ifMerchant){
                type = @"2";
                strongSelf.currentMerchantPage++;
                page = [NSString stringWithFormat:@"%d",strongSelf.currentMerchantPage];
                if(strongSelf.currentMerchantPage == 1){
                    firstLoad = YES;
                }
            }
            else{
                type = @"1";
                strongSelf.currentPreferPage++;
                page = [NSString stringWithFormat:@"%d",strongSelf.currentPreferPage];
                if(strongSelf.currentPreferPage == 1){
                    firstLoad = YES;
                }
            }
            NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:SZINDEX_USER_LASTVIEWS_METHOD forKey:PARAMS_METHOD_KEY];
            [paramDict setObject:userId forKey:PARAMS_USER_ID];
            [paramDict setObject:@"10" forKey:@"pagesize"];
            [paramDict setObject:page forKey:@"curpage"];
            [paramDict setObject:type forKey:@"type"]; //1 优惠 2 商铺
            NSLog(@"paramDict is %@",paramDict);
            [SZUserHistoryRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                NSLog(@"start loading");
                if(firstLoad){
                    [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
                }
            } onRequestFinished:^(ITTBaseDataRequest *request) {
                strongSelf.isLoading = NO;
                [strongSelf loadMoreDataDone];
                if (request.isSuccess) {
                    NSArray *goods_list = [request.handleredResult objectForKey:@"goods_list"];
                    NSArray *store_list = [request.handleredResult objectForKey:@"store_list"];
                    NSString *totalpage = [request.handleredResult objectForKey:@"totalpage"];
                    NSString *totalnum = [request.handleredResult objectForKey:@"totalnum"];
                    if(strongSelf.ifMerchant){
                        if(store_list && [store_list isKindOfClass:[NSArray class]]){
                            NSLog(@"store_list is %@,totalpage is %@,totalnum is %@",store_list,totalpage,totalnum);
                            [strongSelf.merchantArray addObjectsFromArray:store_list];
                        }
                    }
                    else{
                        if(goods_list && [goods_list isKindOfClass:[NSArray class]]){
                            NSLog(@"goods_list is %@,totalpage is %@,totalnum is %@",goods_list,totalpage,totalnum);
                            [strongSelf.preferentialArray addObjectsFromArray:goods_list];
                        }
                    }
                    [strongSelf.tableView reloadData];
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
                strongSelf.isLoading = NO;
                [strongSelf loadMoreDataDone];
            }];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_ifMerchant){
        _noCouponDataLabel.hidden = YES;
        int count = [_merchantArray count];
        if(count == 0){
            _noMerchantDataLabel.hidden = NO;
        }
        else{
            _noMerchantDataLabel.hidden = YES;
        }
        return count;
    }
    else{
        _noMerchantDataLabel.hidden = YES;
        int count = [_preferentialArray count];
        if(count == 0){
            _noCouponDataLabel.hidden = NO;
        }
        else{
            _noCouponDataLabel.hidden = YES;
        }
        return count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_ifMerchant){
        return 100;
    }
    else{
        return 95;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_ifMerchant){
        static NSString *cellIdentifier = @"SZActivityMerchantCell";
        SZActivityMerchantCell *cell = (SZActivityMerchantCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            cell = [SZActivityMerchantCell cellFromNib];
            cell.ifNearby = YES;
        }
        [cell getDataSourceFromModel:[_merchantArray objectAtIndex:indexPath.row]];
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"SZPreferentialCell";
        SZPreferentialCell *cell = (SZPreferentialCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            cell = [SZPreferentialCell cellFromNib];
        }
        cell.fromHistory = YES;
        [cell getDataSourceFromModel:[_preferentialArray objectAtIndex:indexPath.row]];
        return cell;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMerchantButtonClicked:(id)sender
{
    _merchantButton.enabled = NO;
    _preferentialButton.enabled = YES;
    _merchantView.hidden = NO;
    _preferentialView.hidden = YES;
    _ifMerchant = YES;
    if([_merchantArray count]==0){
        [self beginUserHistoryRequest];
    }
    else{
        [_tableView reloadData];
    }
}

- (IBAction)onPreferentialButtonClicked:(id)sender
{
    _merchantButton.enabled = YES;
    _preferentialButton.enabled = NO;
    _merchantView.hidden = YES;
    _preferentialView.hidden = NO;
    _ifMerchant = NO;
    if([_preferentialArray count]==0){
        [self beginUserHistoryRequest];
    }
    else{
       [_tableView reloadData];
    }
}

- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView *)pullTableView
{
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView *)pullTableView
{
    [self beginUserHistoryRequest];
}

- (void)loadMoreDataDone
{
    _tableView.pullTableIsLoadingMore = NO;
    [_tableView setLoadMoreViewHidden:NO];
}

@end










