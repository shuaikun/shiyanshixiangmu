//
//  WWPackageSearchViewController.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-19.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWPackageSearchViewController.h"
#import "ITTRefreshTableHeaderView.h"
#import "WWSearchPackageRequest.h"
#import "WWSearchPackageInfoModel.h"
#import "WWSearchPackageBoxCell.h"

@interface WWPackageSearchViewController ()
<
ITTRefreshTableHeaderDelegate
,UIScrollViewDelegate
>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIButton *showMoreDiscountBtn;
@property (nonatomic, strong) ITTRefreshTableHeaderView *refreshView;
@property (nonatomic,readwrite) BOOL pullTableIsRefreshing;
@property (nonatomic, strong) NSMutableArray *preferentialCellArray;
@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, readwrite) int pageNo;
@property (nonatomic, readwrite) int pageSize;
@property (nonatomic, readwrite) int total;


@end

@implementation WWPackageSearchViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"包装物"];
    
    _preferentialCellArray = [NSMutableArray array];
    
    UIColor *topColor = [UIColor whiteColor];
    [[self view] setBackgroundColor:topColor];
    [[self baseTopView] setBackgroundColor: topColor];
    [self setTopViewBackButtonImageStyle:0];
    
    [self setupRefrashHeader];
    self.pageNo = 1;
    self.pageSize = 10;
    [self search];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _scrollView.top = [[ self baseTopView] height];
    _scrollView.height = self.view.height - _scrollView.top;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)search
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[NSString stringWithFormat:@"%d", _pageNo] forKey:@"pageno"];
    [paramDict setObject:[NSString stringWithFormat:@"%d", _pageSize]  forKey:@"pagesize"];
    NSLog(@"paramDict is %@",paramDict);
    [WWSearchPackageRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        NSLog(@"start loading");
        [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        
        if (request.isSuccess) {
            NSArray *list = [request.handleredResult objectForKey:NETDATA];
            NSString *totals = [request.handleredResult objectForKey:@"total"];
            _total = [totals intValue];
            if (_dataList == nil){
                _dataList = [NSMutableArray array];
            }
            if (_pageNo == 1){
                [_dataList removeAllObjects];
            }
            
            for (int i = 0; i < [list count]; i++) {
                NSDictionary *data = [list objectAtIndex:i];
                WWSearchPackageInfoModel *newModel = [[WWSearchPackageInfoModel alloc] initWithDataDic:data];
                [_dataList addObject:newModel];
            }
            
            [self performSelector:@selector(loadListData) withObject:nil afterDelay:1];
        }
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
    }];
}


-(void)loadListData
{
    __weak typeof(self) weakSelf = self;
    weakSelf.pullTableIsRefreshing = NO;
    
    [_preferentialCellArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat curTop = 20;
    for (WWSearchPackageInfoModel *itemModel in _dataList) {
        WWSearchPackageBoxCell *cell = [WWSearchPackageBoxCell cellFromNib];
        [cell showCellWithFinishBlock:^(WWSearchPackageInfoModel *model) {
            
        } data:itemModel];
        [_preferentialCellArray addObject:cell];
        cell.top = curTop,curTop+=cell.height;
        [_scrollView addSubview:cell];
    }
    _showMoreDiscountBtn.top = curTop+9;
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _showMoreDiscountBtn.bottom+20);
    _showMoreDiscountBtn.hidden = YES;
    
    if (_total > [_dataList count]){
        _showMoreDiscountBtn.hidden = NO;
    }
    
    
    [PROMPT_VIEW hideWithAnimation];
    
    self.pullTableIsRefreshing = NO;
    [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
    [self setRefreshViewHidden:YES];
}

- (IBAction)loadMore:(id)sender {
    _pageNo += 1;
    [self search];
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
    self.pageNo = 1;
    [self search];
}


@end
