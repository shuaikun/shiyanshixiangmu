//
//  SZActivityStoreViewController.m
//  iTotemFramework
//
//  Created by Grant on 14-5-7.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZActivityStoreViewController.h"
#import "ITTPullTableView.h"
#import "SZActivityMerchantCell.h"
#import "SZUserCollectRequest.h"

@interface SZActivityStoreViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
ITTPullTableViewDelegate
>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet ITTPullTableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) BOOL isLoading;

@end

@implementation SZActivityStoreViewController

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
    _dataArray = [NSMutableArray array];
    [_tableView setRefreshViewHidden:YES];
    [self beginUserCollectRequest];
}

- (void)beginUserCollectRequest
{
    __weak typeof(self) weakSelf = self;
    typeof(weakSelf) strongSelf = weakSelf;
    if(!strongSelf.isLoading){
        strongSelf.isLoading = YES;
        strongSelf.currentPage++;
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:_accId forKey:@"aac_id"];
        [paramDict setObject:_lat forKey:@"lat"];
        [paramDict setObject:_lng forKey:@"lng"];
        
        [paramDict setObject:SZACTIVITY_STORELIST_METHORD forKey:PARAMS_METHOD_KEY];
        [paramDict setObject:[NSString stringWithFormat:@"%d",strongSelf.currentPage] forKey:@"curpage"];
        [paramDict setObject:@"10" forKey:@"pagesize"];
        NSLog(@"paramDict is %@",paramDict);
        [SZUserCollectRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            if(strongSelf.currentPage == 1){
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            }
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            strongSelf.isLoading = NO;
            [strongSelf loadMoreDataDone];
            if (request.isSuccess) {
                NSArray *store_list = [request.handleredResult objectForKey:@"store_list"];
                NSString *totalpage = [request.handleredResult objectForKey:@"totalpage"];
                NSString *totalnum = [request.handleredResult objectForKey:@"totalnum"];
                if(store_list && [store_list isKindOfClass:[NSArray class]]){
                    NSLog(@"store_list is %@,totalpage is %@,totalnum is %@",store_list,totalpage,totalnum);
                    //refresh
                    [strongSelf.dataArray addObjectsFromArray:store_list];
                    if(strongSelf.currentPage == [totalpage intValue]){
                        [strongSelf.tableView setLoadMoreViewHidden:YES];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SZActivityMerchantCell";
    SZActivityMerchantCell *cell = (SZActivityMerchantCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [SZActivityMerchantCell cellFromNib];
    }
    [cell getDataSourceFromModel:[_dataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView *)pullTableView
{
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView *)pullTableView
{
    [self beginUserCollectRequest];
}

- (void)loadMoreDataDone
{
    _tableView.pullTableIsLoadingMore = NO;
    [_tableView setLoadMoreViewHidden:NO];
}

@end

