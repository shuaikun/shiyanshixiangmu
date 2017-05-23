//
//  SZMyCouponViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMyCouponViewController.h"
#import "SZCouponCell.h"
#import "SZUserCouponRequest.h"
#import "SZCouponModel.h"
#import "SZGoodsNameModel.h"
#import "ITTPullTableView.h"

@interface SZMyCouponViewController ()<UITableViewDataSource,UITableViewDelegate,ITTPullTableViewDelegate,SZCouponCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UIView *validView;
@property (weak, nonatomic) IBOutlet UIView *unValidView;
@property (weak, nonatomic) IBOutlet UIButton *validButton;
@property (weak, nonatomic) IBOutlet UIButton *unValidButton;
@property (weak, nonatomic) IBOutlet ITTPullTableView *tableView;
@property (strong, nonatomic) NSMutableArray *validArray;
@property (strong, nonatomic) NSMutableArray *unValidArray;
@property (assign, nonatomic) BOOL ifValid;
@property (assign, nonatomic) int currentValidPage;
@property (assign, nonatomic) int currentUnValidPage;
@property (assign, nonatomic) BOOL isLoading;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

- (IBAction)onValidButtonClicked:(id)sender;
- (IBAction)onUnValidButtonClicked:(id)sender;

@end

@implementation SZMyCouponViewController

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
    [self hiddenLineView];
    [self setTitle:@"我的优惠券"];
    _ifValid = YES;
    _validArray = [NSMutableArray array];
    _unValidArray = [NSMutableArray array];
    [_tableView setRefreshViewHidden:YES];
    if (IS_IOS_7) {
        _tableView.contentOffset = CGPointMake(0,20);
        _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
    [self beginUserCouponRequest];
}

- (void)beginUserCouponRequest
{
    __weak typeof(self) weakSelf = self;
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf.isLoading){
            strongSelf.isLoading = YES;
            NSString *expired;
            NSString *page;
            BOOL firstLoad = NO;
            if(strongSelf.ifValid){
                strongSelf.currentValidPage++;
                expired = @"0";
                page = [NSString stringWithFormat:@"%d",strongSelf.currentValidPage];
                if(strongSelf.currentValidPage == 1){
                    firstLoad = YES;
                }
            }
            else{
                strongSelf.currentUnValidPage++;
                expired = @"1";
                page = [NSString stringWithFormat:@"%d",strongSelf.currentUnValidPage];
                if(strongSelf.currentUnValidPage == 1){
                    firstLoad = YES;
                }
            }
            NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:SZINDEX_USER_COUPON_METHOD forKey:PARAMS_METHOD_KEY];
            [paramDict setObject:userId forKey:PARAMS_USER_ID];
            [paramDict setObject:@"10" forKey:@"pagesize"];
            [paramDict setObject:page forKey:@"curpage"];
            [paramDict setObject:expired forKey:@"expired"]; //0 未过期 1 已过期
            NSLog(@"paramDict is %@",paramDict);
            [SZUserCouponRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                NSLog(@"start loading");
                if(firstLoad){
                    [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
                }
            } onRequestFinished:^(ITTBaseDataRequest *request) {
                strongSelf.isLoading = NO;
                [strongSelf loadMoreDataDone];
                if (request.isSuccess) {
                    NSArray *goods_list = [request.handleredResult objectForKey:@"goods_list"];
                    NSString *totalpage = [request.handleredResult objectForKey:@"totalpage"];
                    NSString *totalnum = [request.handleredResult objectForKey:@"totalnum"];
                    if(goods_list && [goods_list isKindOfClass:[NSArray class]]){
                        NSLog(@"goods_list is %@,totalpage is %@,totalnum is %@",goods_list,totalpage,totalnum);
                        //refresh
                        if(strongSelf.ifValid){
                            [strongSelf.validArray addObjectsFromArray:goods_list];
                        }
                        else{
                            [strongSelf.unValidArray addObjectsFromArray:goods_list];
                        }
                    }
                    [strongSelf.tableView reloadData];
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
                _isLoading = NO;
                [self loadMoreDataDone];
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onValidButtonClicked:(id)sender
{
    _noDataLabel.text = @"您还没有获取过优惠券";//may not be showned
    _validButton.enabled = NO;
    _unValidButton.enabled = YES;
    _validView.hidden = NO;
    _unValidView.hidden = YES;
    _ifValid = YES;
    if([_validArray count]==0){
        [self beginUserCouponRequest];
    }
    else{
        [_tableView reloadData];
    }
}

- (IBAction)onUnValidButtonClicked:(id)sender
{
    _noDataLabel.text = @"您没有过期的优惠券";//may not be showned
    _validButton.enabled = YES;
    _unValidButton.enabled = NO;
    _validView.hidden = YES;
    _unValidView.hidden = NO;
    _ifValid = NO;
    if([_unValidArray count]==0){
        [self beginUserCouponRequest];
    }
    else{
        [_tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_ifValid){
        int count = [_validArray count];
        if(count == 0){
            _noDataLabel.hidden = NO;
        }
        else{
            _noDataLabel.hidden = YES;
        }
        return count;
    }
    else{
        int count = [_unValidArray count];
        if(count == 0){
            _noDataLabel.hidden = NO;
        }
        else{
            _noDataLabel.hidden = YES;
        }
        return count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SZCouponCell";
    SZCouponCell *cell = (SZCouponCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [SZCouponCell cellFromNib];
    }
    if(_ifValid){
        [cell getDataSourceFromModel:[_validArray objectAtIndex:indexPath.row]];
    }
    else{
        [cell getDataSourceFromModel:[_unValidArray objectAtIndex:indexPath.row]];
    }
    cell.delegate = self;
    cell.ifValid = _ifValid;
    cell.index = indexPath.row;
    return cell;
}

- (void)couponCellFinishDeleteIndex:(int)index IfValid:(BOOL)ifValid
{
    if(_ifValid){
        [_validArray removeObjectAtIndex:index];
    }
    else{
        [_unValidArray removeObjectAtIndex:index];
    }
    [_tableView reloadData];
}

- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView *)pullTableView
{
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView *)pullTableView
{
    [self beginUserCouponRequest];
}

- (void)loadMoreDataDone
{
    _tableView.pullTableIsLoadingMore = NO;
    [_tableView setLoadMoreViewHidden:NO];
}

@end















