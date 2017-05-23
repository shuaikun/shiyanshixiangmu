//
//  TableDomeViewController.m
//  iTotemFramework
//
//  Created by admin on 13-1-27.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import <StoreKit/StoreKit.h>

#import "PullTableViewDemoController.h"
#import "ApplicationCell.h"
#import "ApplicationManager.h"
#import "ApplicationSearchDataRequest.h"
#import "ApplicationModel.h"
#import "AppDelegate.h"
#import "HomeTabBarController.h"
#import "ApplicationSectionHeader.h"
#import "SectionHeaderView.h"
#import "NSString+ITTAdditions.h"

@interface PullTableViewDemoController ()<SKStoreProductViewControllerDelegate, ApplicationSectionHeaderDelegate>
{
    BOOL                        _loading;
    NSInteger                   _limit;
    ApplicationManager          *_applicationManager;
}

@property (nonatomic, assign) NSInteger openSectionIndex;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation PullTableViewDemoController

@synthesize tableView = _tableView;

#pragma mark - private methods
- (void)setup
{
    self.navTitle = @"PullTableView demo";
    _limit = 10;
    _openSectionIndex = NSNotFound;
    _applicationManager = [[ApplicationManager alloc] init];
}

#pragma mark - lifecycle
- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setIndicator:nil];
    [super viewDidUnload];
}

- (id)init
{
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AppDelegate GetAppDelegate].tabBarController.tabBarHidden = TRUE;
    [self performSelector:@selector(getApplicationListDataRequest) withObject:nil afterDelay:0.04];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_applicationManager && [_applicationManager count] > 0) {
        return [_applicationManager count];
    }
    else {
        return 0;
    }    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *cellIdentifier = @"ApplicationCell";
    ApplicationSectionHeader *applicationSectionHeader = [_applicationManager objectAtIndex:indexPath.section];    
    ApplicationModel *application = applicationSectionHeader.applications[indexPath.row];
    ApplicationCell *cell = (ApplicationCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [ApplicationCell cellFromNib];
    }
    cell.application = application;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ApplicationSectionHeader *sectionHeader = [_applicationManager objectAtIndex:section];
    return sectionHeader.open ? 1 : 0;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplicationSectionHeader *applicationSectionHeader = [_applicationManager objectAtIndex:indexPath.section];
    ApplicationModel *application = applicationSectionHeader.applications[indexPath.row];
    CGFloat height = [application.introduction heightWithFont:[UIFont systemFontOfSize:14] withLineWidth:254];
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ApplicationSectionHeader *sectionHeader = [_applicationManager objectAtIndex:section];
    SectionHeaderView *sectionHeaderView = sectionHeader.headerView;
    if (!sectionHeaderView) {
        sectionHeaderView = [SectionHeaderView loadFromXib];
        sectionHeader.headerView = sectionHeaderView;
        sectionHeaderView.delegate = self;            
    }
    sectionHeaderView.section = section;
    sectionHeaderView.sectionHeader = sectionHeader;
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    if ([SKStoreProductViewController class]) {      //SKStoreProductViewController is not available before ios6
        [self showIndicator:TRUE];
        ApplicationSectionHeader *sectionHeader = [_applicationManager objectAtIndex:indexPath.section];
        ApplicationModel *application = sectionHeader.applications[indexPath.row];
        NSString *identifer = application.itunesId;
        SKStoreProductViewController *productViewController = [[SKStoreProductViewController alloc] init];
        productViewController.delegate = self;
        [productViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: identifer}
                          completionBlock:^(BOOL result, NSError *error) {
                              [self showIndicator:FALSE];
                              if (result) {
                                  [self presentViewController:productViewController animated:YES completion:nil];
                              }
                              else{
                                  ITTDINFO(@"%@",error);
                              }
                          }];

    }
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
//    [self dismissModalViewControllerAnimated:TRUE];
    [self dismissViewControllerAnimated:TRUE completion:NULL];
}

#pragma mark - private methods
- (void)showIndicator:(BOOL)show
{
    if (show) {
        self.indicator.hidden = FALSE;
        [self.indicator startAnimating];
    }
    else {
        self.indicator.hidden = TRUE;
        [self.indicator stopAnimating];
    }
}

- (void)onBackBtnClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:APPLICATION_LIST_REQUEST_CANCEL_SUBJECT object:nil];
    [super onBackBtnClicked];
}

