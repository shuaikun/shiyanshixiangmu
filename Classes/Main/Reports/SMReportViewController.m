//
//  SMReportViewController.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMReportViewController.h"
#import "ITTPullTableView.h"
#import "SMRptCommonCell.h"

#import "SMRptRBModel.h"
#import "SMRptRBRequest.h"
#import "SMReportRBEditViewController.h"
#import "SMRptZBRequest.h"
#import "SMReportZBEditViewController.h"

#import "SMRptRBAuditListRequest.h"
#import "SMRptRBAuditListModel.h"
#import "SMRptRBAuditListCell.h"
#import "SMRptRBAuditPickView.h"
#import "AppDelegate.h"
#import "SMRptRBAuditSaveRequest.h"
#import "SMRptZBAuditListRequest.h"
#import "SMRptZBAuditModel.h"
#import "SMRptZBAuditCell.h"
#import "SMRptZBAuditPickView.h"

@interface SMReportViewController ()<UITableViewDelegate,UITableViewDataSource,ITTPullTableViewDelegate>
@property (weak, nonatomic) IBOutlet ITTPullTableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (strong, nonatomic) NSMutableArray *preferentialArray;

@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL notShowLoading;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

@property (nonatomic, strong) UIWindow *auditRBPickWindow;
@property (nonatomic, strong) SMRptRBAuditPickView *auditRBPickView;

@property (nonatomic, strong) UIWindow *auditZBPickWindow;
@property (nonatomic, strong) SMRptZBAuditPickView *auditZBPickView;

@property ReportChoiceTag reportType;
@property int selectedRow;

@end

@implementation SMReportViewController

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
        //_tableView.height+=45;
    }
    
    [self setToolbarTitle];
    _currentPage = 0;
    _notShowLoading = NO;
    _preferentialArray = [NSMutableArray array];
    [_tableView setLoadMoreViewHidden:YES];
    
    [self startDataRequest];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([[UserManager sharedUserManager] reportNeedtoRefresh]){
        _currentPage = 0;
        _notShowLoading = NO;
        [_tableView setLoadMoreViewHidden:YES];
        [self startDataRequest];
        [[UserManager sharedUserManager] setReportNeedtoRefresh:NO];
    }
}


