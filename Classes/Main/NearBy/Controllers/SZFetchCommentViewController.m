//
//  SZFetchCommentViewController.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-16.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZFetchCommentViewController.h"
#import "SZUserCommentViewController.h"
#import "SZNearByUserCommentModel.h"
#import "SZNearByCommentCell.h"
#import "SZNearByGetCommentRequest.h"
#import "ITTPullTableView.h"
@interface SZFetchCommentViewController ()<UITableViewDataSource,UITableViewDelegate,ITTPullTableViewDelegate>
{
    NSInteger _currentPage;
}
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet ITTPullTableView *tableView;

- (IBAction)handleBackClick:(id)sender;
- (IBAction)handleAddCommentClick:(id)sender;

@end

@implementation SZFetchCommentViewController

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
    _currentPage = 1;
    self.baseTopView.hidden = YES;
    self.dataSource = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _currentPage = 1;
    [self startCommentRequest];
}

- (void)startCommentRequest
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:SZNEARBY_GETSTORECOMMENT,PARAMS_METHOD_KEY,self.store_id,@"store_id",@"10",@"pagesize",[NSString stringWithFormat:@"%d",_currentPage],@"curpage", nil];
    
    void (^pullTableAddition)(void) = ^(void){
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullTableIsLoadingMore = NO;
    };
    [SZNearByGetCommentRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:CANCEL_SUBJECT_ON_GET_COMMENT_REQUEST
                                      onRequestStart:^(ITTBaseDataRequest *request){
                                          if (!(_tableView.pullTableIsLoadingMore||_tableView.pullTableIsRefreshing)) {
                                              [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
                                          }
                                          
                                      }
                                   onRequestFinished:^(ITTBaseDataRequest *request){
                                        pullTableAddition();
                                       if (request.isSuccess) {
                                           NSString *totleNumber =  [request.handleredResult objectForKey:@"totalnum"];
                                           NSInteger count = [totleNumber integerValue];
                                           if (_currentPage==1) {
                                               [self.dataSource removeAllObjects];
                                           }
                                           NSMutableArray*comments = [request.handleredResult objectForKey:NETDATA];
                                           [self.dataSource addObjectsFromArray:comments];
                                           [self.tableView reloadData];
                                           if ([self.dataSource count]>= count) {
                                               [self.tableView setLoadMoreViewHidden:YES];
                                           }else{
                                               [self.tableView setLoadMoreViewHidden:NO];
                                           }
                                       }
                                   }
                                   onRequestCanceled:^(ITTBaseDataRequest *request){
                                       [PROMPT_VIEW hideWithAnimation];
                                       pullTableAddition();
                                   }
                                     onRequestFailed:^(ITTBaseDataRequest *request){
                                         pullTableAddition();
                                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleBackClick:(id)sender {
    [self popMasterViewController];
}

- (IBAction)handleAddCommentClick:(id)sender {
    SZUserCommentViewController *addCommentViewController = [[SZUserCommentViewController alloc]init];
    addCommentViewController.storeid = self.store_id;
    [self pushMasterViewController:addCommentViewController];
}
#pragma mark tableViewDelegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *commentCell = @"commentCell";
    SZNearByCommentCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
    if (cell == nil) {
        cell = [SZNearByCommentCell loadFromXib];
    }
    SZNearByUserCommentModel *comment = [self.dataSource objectAtIndex:indexPath.row];
    [cell configModel:comment];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SZNearByUserCommentModel *comment = [self.dataSource objectAtIndex:indexPath.row];
    NSString *content = comment.comment;
    float height = [content heightWithFont:[UIFont systemFontOfSize:13.f] withLineWidth:287];
    float defaultContentHeight = 46.5f;
    float offSetHeight = defaultContentHeight - height;
    return 155.f-offSetHeight;
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView *)pullTableView
{
    _currentPage++;
    [self startCommentRequest];
}

- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView *)pullTableView
{
    _currentPage = 1;
    [self startCommentRequest];
}
@end