- (void)setDataDic:(NSDictionary *)resultDic
{
    [self refreshDataDone];
    [self loadMoreDataDone];
    [_applicationManager removeAllObjects];
    if (_applicationManager.kRefreshType == kRefreshTypeDown) {
        NSArray *applications = resultDic[KEY_APPLICATION];
        if ([applications count] >= 1) {
//            如果返回参数有limit和count
//            int pageSize = [[resultDic objectForKey:@"limit"] intValue];
//            int resultCount = [[resultDic objectForKey:@"count"] intValue];
//             如果返回参数没有limit和count 根据情况自定义            
            [_applicationManager updatePageIndexWithResultCount:[applications count] pageSize:PAGE_COUNT];
            [_applicationManager addObjectsFromArray:applications];
            if ([applications count] < PAGE_COUNT) {
                [_tableView setLoadMoreViewHidden:YES];
            }else{
                [_tableView setLoadMoreViewHidden:NO];
            }
        }
    }
    else {
        [self loadMoreDataDone];
        NSArray *applications = resultDic[KEY_APPLICATION];
//        如果返回参数有limit和count
//        int pageSize = [[resultDic objectForKey:@"limit"] intValue];
//        int resultCount = [[resultDic objectForKey:@"count"] intValue];
//         如果返回参数没有limit和count 根据情况自定义
        [_applicationManager updatePageIndexWithResultCount:[applications count] pageSize:PAGE_COUNT];
        [_applicationManager addObjectsFromArray:applications];
        if ([applications count] < PAGE_COUNT) {
            [_tableView setLoadMoreViewHidden:YES];
        }
    }
}

- (void)sendGetApplicationDataRequest
{
    if (!_loading) {
        _loading = TRUE;
        NSString *limit = [NSString stringWithFormat:@"%d", _limit];
        [ApplicationSearchDataRequest requestWithParameters:@{@"limit": limit}
                                          withIndicatorView:self.view
                                          withCancelSubject:APPLICATION_LIST_REQUEST_CANCEL_SUBJECT
                                             onRequestStart:^(ITTBaseDataRequest *request) {
                                             }
                                          onRequestFinished:^(ITTBaseDataRequest *request) {
                                              if ([request isSuccess]) {
                                                  [self setDataDic:request.handleredResult];
                                                  [self.tableView reloadData];
                                                  _loading = FALSE;
                                              }
                                          }
                                          onRequestCanceled:^(ITTBaseDataRequest *request) {
                                              if (_applicationManager.kRefreshType == kRefreshTypeDown) {
                                                  [self refreshDataDone];
                                              }else{
                                                  [self loadMoreDataDone];
                                              }
                                              _loading = FALSE;                                              
                                          }
                                            onRequestFailed:^(ITTBaseDataRequest *request) {
                                                if (_applicationManager.kRefreshType == kRefreshTypeDown) {
                                                    [self refreshDataDone];
                                                }else{
                                                    [self loadMoreDataDone];
                                                }
                                                _loading = FALSE;                                                
                                            }];
    }
}

- (void)getApplicationListDataRequest
{
    _applicationManager.kRefreshType = kRefreshTypeDown;
    _limit = 10;
    [self sendGetApplicationDataRequest];
}

-(void)loadMoreApplicationListDataRequest
{
    _applicationManager.kRefreshType = kRefreshTypeUp;
    _limit += 10;
    [self sendGetApplicationDataRequest];
}

#pragma mark - SectionHeaderViewDelegate
- (void)sectionHeaderView:(SectionHeaderView*)cellHeader didOpenedSection:(NSInteger)sectionOpened
{	
    ApplicationSectionHeader *sectionInfo = [_applicationManager objectAtIndex:sectionOpened];
	sectionInfo.open = YES;
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [sectionInfo.applications count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        ApplicationSectionHeader *previousOpenSection = [_applicationManager objectAtIndex:previousOpenSectionIndex];		
        previousOpenSection.open = NO;
        NSInteger countOfRowsToDelete = [previousOpenSection.applications count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];        
    [self.tableView endUpdates];
    self.openSectionIndex = sectionOpened;
    
}

- (void)sectionHeaderView:(SectionHeaderView*)cellHeader didClosedSection:(NSInteger)sectionClosed
{
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
    ApplicationSectionHeader *sectionInfo = [_applicationManager objectAtIndex:sectionClosed];
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}


#pragma mark - ITTPullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView *)pullTableView
{
    [_tableView setRefreshViewHidden:NO];
    ITTDINFO(@"pullTableViewDidTriggerRefresh");
    [self getApplicationListDataRequest];
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView *)pullTableView
{
    ITTDINFO(@"pullTableViewDidTriggerLoadMore");    
    [_tableView setLoadMoreViewHidden:NO];
    [self loadMoreApplicationListDataRequest];
}

- (void)loadMoreDataDone
{
    /*
     *Code to actually load more data goes here.
     */
    _openSectionIndex = NSNotFound;    
    _tableView.pullTableIsLoadingMore = NO;
    _applicationManager.kRefreshType = kRefreshTypeNone;
}

- (void)refreshDataDone
{
    /*
     *Code to actually refresh goes here.
     */
    _openSectionIndex = NSNotFound;    
    _applicationManager.kRefreshType = kRefreshTypeNone;
    _tableView.pullLastRefreshDate = [NSDate date];
    _tableView.pullTableIsRefreshing = NO;
}
@end