- (void)showBackButton:(BOOL)needShow
{
    _backBtn.hidden = !needShow;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setChoice:(ReportChoiceTag)tag
{
    [[UserManager sharedUserManager] setReportType:tag];
    self.reportType = tag;
    [self setToolbarTitle];
}


-(void) setToolbarTitle
{
    switch (self.reportType) {
        case kTagReportOneChoiceRB:{
            [_titleLabel setText:@"日报"];
            [_titleLabel setHidden:NO];
            [_editButton setHidden:NO];
        }
            break;
        case kTagReportOneChoiceZB:{
            [_titleLabel setText:@"周报"];
            [_titleLabel setHidden:NO];
            [_editButton setHidden:NO];
        }
            break;
        case kTagReportOneChoiceYB:{
            [_titleLabel setText:@"月报"];
            [_titleLabel setHidden:NO];
            [_editButton setHidden:YES];
        }
            break;
        case kTagReportOneChoiceWork:{
            [_titleLabel setText:@"工作事项"];
            [_titleLabel setHidden:NO];
            [_editButton setHidden:YES];
        }
            break;
        case kTagReportOneChoiceGoon:{
            [_titleLabel setText:@"未完成工作总结"];
            [_titleLabel setHidden:NO];
            [_editButton setHidden:NO];
        }
            break;
        case kTagReportOneChoiceAuditRB:{
            [_titleLabel setText:@"日报审核"];
            [_titleLabel setHidden:NO];
            [_editButton setHidden:YES];
        }
            break;
        case kTagReportOneChoiceAuditZB:{
            [_titleLabel setText:@"周报审核"];
            [_titleLabel setHidden:NO];
            [_editButton setHidden:YES];
        }
            break;
        default:
        {
            
        }
            break;
    }
}

- (IBAction)editButtonDidClicked:(id)sender {
    
    if (self.reportType == kTagReportOneChoiceRB){
        __weak typeof(self) weakSelf = self;
        typeof(self) strongSelf = weakSelf;
        SMReportRBEditViewController *controller = [[SMReportRBEditViewController alloc] initWithNibName:@"SMReportRBEditViewController" bundle:nil];
        [controller setReportData:nil];
        [strongSelf pushMasterViewController:controller];
    }
    
    if (self.reportType == kTagReportOneChoiceZB){
        __weak typeof(self) weakSelf = self;
        typeof(self) strongSelf = weakSelf;
        SMReportZBEditViewController *controller = [[SMReportZBEditViewController alloc] initWithNibName:@"SMReportZBEditViewController" bundle:nil];
        [controller setReportData:nil];
        [strongSelf pushMasterViewController:controller];
    }
}



/*============ ============ ============ ============ ============
 
 private void
 
 ============ ============ ============ ============ ============ */

-(void)startDataRequest
{
    if (self.reportType == kTagReportOneChoiceRB){
        [self startRBDataRequest];
    }
    else if (self.reportType == kTagReportOneChoiceZB){
        [self startZBDataRequest];
    }
    else if (self.reportType == kTagReportOneChoiceYB){
        [self startYBDataRequest];
    }
    else if (self.reportType == kTagReportOneChoiceWork)
    {
        
    }
    else if (self.reportType == kTagReportOneChoiceGoon){
        
    }
    else if (self.reportType == kTagReportOneChoiceAuditRB){
        [self startAuditRBDataRequest];
    }
    else if (self.reportType == kTagReportOneChoiceAuditZB){
        [self startAuditZBDataRequest];
    }
}

-(void)startRBDataRequest
{
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        _currentPage++;
        int pageSize = 20;
        
        NSString *userid = [[UserManager sharedUserManager] userId];
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"page":[NSString stringWithFormat:@"%d", _currentPage],
                                 @"rows":[NSString stringWithFormat:@"%d", pageSize]
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        
        [SMRptRBRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            if(!_notShowLoading){
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            }
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            _isLoading = NO;
            [self refreshDataDone];
            [self loadMoreDataDone];
            if (request.isSuccess) {
                NSArray *itemlist = [request.handleredResult objectForKey:@"data"];
                NSString *itemcount = [request.handleredResult objectForKey:@"totalCount"];
                int pages =[itemcount intValue] / pageSize;
                int ys =[itemcount intValue] % pageSize;
                if (ys > 0){
                    pages++;
                }
                
                if(itemlist && [itemlist isKindOfClass:[NSArray class]]){
                    //refresh
                    if(_currentPage == 1){
                        [_preferentialArray removeAllObjects];
                    }
                    
                    for (int i=0; i<[itemlist count]; i++) {
                        SMRptRBModel *regModel = [[SMRptRBModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
                        [_preferentialArray addObject:regModel];
                    }
                    
                    if(_currentPage == pages){
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
            else{
                [PROMPT_VIEW showMessage:@"无法获取日报信息"];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            _isLoading = NO;
            [self refreshDataDone];
            [self loadMoreDataDone];
        }];
    }];
}


-(void)startZBDataRequest
{
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        _currentPage++;
        int pageSize = 20;
        
        NSString *userid = [[UserManager sharedUserManager] userId];
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"page":[NSString stringWithFormat:@"%d", _currentPage],
                                 @"rows":[NSString stringWithFormat:@"%d", pageSize]
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        
        [SMRptZBRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            if(!_notShowLoading){
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            }
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            _isLoading = NO;
            [self refreshDataDone];
            [self loadMoreDataDone];
            if (request.isSuccess) {
                NSArray *itemlist = [request.handleredResult objectForKey:@"data"];
                NSString *itemcount = [request.handleredResult objectForKey:@"totalCount"];
                int pages =[itemcount intValue] / pageSize;
                int ys =[itemcount intValue] % pageSize;
                if (ys > 0){
                    pages++;
                }
                
                if(itemlist && [itemlist isKindOfClass:[NSArray class]]){
                    //refresh
                    if(_currentPage == 1){
                        [_preferentialArray removeAllObjects];
                    }
                    
                    for (int i=0; i<[itemlist count]; i++) {
                        SMRptZBModel *zbmodel = [[SMRptZBModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
                        [_preferentialArray addObject:zbmodel];
                    }
                    
                    if(_currentPage == pages){
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
            else{
                [PROMPT_VIEW showMessage:@"无法获取周报信息"];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            _isLoading = NO;
            [self refreshDataDone];
            [self loadMoreDataDone];
        }];
    }];
}

-(void)startYBDataRequest
{
    
}

-(void)startAuditRBDataRequest
{
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        _currentPage++;
        int pageSize = 20;
        
        NSString *userid = [[UserManager sharedUserManager] userId];
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"page":[NSString stringWithFormat:@"%d", _currentPage],
                                 @"rows":[NSString stringWithFormat:@"%d", pageSize]
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        
        [SMRptRBAuditListRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            if(!_notShowLoading){
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            }
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            _isLoading = NO;
            [self refreshDataDone];
            [self loadMoreDataDone];
            if (request.isSuccess) {
                NSArray *itemlist = [request.handleredResult objectForKey:@"data"];
                NSString *itemcount = [request.handleredResult objectForKey:@"totalCount"];
                int pages =[itemcount intValue] / pageSize;
                int ys =[itemcount intValue] % pageSize;
                if (ys > 0){
                    pages++;
                }
                
                if(itemlist && [itemlist isKindOfClass:[NSArray class]]){
                    //refresh
                    if(_currentPage == 1){
                        [_preferentialArray removeAllObjects];
                    }
                    
                    for (int i=0; i<[itemlist count]; i++) {
                        SMRptRBAuditListModel *zbmodel = [[SMRptRBAuditListModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
                        
                        [_preferentialArray addObject:zbmodel];
                    }
                    
                    if(_currentPage == pages){
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
            else{
                [PROMPT_VIEW showMessage:@"无法获取待审核的日报信息"];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            _isLoading = NO;
            [self refreshDataDone];
            [self loadMoreDataDone];
        }];
    }];
}
-(void)startAuditZBDataRequest
{
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        _currentPage++;
        int pageSize = 20;
        
        NSString *userid = [[UserManager sharedUserManager] userId];
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"page":[NSString stringWithFormat:@"%d", _currentPage],
                                 @"rows":[NSString stringWithFormat:@"%d", pageSize]
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        
        [SMRptZBAuditListRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            if(!_notShowLoading){
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            }
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            _isLoading = NO;
            [self refreshDataDone];
            [self loadMoreDataDone];
            if (request.isSuccess) {
                NSArray *itemlist = [request.handleredResult objectForKey:@"data"];
                NSString *itemcount = [request.handleredResult objectForKey:@"totalCount"];
                int pages =[itemcount intValue] / pageSize;
                int ys =[itemcount intValue] % pageSize;
                if (ys > 0){
                    pages++;
                }
                
                if(itemlist && [itemlist isKindOfClass:[NSArray class]]){
                    //refresh
                    if(_currentPage == 1){
                        [_preferentialArray removeAllObjects];
                    }
                    
                    for (int i=0; i<[itemlist count]; i++) {
                        SMRptZBAuditModel *zbmodel = [[SMRptZBAuditModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
                        
                        [_preferentialArray addObject:zbmodel];
                    }
                    
                    if(_currentPage == pages){
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
            else{
                [PROMPT_VIEW showMessage:@"无法获取待审核的日报信息"];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            _isLoading = NO;
            [self refreshDataDone];
            [self loadMoreDataDone];
        }];
    }];
}

-(void)auditZB:(SMRptZBAuditModel*)model
{
    
    if (model == nil) return;
    if (IS_STRING_EMPTY(model.id)) return;
    
    
    
    [model fillDataWithFinishBlock:^(BOOL finished, NSString *msg) {
        if (finished)
        {
            if (_auditZBPickWindow == nil) {
                self.auditZBPickWindow = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
                CALayer *hudLayer = [CALayer layer];
                hudLayer.frame = CGRectMake(0, 0, _auditZBPickWindow.width, _auditZBPickWindow.height);
                hudLayer.backgroundColor = [UIColor blackColor].CGColor;
                hudLayer.opacity = 0.6;
                
                _auditZBPickWindow.backgroundColor = [UIColor clearColor];
                _auditZBPickWindow.windowLevel =UIWindowLevelNormal;
                _auditZBPickWindow.alpha =1.f;
                _auditZBPickWindow.hidden =NO;
                [_auditZBPickWindow.layer addSublayer:hudLayer];
                
                
                UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
                tapGestureR.cancelsTouchesInView = NO;
                [[_auditZBPickWindow superview] addGestureRecognizer:tapGestureR];
                
            }
            
            if (_auditZBPickView == nil){
                self.auditZBPickView = [ITTXibViewUtils loadViewFromXibNamed:@"SMRptZBAuditPickView"];
                self.auditZBPickView.tag = kCellEdit;
                [_auditZBPickWindow addSubview:_auditZBPickView];
            }
            
            [_auditZBPickWindow bringSubviewToFront:[_auditZBPickWindow viewWithTag:kCellEdit]];
            
            [_auditZBPickView setHidden:NO];
            [_auditZBPickView setData:model];
            [_auditZBPickWindow makeKeyAndVisible];
            [_auditZBPickView showReportZBAuditPickViewWithFinishBlock:^(SMRptZBAuditModel *model, int optype, NSString *opinion) {
                AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
                [[appDelegate window] makeKeyAndVisible];
                [self.auditZBPickView setHidden:YES];
                
                if (optype != -1)
                {
                    //[self auditRBSave:model leadspeak:opinion];
                    model.condition = @"已审核";
                    
                    [_preferentialArray setObject:model atIndexedSubscript:self.selectedRow];
                    [_tableView reloadData];
                }
            }];
        }
        else{
            [PROMPT_VIEW showMessage:msg];
        }
    }];
    
    
}

-(void)auditRB:(SMRptRBAuditListModel*)model
{
    if (_auditRBPickWindow == nil) {
        self.auditRBPickWindow = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
        CALayer *hudLayer = [CALayer layer];
        hudLayer.frame = CGRectMake(0, 0, _auditRBPickWindow.width, _auditRBPickWindow.height);
        hudLayer.backgroundColor = [UIColor blackColor].CGColor;
        hudLayer.opacity = 0.6;
        
        _auditRBPickWindow.backgroundColor = [UIColor clearColor];
        _auditRBPickWindow.windowLevel =UIWindowLevelNormal;
        _auditRBPickWindow.alpha =1.f;
        _auditRBPickWindow.hidden =NO;
        [_auditRBPickWindow.layer addSublayer:hudLayer];
        
        
        UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        tapGestureR.cancelsTouchesInView = NO;
        [[_auditRBPickWindow superview] addGestureRecognizer:tapGestureR];
        
    }
    
    if (_auditRBPickView == nil){
        self.auditRBPickView = [ITTXibViewUtils loadViewFromXibNamed:@"SMRptRBAuditPickView"];
        self.auditRBPickView.tag = kCellEdit;
        [_auditRBPickWindow addSubview:_auditRBPickView];
    }
    
    [_auditRBPickWindow bringSubviewToFront:[_auditRBPickWindow viewWithTag:kCellEdit]];
    
    [_auditRBPickView setHidden:NO];
    [_auditRBPickView setData:model];
    [_auditRBPickWindow makeKeyAndVisible];
    [_auditRBPickView showReportRBAuditPickViewWithFinishBlock:^(SMRptRBAuditListModel *model, int optype, NSString *opinion) {
        AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
        [[appDelegate window] makeKeyAndVisible];
        [self.auditRBPickView setHidden:YES];
        
        if (optype != -1)
        {
            //[self auditRBSave:model leadspeak:opinion];
            model.condition = @"已审核";
            
            [_preferentialArray setObject:model atIndexedSubscript:self.selectedRow];
            [_tableView reloadData];
        }
    }];
}



/*============ ============ ============ ============ ============
 
 TableView
 
 ============ ============ ============ ============ ============ */

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
	_selectedRow=indexPath.row;
	[self.tableView reloadData];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[self removeRow];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
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
    if (self.reportType == kTagReportOneChoiceRB){
        return 104;
    }
    else if (self.reportType == kTagReportOneChoiceZB){
        return 104;
    }
    else if (self.reportType == kTagReportOneChoiceYB){
        return 104;
    }
    else if (self.reportType == kTagReportOneChoiceWork){
        return 104;
    }
    else if (self.reportType == kTagReportOneChoiceGoon){
        return 104;
    }
    else if (self.reportType == kTagReportOneChoiceAuditRB)
    {
        return 74;
    }
    else if (self.reportType == kTagReportOneChoiceAuditZB){
        return 34;
    }
    return 104;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self performSegueWithIdentifier: @"showRecipeDetail" sender: self];
    __weak typeof(self) weakSelf = self;
    typeof(self) strongSelf = weakSelf;
    
    if (self.reportType == kTagReportOneChoiceRB){
        SMReportRBEditViewController *controller = [[SMReportRBEditViewController alloc] initWithNibName:@"SMReportRBEditViewController" bundle:nil];
        [controller setReportData: [_preferentialArray objectAtIndex:indexPath.row]];
        [strongSelf pushMasterViewController:controller];
    }
    else if (self.reportType == kTagReportOneChoiceZB){
        SMReportZBEditViewController *controller = [[SMReportZBEditViewController alloc] initWithNibName:@"SMReportZBEditViewController" bundle:nil];
        [controller setReportData: [_preferentialArray objectAtIndex:indexPath.row]];
        [strongSelf pushMasterViewController:controller];
    }
    else if (self.reportType == kTagReportOneChoiceYB){
        
    }
    else if (self.reportType == kTagReportOneChoiceWork){
    }
    else if (self.reportType == kTagReportOneChoiceGoon){
    }
    else if (self.reportType == kTagReportOneChoiceAuditRB){
        self.selectedRow = indexPath.row;
        [self auditRB:[_preferentialArray objectAtIndex:indexPath.row]];
    }
    else if (self.reportType == kTagReportOneChoiceAuditZB){
        self.selectedRow = indexPath.row;
        [self auditZB:[_preferentialArray objectAtIndex:indexPath.row]];
    }
    else{
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.reportType == kTagReportOneChoiceAuditRB){
        static NSString *cellIdentifier = @"SMRptRBAuditListCell";
        SMRptRBAuditListCell *cell = (SMRptRBAuditListCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            cell = [SMRptRBAuditListCell cellFromNib];
            //cell.cellDelegate = self;
        }
        
        [cell setData:[_preferentialArray objectAtIndex:indexPath.row]];
        return cell;
    }
    else if (self.reportType == kTagReportOneChoiceAuditZB){
        static NSString *cellIdentifier = @"SMRptZBAuditCell";
        SMRptZBAuditCell *cell = (SMRptZBAuditCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            cell = [SMRptZBAuditCell cellFromNib];
            //cell.cellDelegate = self;
        }
        
        [cell setData:[_preferentialArray objectAtIndex:indexPath.row]];
        return cell;
    }
    else{
        
        static NSString *cellIdentifier = @"SMRptCommonCell";
        SMRptCommonCell *cell = (SMRptCommonCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            cell = [SMRptCommonCell cellFromNib];
            //cell.cellDelegate = self;
        }
    
        [cell setData:[_preferentialArray objectAtIndex:indexPath.row]];
        return cell;
    }
}



/*=========
 */



/*=====================================================================================
        PullTable View
=====================================================================================*/
- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView *)pullTableView
{
    _currentPage = 0;
    _notShowLoading = YES;
    [self startDataRequest];
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView *)pullTableView
{
    _notShowLoading = YES;
    [self startDataRequest];
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
