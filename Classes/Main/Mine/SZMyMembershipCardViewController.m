//
//  SZMyMembershipCardViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMyMembershipCardViewController.h"
#import "SZMembershipCardCell.h"
#import "SZUserCardRequest.h"
#import "SZMembershipCardModel.h"
#import "SZGoodsNameModel.h"
#import "ITTPullTableView.h"

@interface SZMyMembershipCardViewController ()<UITableViewDataSource,UITableViewDelegate,ITTPullTableViewDelegate,SZMembershipCardCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet ITTPullTableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) BOOL isLoading;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

@end

@implementation SZMyMembershipCardViewController

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
    [self setTitle:@"我的会员卡"];
    _dataArray = [NSMutableArray array];
    [_tableView setRefreshViewHidden:YES];
    if (IS_IOS_7) {
        _tableView.contentOffset = CGPointMake(0,20);
        _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
    [self beginUserCardsRequest];
}

- (void)beginUserCardsRequest
{
    __weak typeof(self) weakSelf = self;
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf.isLoading){
            strongSelf.isLoading = YES;
            strongSelf.currentPage++;
            NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:SZINDEX_USER_CARD_METHOD forKey:PARAMS_METHOD_KEY];
            [paramDict setObject:userId forKey:PARAMS_USER_ID];
            [paramDict setObject:[NSString stringWithFormat:@"%d",strongSelf.currentPage] forKey:@"curpage"];
            [paramDict setObject:@"10" forKey:@"pagesize"];
            NSLog(@"paramDict is %@",paramDict);
            [SZUserCardRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                NSLog(@"start loading");
                if(strongSelf.currentPage == 1){
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
                        [strongSelf.dataArray addObjectsFromArray:goods_list];
                        if(strongSelf.currentPage == [totalpage intValue]){
                            [strongSelf.tableView setLoadMoreViewHidden:YES];
                        }
                        [strongSelf.tableView reloadData];
                    }
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
                strongSelf.isLoading = NO;
                [strongSelf loadMoreDataDone];
            }];
        }

    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [_dataArray count];
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
    static NSString *cellIdentifier = @"SZMembershipCardCell";
    SZMembershipCardCell *cell = (SZMembershipCardCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [SZMembershipCardCell cellFromNib];
    }
    cell.delegate = self;
    cell.index = indexPath.row;
    [cell getDataSourceFromModel:[_dataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)membershipCardCellFinishDeleteIndex:(int)index
{
    [_dataArray removeObjectAtIndex:index];
    [_tableView reloadData];
}

- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView *)pullTableView
{
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView *)pullTableView
{
    [self beginUserCardsRequest];
}

- (void)loadMoreDataDone
{
    _tableView.pullTableIsLoadingMore = NO;
    [_tableView setLoadMoreViewHidden:NO];
}

@end



