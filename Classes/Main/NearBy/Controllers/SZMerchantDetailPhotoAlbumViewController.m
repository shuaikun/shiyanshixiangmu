//
//  SZMerchantDetailPhotoAlbumViewController.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-20.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMerchantDetailPhotoAlbumViewController.h"
#import "ITTPullTableView.h"
#import "SZNearByProductListRequest.h"
#import "SZNearByProductPhotoViewController.h"
#import "SZNearByProductPicModel.h"
#import "SZNearByProductListCell.h"
#import "SZNearByProductPhotoViewController.h"
@interface SZMerchantDetailPhotoAlbumViewController ()<UITableViewDelegate,UITableViewDataSource,ITTPullTableViewDelegate>
{
    NSInteger _currentPage;
}
@property (weak, nonatomic) IBOutlet ITTPullTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
- (IBAction)handleBackBtnClick:(id)sender;

@end

@implementation SZMerchantDetailPhotoAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentPage = 1;
    self.baseTopView.hidden  = YES;
    [self startProductListRequest];
    // Do any additional setup after loading the view from its nib.
}


- (void)startProductListRequest
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:SZNEARBY_PRODUCT_LIST,PARAMS_METHOD_KEY,self.storeId,@"store_id",[NSString stringWithFormat:@"%d",_currentPage],@"curpage",@"10",@"pagesize",nil];
    [SZNearByProductListRequest requestWithParameters:param
                                    withIndicatorView:nil
                                    withCancelSubject:CANCEL_SUBJECT_ON_PRODUCT_LIST_REQUEST
                                       onRequestStart:^(ITTBaseDataRequest *request){
                                           [PROMPT_VIEW showActivity:@"加载中..."];
    }
                                    onRequestFinished:^(ITTBaseDataRequest *request){
                                        _tableView.pullTableIsRefreshing = NO;
                                        _tableView.pullTableIsLoadingMore = NO;
                                        if (request.isSuccess) {
                                            if (_currentPage==1) {
                                                [self.dataSource removeAllObjects];
                                            }
                                            NSArray *list = [[request handleredResult]objectForKey:NETDATA];
                                            [self.dataSource addObjectsFromArray:list];
                                            [self.tableView reloadData];
                                        }
                                    }
                                    onRequestCanceled:^(ITTBaseDataRequest *request){
                                        _tableView.pullTableIsRefreshing = NO;
                                        _tableView.pullTableIsLoadingMore = NO;
                                    }
                                      onRequestFailed:^(ITTBaseDataRequest *request){
                                          _tableView.pullTableIsRefreshing = NO;
                                          _tableView.pullTableIsLoadingMore = NO;
                                      }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDelegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"";
    SZNearByProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [SZNearByProductListCell loadFromXib];
    }
    NSMutableArray *pics = [NSMutableArray array];
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
        if (index/2==indexPath.row) {
            [pics addObject:obj];
        }
    }];
    cell.click = ^(SZNearByProductPicModel *pic){
        SZNearByProductPhotoViewController *photo = [[SZNearByProductPhotoViewController alloc]init];
        photo.pic = pic;
        [self pushMasterViewController:photo];
    };
    [cell configModel:pics];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.dataSource count]+1)/2;
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.f;
}

#pragma - mark pullTableViewDelegate

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView *)pullTableView
{
    _currentPage++;
    [self startProductListRequest];
}

- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView *)pullTableView
{
    _currentPage = 1;
    [self startProductListRequest];
}
- (IBAction)handleBackBtnClick:(id)sender {
    [self popMasterViewController];
}

@end
