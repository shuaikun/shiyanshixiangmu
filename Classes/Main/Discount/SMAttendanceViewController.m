//
//  SMAttendanceViewController.m
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-6.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendanceViewController.h"
#import "SMAttendRegCell.h"
#import "SMAttendLeaveCell.h"
#import "SMAttendRegModel.h"
#import "SMAttendLeaveModel.h"
#import "SZCouponDetailViewController.h"
#import "SZMembershipCardDetailViewController.h"
#import "SZCustomPickerView.h"
#import "ITTPullTableView.h"
#import "SZGoodsSearchDataListRequest.h"
#import "SMAttendAuditRegRequest.h"
#import "SMAttendAuditLeaveRequest.h"
#import "SMAttendAuditingLeaveRequest.h"
#import "SMAttendAuditingRegRequest.h"
#import "SZGoodsDetailRequest.h"
#import "SZPreferentialModel.h"
#import "SZStoreModel.h"
#import "SZFilterDataRequest.h"
#import "AppDelegate.h"
#import "SMAuditingRegPickView.h"
#import "SMAuditingLeavePickView.h"
#import "SMAttendRegListRequest.h"
#import "SMAttendLeaveListRequest.h"
#import "SMEditRegPickView.h"
#import "SMAttendSaveRegRequest.h"
#import "SMAttendSaveLeaveRequest.h"
#import "SMEditLeavePickView.h"
#import "SMAttendTxListRequest.h"
#import "SMAttendAuditTxListRequest.h"
#import "SMAttendTxModel.h"
#import "SMAttendTxCell.h"
#import "SMEditTxPickView.h"
#import "SMAttendSaveTxRequest.h"
#import "SMAuditTxPickView.h"
#import "SMAttendAuditTxRequest.h"
#import "SMAttendRemoveRegRequest.h"
#import "SMAttendRemoveLeaveRequest.h"
#import "SMAttendRemoveTxRequest.h"
#import "SMAttendAuditVerfiyRequest.h"
#import "SMAuditVerfiyModel.h"
#import "SMAttendAuditingBatchRegRequest.h"
#import "SMAttendAuditingBatchLeaveRequest.h"

@interface SMAttendanceViewController ()<UITableViewDelegate,UITableViewDataSource,SZCustomPickerViewDelegate,ITTPullTableViewDelegate>

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
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIButton *regBtn;
@property (weak, nonatomic) IBOutlet UIButton *leaveBtn;
@property (weak, nonatomic) IBOutlet UIButton *auditBtn;

@property (nonatomic, strong) UIWindow *newsPickWindow;
@property (nonatomic, strong) SMAuditingRegPickView *auditRegPickView;

@property (assign, nonatomic) int currentIndex;
@property (strong, nonatomic) NSString *curOpinion;
@property (assign, nonatomic) int curOperType;

@property (nonatomic, strong) UIWindow *auditLeavePickWindow;
@property (nonatomic, strong) SMAuditingLeavePickView *auditLeavePickView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;


@property (nonatomic, strong) UIWindow *editRegPickWindow;
@property (nonatomic, strong) SMEditRegPickView *editRegPickView;
@property (nonatomic, strong) UIWindow *editLeavePickWindow;
@property (nonatomic, strong) SMEditLeavePickView *editLeavePickView;
@property (nonatomic, strong) UIWindow *editTxPickWindow;
@property (nonatomic, strong) SMEditTxPickView *editTxPickView;

@property (nonatomic, strong) UIWindow *pickWindow;
@property (nonatomic, strong) SMAuditTxPickView *auditTxPickView;

@property (weak, nonatomic) IBOutlet UIView *batchAuditPanel;
@property (weak, nonatomic) IBOutlet UIButton *batchButton;


@property int selectedRow;
@property BOOL batch_audit_status;
@property (strong, nonatomic) NSMutableArray *batchAuditIDList;


@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSelectControl;
@property (weak, nonatomic) IBOutlet UITextField *optionTextField;



@end

@implementation SMAttendanceViewController


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
    
    
    [self setToolbarTitle];
    
    
    
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
-(void)hideKeyboard:(id)sender
{
    NSLog(@"fuck the textbox : %@", sender);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self initTopButton];
    
    if(_isFromHomePage){
        [self showBackButton:YES];
    }
    else{
        _tableView.height-=45;
        [self showBackButton:NO];
    }
    
    [_batchAuditPanel setTop: 0];
    if(IS_IOS_7){
        
    }
    else{
        //_tableView.height+=45;
    }
    
    [_batchAuditPanel setTop:_tableView.top];
    _batchAuditPanel.width = self.view.width;
    [_batchAuditPanel setHidden:YES];
    [_batchAuditPanel setLeft:0];
    [_optionTextField setTag:0];
    
    
    //[self addFilterView];
    //[self addAttendButtonsView];
    //[_tableView setLoadMoreViewHidden:YES];
    //_preferentialArray = [NSMutableArray array];
    
    //_currentPage = 0;
    //[self startDataRequest];
    
    
    [self setToolbarTitle];
    _currentPage = 0;
    _notShowLoading = NO;
    _preferentialArray = [NSMutableArray array];
    [_tableView setLoadMoreViewHidden:YES];
    [self showBackButton:YES];
    [self startDataRequest];
    
}

- (void)showBackButton:(BOOL)needShow
{
    _backBtn.hidden = !needShow;
}

/*
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
*/



/*==========================================================================================
 
    开始请求， 总 Route
 
============================================================================================*/

-(void)startDataRequest{
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        if ([[UserManager sharedUserManager] isAttendAuditRegType]){
            [self startAuditRegDataRequest];
        }
        else if ([[UserManager sharedUserManager] isAttendAuditLeaveType]){
            [self startAuditLeaveDataRequest];
        }
        else if ([[UserManager sharedUserManager] isAttendRegType]){
            [self startRegDataRequest];
        }
        else if ([[UserManager sharedUserManager] isAttendLeaveType]){
            [self startLeaveDataRequest];
        }
        else if ([[UserManager sharedUserManager] attendType] == kTagKaoQinOneChoiceMyTx){
            [self startTxDataRequest];
        }
        else if ([[UserManager sharedUserManager] attendType] == kTagKaoQinOneChoiceAuditTx){
            [self startAuditTxDataRequest];
        }
    }];
}

-(void)startTxDataRequest
{
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
    
    
    [SMAttendTxListRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
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
                    SMAttendTxModel *model = [[SMAttendTxModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
                    [_preferentialArray addObject:model];
                }
                //[_preferentialArray addObjectsFromArray:itemlist];
                
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
            [self startDataRequest];
        }
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        _isLoading = NO;
        [self refreshDataDone];
        [self loadMoreDataDone];
    }];
}

-(void)startAuditTxDataRequest
{
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
    
    
    [SMAttendAuditTxListRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
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
                    SMAttendTxModel *model = [[SMAttendTxModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
                    [_preferentialArray addObject:model];
                }
                //[_preferentialArray addObjectsFromArray:itemlist];
                
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
            //[self startDataRequest];
        }
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        _isLoading = NO;
        [self refreshDataDone];
        [self loadMoreDataDone];
    }];
}

-(void)startAuditRegDataRequest
{
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
    
    
    [SMAttendAuditRegRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
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
                    SMAttendRegModel *regModel = [[SMAttendRegModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
                    [_preferentialArray addObject:regModel];
                }
                //[_preferentialArray addObjectsFromArray:itemlist];
                
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
            [self startDataRequest];
        }
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        _isLoading = NO;
        [self refreshDataDone];
        [self loadMoreDataDone];
    }];
}
-(void)startAuditLeaveDataRequest
{
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
    
    
    [SMAttendAuditLeaveRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
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
                    SMAttendLeaveModel *regModel = [[SMAttendLeaveModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
                    [_preferentialArray addObject:regModel];
                }
                //[_preferentialArray addObjectsFromArray:itemlist];
                
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
            [self startDataRequest];
        }
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        _isLoading = NO;
        [self refreshDataDone];
        [self loadMoreDataDone];
    }];
}

-(void)startRegDataRequest
{
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
    
    
    [SMAttendRegListRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
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
                    SMAttendRegModel *regModel = [[SMAttendRegModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
                    
                    [_preferentialArray addObject:regModel];
                }
                //[_preferentialArray addObjectsFromArray:itemlist];
                
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
            [self startDataRequest];
        }
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        _isLoading = NO;
        [self refreshDataDone];
        [self loadMoreDataDone];
    }];
}
-(void)startLeaveDataRequest
{
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
    
    
    [SMAttendLeaveListRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
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
                    SMAttendLeaveModel *regModel = [[SMAttendLeaveModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
                    [_preferentialArray addObject:regModel];
                }
                //[_preferentialArray addObjectsFromArray:itemlist];
                
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
            [self startDataRequest];
        }
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        _isLoading = NO;
        [self refreshDataDone];
        [self loadMoreDataDone];
    }];
}

/*============ ============ ============ ============ ============ ============ ============
            button list
====================== ============ ============ ============ ============ ============ ============ */
-(void) setChoiceType:(KaoQinOneChoiceTag)choiceTag
{
    [[UserManager sharedUserManager] setAttendType:choiceTag];
}

-(void)addAttendButtonsView
{
    return;
    
    CGRect frame = self.attendButtonView.frame;
    _attendButtonView = [SMAttendAuditButtonView loadFromXib];
    _attendButtonView.frame = frame;
    //_attendButtonView.top = _filterView.top + 3;
    _attendButtonView.delegate = self;
    
    [_attendButtonView setSelected:[[UserManager sharedUserManager] attendType]];
    [_attendButtonView setHidden:YES];
    [self.view addSubview:self.attendButtonView];
}
- (void)SMAttendAuditButtonViewButtonTapped:(int)idx
{
     //TODO: select button...
    [[UserManager sharedUserManager] setAttendType:idx];
    [self setToolbarTitle];
    _currentPage = 0;
    _notShowLoading = NO;
    //[_preferentialArray removeAllObjects];
    //[_tableView reloadData];
    [self startDataRequest];
}

/*====================== ============ ============ == end of button list ================ ============ ======*/



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
    return;
    
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
    [self startDataRequest];
    
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
    
    
    if ([[UserManager sharedUserManager] isAttendRegType]){
        SMAttendRegModel *model =[_preferentialArray objectAtIndex:[indexPath row]];
        return ![[model status] isEndWithString:@"通过"];
    }
    else if ([[UserManager sharedUserManager] isAttendLeaveType]){
        SMAttendLeaveModel *model =[_preferentialArray objectAtIndex:[indexPath row]];
        return ![[model status] isEndWithString:@"通过"];
    }
    else if ([[UserManager sharedUserManager] attendType] == kTagKaoQinOneChoiceMyTx){
        SMAttendTxModel *model =[_preferentialArray objectAtIndex:[indexPath row]];
        return ![[model status] isEndWithString:@"通过"];
    }
    
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
    if ([[UserManager sharedUserManager] isAttendAuditRegType]){
        return 58;
    }
    else if ([[UserManager sharedUserManager] isAttendAuditLeaveType]){
        return 70;
    }
    else if ([[UserManager sharedUserManager] isAttendRegType]){
        return 58;
    }
    else if ([[UserManager sharedUserManager] isAttendLeaveType]){
        return 70;
    }
    else if ([[UserManager sharedUserManager] attendType] == kTagKaoQinOneChoiceMyTx){
        return 74;
    }
    else if ([[UserManager sharedUserManager] attendType] == kTagKaoQinOneChoiceAuditTx){
        return 74;
    }
    return 62;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self performSegueWithIdentifier: @"showRecipeDetail" sender: self];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UserManager sharedUserManager] isAttendAuditRegType] || [[UserManager sharedUserManager] isAttendRegType]){
        
        static NSString *cellIdentifier = @"SMAttendRegCell";
        SMAttendRegCell *cell = (SMAttendRegCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            cell = [SMAttendRegCell cellFromNib];
            cell.cellDelegate = self;
        }
        cell.index = indexPath.row;
        [cell setBatchMode:self.batch_audit_status];
        
        //[cell selectedBackgroundView].backgroundColor =[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.f];
        
        [cell getDataSourceFromModel:[_preferentialArray objectAtIndex:indexPath.row] from:self];
        //[cell getDataSourceFromModel:[_preferentialArray objectAtIndex:indexPath.row]] ;
        
        return cell;
        
    }
    else if ([[UserManager sharedUserManager] isAttendAuditLeaveType] || [[UserManager sharedUserManager] isAttendLeaveType]){
        
        static NSString *cellIdentifier = @"SMAttendLeaveCell";
        SMAttendLeaveCell *cell = (SMAttendLeaveCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            cell = [SMAttendLeaveCell cellFromNib];
            cell.cellDelegate = self;
        }
        cell.index = indexPath.row;
        [cell setBatchMode:self.batch_audit_status];
        
        //[cell selectedBackgroundView].backgroundColor =[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.f];
        
        [cell getDataSourceFromModel:[_preferentialArray objectAtIndex:indexPath.row] from:self];
        //[cell getDataSourceFromModel:[_preferentialArray objectAtIndex:indexPath.row]] ;
        
        return cell;
    }
    else if ([[UserManager sharedUserManager] attendType] == kTagKaoQinOneChoiceMyTx || [[UserManager sharedUserManager] attendType] == kTagKaoQinOneChoiceAuditTx){
        static NSString *txCellIdentifier = @"SMAttendTxCell";
        SMAttendTxCell *cell = (SMAttendTxCell*)[tableView dequeueReusableCellWithIdentifier:txCellIdentifier];
        if (cell == nil){
            cell = [SMAttendTxCell cellFromNib];
        }
        cell.index = indexPath.row;
        [cell setBatchMode:self.batch_audit_status];
        
        //[cell selectedBackgroundView].backgroundColor =[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.f];
        
        [cell getDataSourceFromModel:[_preferentialArray objectAtIndex:indexPath.row] from:self];
        //[cell getDataSourceFromModel:[_preferentialArray objectAtIndex:indexPath.row]] ;
        
        return cell;
    }
    else if ([[UserManager sharedUserManager] isAttendRegType]){
        return nil;
    }
    else if ([[UserManager sharedUserManager] isAttendLeaveType]){
        return nil;
    }
    else{
        return nil;
    }
}


/*============ ============ ============ ============ ============ ============
 
    TableView cell callback
 
 ============ ============ ============ ============ ============ ============ */
- (void)SMAttendAuditRegCellButtonTapped:(SMAttendRegModel *)model index:(int)idx
{
    if (_batch_audit_status){
        //[_batchAuditIDList addObject:model.id];
        return;
    }
    
    _currentIndex = idx;
    
    if ([[UserManager sharedUserManager] isAttendAuditRegType]){
        NSLog(@"Cell Button Tapped: %@ ", model);
        
        if (_newsPickWindow == nil) {
            self.newsPickWindow = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
            CALayer *hudLayer = [CALayer layer];
            hudLayer.frame = CGRectMake(0, 0, _newsPickWindow.width, _newsPickWindow.height);
            hudLayer.backgroundColor = [UIColor blackColor].CGColor;
            hudLayer.opacity = 0.6;
            
            _newsPickWindow.backgroundColor = [UIColor clearColor];
            _newsPickWindow.windowLevel =UIWindowLevelNormal;
            _newsPickWindow.alpha =1.f;
            _newsPickWindow.hidden =NO;
            [_newsPickWindow.layer addSublayer:hudLayer];
            self.auditRegPickView = [ITTXibViewUtils loadViewFromXibNamed:@"SMAuditingRegPickView"];
            [_newsPickWindow addSubview:_auditRegPickView];
            
            UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
            tapGestureR.cancelsTouchesInView = NO;
            [[_auditLeavePickWindow superview] addGestureRecognizer:tapGestureR];
        }
        [_auditRegPickView auditingRegData:model];
        [_newsPickWindow makeKeyAndVisible];
        [_auditRegPickView showAuditingRegPickViewWithFinishBlock:^(SMAttendRegModel *regModel, int optype, NSString *opinion) {
            AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
            [[appDelegate window] makeKeyAndVisible];
            [self.newsPickWindow setHidden:YES];
            
            NSLog(@"pick return optype: %d", optype);
            
            //[self ToAuditingReg:regModel operType:optype opinion:opinion];
            [self RegAuditVerfiy:regModel operType:optype opinion:opinion];
            
        }];
    
    } //end of if isAttendAuditRegType
    
    
    else if ([[UserManager sharedUserManager] isAttendRegType]){
        //todo Edit reg  .....
        [self editReg:model];
    }
}

//审核－未打卡
-(void)RegAuditVerfiy:(SMAttendRegModel*)model operType:(int)ot opinion:(NSString*)opinion
{
    if (ot == -1)
        return;
    self.curOperType = ot;
    self.curOpinion = opinion;
    
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        NSString *userid = [[UserManager sharedUserManager] userId];
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"id":[model id],
                                 @"datasetcode": @"synverify_register",
                                 @"updatetime":model.updatetime
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        [SMAttendAuditVerfiyRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            if(!_notShowLoading){
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            }
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                NSArray *itemlist = [request.handleredResult objectForKey:@"data"];
                SMAuditVerfiyModel *ver = [[SMAuditVerfiyModel alloc]initWithDataDic: [itemlist objectAtIndex:0]];
                if ([[ver num] isEqualToString:@"1"]){
                    //[_preferentialArray objectAtIndex:_currentIndex]
                    [self ToAuditingReg:model operType:self.curOperType opinion:self.curOpinion];
                }
                else{
                    [PROMPT_VIEW showMessage:@"已审核"];
                }
            }
            else{
                [PROMPT_VIEW showMessage:@"网络不给力啊！验证是否审批没成功！再试试吧。"];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
            [PROMPT_VIEW hidden];
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            [PROMPT_VIEW hidden];
        }];
        
    }];
    
}
-(void)ToAuditingReg:(SMAttendRegModel*)model operType:(int)ot opinion:(NSString*)opinion
{
    if (ot == -1)
        return;
    
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        NSString *userid = [[UserManager sharedUserManager] userId];
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"registerids":[model id],
                                 @"status":[NSString stringWithFormat:@"%d", ot],
                                 @"opinion":opinion
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        [SMAttendAuditingRegRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            if(!_notShowLoading){
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            }
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                if (ot == 0) {
                    model.status = @"通过";
                }
                else if (ot == 1){
                    model.status = @"不通过";
                }
                _preferentialArray[_currentIndex] = model;
                [_tableView reloadData];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            _isLoading = NO;
            [self refreshDataDone];
            [self loadMoreDataDone];
        }];
        
    }];
    
}



- (void)SMAttendAuditLeaveCellButtonTapped:(SMAttendLeaveModel *)model index:(int)idx
{
    if (_batch_audit_status){
        return;
    }
    
    _currentIndex = idx;
    
    if ([[UserManager sharedUserManager] isAttendAuditLeaveType]){
        NSLog(@"Cell Button Tapped: %@ ", model);
        
        if (_auditLeavePickWindow == nil) {
            self.auditLeavePickWindow = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
            CALayer *hudLayer = [CALayer layer];
            hudLayer.frame = CGRectMake(0, 0, _auditLeavePickWindow.width, _auditLeavePickWindow.height);
            hudLayer.backgroundColor = [UIColor blackColor].CGColor;
            hudLayer.opacity = 0.6;
            
            _auditLeavePickWindow.backgroundColor = [UIColor clearColor];
            _auditLeavePickWindow.windowLevel =UIWindowLevelNormal;
            _auditLeavePickWindow.alpha =1.f;
            _auditLeavePickWindow.hidden =NO;
            [_auditLeavePickWindow.layer addSublayer:hudLayer];
            self.auditLeavePickView = [ITTXibViewUtils loadViewFromXibNamed:@"SMAuditingLeavePickView"];
            [_auditLeavePickWindow addSubview:_auditLeavePickView];
            
            UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
            tapGestureR.cancelsTouchesInView = NO;
            [[_auditLeavePickWindow superview] addGestureRecognizer:tapGestureR];
            
        }
        [_auditLeavePickView auditingLeaveData:model];
        [_auditLeavePickWindow makeKeyAndVisible];
        [_auditLeavePickView showAuditingLeavePickViewWithFinishBlock:^(SMAttendLeaveModel *regModel, int optype, NSString *opinion) {
            AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
            [[appDelegate window] makeKeyAndVisible];
            [self.auditLeavePickWindow setHidden:YES];
            
            NSLog(@"pick return optype: %d", optype);
            if (!_batch_audit_status){
                [self ToAuditingLeave:regModel operType:optype opinion:opinion];
            }
            else{
                [_batchAuditIDList addObject:regModel.id];
            }
            /*
             NSString *apnsId = [[UserManager sharedUserManager] apnsId];
             [[AppDelegate GetAppDelegate] postDeviceTokenAndUserInfo:apnsId isOpen:[[UserManager sharedUserManager] needNotificaionMsg]];
             [appDelegate resetTabs];
             */
            
        }];
    
    } //end of if
    
    else if ([[UserManager sharedUserManager] isAttendLeaveType]){
        //todo Edit reg  .....
        [self editLeave:model];
    }
    
}
-(void)ToAuditingLeave:(SMAttendLeaveModel*)model operType:(int)ot opinion:(NSString*)opinion
{
    if (ot == -1)
        return;
    
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        NSString *userid = [[UserManager sharedUserManager] userId];
        
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"id":[model id],
                                 @"datasetcode": @"synverify-leave",
                                 @"updatetime":model.updatetime
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        [SMAttendAuditVerfiyRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            if(!_notShowLoading){
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            }
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                NSArray *itemlist = [request.handleredResult objectForKey:@"data"];
                SMAuditVerfiyModel *ver = [[SMAuditVerfiyModel alloc]initWithDataDic: [itemlist objectAtIndex:0]];
                if ([[ver num] isEqualToString:@"1"]){
                    
                    //--------post to server-----------
                    NSDictionary *params = @{
                                             @"userid":userid,
                                             @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                             @"leaveids":[model id],
                                             @"status":[NSString stringWithFormat:@"%d", ot],
                                             @"opinion":opinion
                                             };
                    ITTDINFO(@"request params :[%@]" ,params);
                    
                    [SMAttendAuditingLeaveRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                        NSLog(@"start loading");
                        if(!_notShowLoading){
                            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
                        }
                    } onRequestFinished:^(ITTBaseDataRequest *request) {
                        if (request.isSuccess) {
                            if (ot == 0) {
                                model.status = @"通过";
                            }
                            else if (ot == 1){
                                model.status = @"不通过";
                            }
                            _preferentialArray[_currentIndex] = model;
                            [_tableView reloadData];
                        }
                    } onRequestCanceled:^(ITTBaseDataRequest *request) {
                    } onRequestFailed:^(ITTBaseDataRequest *request) {
                        _isLoading = NO;
                        [self refreshDataDone];
                        [self loadMoreDataDone];
                    }];
                    //------end of ------------
                    
                }
                else{
                    [PROMPT_VIEW showMessage:@"已审核"];
                }
            }
            else{
                [PROMPT_VIEW showActivityWithMask:@"网络不给力啊！验证是否审批没成功！再试试吧。"];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
            //[PROMPT_VIEW hidden];
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            //[PROMPT_VIEW hidden];
            
        }];
        
        
        
    }];
}

- (void)SMAttendTxCellButtonTapped:(SMAttendTxModel *)model index:(int)idx
{
    if (_batch_audit_status){
        return;
    }
    
    _currentIndex = idx;
    
    if ([[UserManager sharedUserManager] attendType] == kTagKaoQinOneChoiceMyTx){
        NSLog(@"Cell Button Tapped: %@ ", model);
        
        [self editTx:model];
    }
    else if ([[UserManager sharedUserManager] attendType] == kTagKaoQinOneChoiceAuditTx){
        //todo audit tx  .....
        [self auditTx:model];
    }
}

/*============ ============ end of cell callback ============ ====================== ============ ============ */

-(void) setToolbarTitle
{
    self.batch_audit_status = false;
    [_editButton setTitle:@"批审" forState:UIControlStateNormal];
    [_batchAuditPanel setHidden:YES];
    int attendType = [[UserManager sharedUserManager] attendType];
    switch (attendType) {
        case kTagKaoQinOneChoiceMyReg:{
            [_titleLabel setText:@"我的未打卡"];
            [_titleLabel setHidden:NO];
            [_editButton setHidden:NO];
            [_editButton setTitle:@"申请" forState:UIControlStateNormal];
        }
            break;
        case kTagKaoQinOneChoiceMyLeave:{
            [_titleLabel setText:@"我的请假"];
            [_titleLabel setHidden:NO];
            [_editButton setHidden:NO];
            [_editButton setTitle:@"申请" forState:UIControlStateNormal];
        }
            break;
        case kTagKaoQinOneChoiceAuditReg:{
            [_titleLabel setText:@"未打卡待审核"];
            [_titleLabel setHidden:NO];
            [_editButton setHidden:NO];
        }
            break;
        case kTagKaoQinOneChoiceAuditLeave:{
            [_titleLabel setText:@"请假待审核"];
            [_titleLabel setHidden:NO];
            [_editButton setHidden:NO];
        }
            break;
        case kTagKaoQinOneChoiceMyTx:{
            [_titleLabel setText:@"我的调休"];
            [_editButton setTitle:@"申请" forState:UIControlStateNormal];
            [_titleLabel setHidden:NO];
            [_editButton setHidden:NO];
        }
            break;
        case kTagKaoQinOneChoiceAuditTx:{
            [_titleLabel setText:@"调休申请审核"];
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
    _currentIndex = -1;
    int attendType = [[UserManager sharedUserManager] attendType];
    switch (attendType) {
        case kTagKaoQinOneChoiceMyReg:{
            [self addNewReg];
        }
            break;
        case kTagKaoQinOneChoiceMyLeave:{
            [self addNewLeave];
        }
            break;
        case kTagKaoQinOneChoiceMyTx:{
            [self addNewTx];
        }
            break;
        case kTagKaoQinOneChoiceAuditReg:{
            [self batchSelect:attendType];
        }
            break;
        case kTagKaoQinOneChoiceAuditLeave:{
            [self batchSelect:attendType];
        }
            break;
        case kTagKaoQinOneChoiceAuditTx:{
            //[self batchSelect:attendType];
        }
            break;
        default:
        {
            
        }
            break;
    }
}


//-------------------------------------------------------//
//   batch       批量操作选择
//-------------------------------------------------------//

-(void)batchSelect:(int)type
{
    [_optionTextField resignFirstResponder];
    
    if (_batchAuditIDList == NULL){
        _batchAuditIDList = [NSMutableArray array];
    }
    [_batchAuditIDList removeAllObjects];
    self.batch_audit_status = !self.batch_audit_status;
    if (self.batch_audit_status == false){
        [_editButton setTitle:@"批审" forState:UIControlStateNormal];
        [_batchAuditPanel setHidden:YES];
        _tableView.top -= _batchAuditPanel.height;
        _tableView.height += _batchAuditPanel.height;
        [_tableView reloadData];
    }
    else {
        [_editButton setTitle:@"取消" forState:UIControlStateNormal];
        [_batchAuditPanel setHidden:NO];
        _tableView.top += _batchAuditPanel.height;
        _tableView.height -= _batchAuditPanel.height;
        [_tableView reloadData];
    }

    if (type == kTagKaoQinOneChoiceAuditReg){
        
        return;
    }
    
    if (type == kTagKaoQinOneChoiceAuditLeave){
        
        return;
    }
    
    if (type == kTagKaoQinOneChoiceAuditTx){
        
        return;
    }
}

- (IBAction)cancelBatchAuditingButtonDid:(id)sender {
    [self editButtonDidClicked:NULL];
    [_optionTextField resignFirstResponder];
}


- (IBAction)batchButtonDidClick:(id)sender {
    int attendType = [[UserManager sharedUserManager] attendType];
    switch (attendType) {
        case kTagKaoQinOneChoiceMyReg:{
            
        }
            break;
        case kTagKaoQinOneChoiceMyLeave:{
            
        }
            break;
        case kTagKaoQinOneChoiceMyTx:{
            
        }
            break;
        case kTagKaoQinOneChoiceAuditReg:{
            [self batchAuditingReg];
        }
            break;
        case kTagKaoQinOneChoiceAuditLeave:{
            [self batchAuditingLeave];
        }
            break;
        case kTagKaoQinOneChoiceAuditTx:{
            //[self batchAuditingTx];
        }
            break;
        default:
        {
            
        }
            break;
    }
    
    
}

-(void)batchAuditingReg
{
    [_optionTextField resignFirstResponder];
    NSString *status = [_statusSelectControl titleForSegmentAtIndex:[ _statusSelectControl selectedSegmentIndex]];
    NSString *opinion = [_optionTextField text];
    NSString *ids = @"";
    NSString *updatetimes = @"";
    for (int i=0; i<[_preferentialArray count]; i++) {
        SMAttendRegModel *regModel = [_preferentialArray objectAtIndex:i];
        if (regModel.isSelected){
            if ([ids length] > 0){
                ids = [ids stringByAppendingString:@","];
                updatetimes = [updatetimes stringByAppendingString:@","];
            }
            ids = [ids stringByAppendingString:regModel.id];
            updatetimes = [updatetimes stringByAppendingString:regModel.updatetime];
        }
    }
    
    if ([opinion length] == 0){
        if ([_statusSelectControl selectedSegmentIndex] == 0){
            opinion = @"同意";
        }
        else{
            opinion = @"不同意";
        }
    }
    
    if ([ids length] == 0){
        [PROMPT_VIEW showMessage:@"请先选择批审项, 点击列表项可选中或取消"];
        return;
    }
    
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        NSString *userid = [[UserManager sharedUserManager] userId];
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"status":status,
                                 @"opinion":opinion,
                                 @"staffId":ids,
                                 @"updatetime": updatetimes,
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        [SMAttendAuditingBatchRegRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                [_editButton setTitle:@"批审" forState:UIControlStateNormal];
                [_batchAuditPanel setHidden:YES];
                _currentPage = 0;
                _notShowLoading = YES;
                [self startDataRequest];
            }
            else{
                [PROMPT_VIEW showMessage:@"审核失败，请重试"];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
            [PROMPT_VIEW showMessage:@"审核被取消"];
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            [PROMPT_VIEW showMessage:@"审核不成功，请重试"];
        }];
        
    }];
}

-(void)batchAuditingLeave
{
    [_optionTextField resignFirstResponder];
    NSString *status = [_statusSelectControl titleForSegmentAtIndex:[ _statusSelectControl selectedSegmentIndex]];
    NSString *opinion = [_optionTextField text];
    NSString *ids = @"";
    NSString *updatetimes = @"";
    for (int i=0; i<[_preferentialArray count]; i++) {
        SMAttendLeaveModel *regModel = [_preferentialArray objectAtIndex:i];
        if (regModel.isSelected){
            if ([ids length] > 0){
                ids = [ids stringByAppendingString:@","];
                updatetimes = [updatetimes stringByAppendingString:@","];
            }
            ids = [ids stringByAppendingString:regModel.id];
            updatetimes = [updatetimes stringByAppendingString:regModel.updatetime];
        }
    }
    
    if ([opinion length] == 0){
        if ([_statusSelectControl selectedSegmentIndex] == 0){
            opinion = @"同意";
        }
        else{
            opinion = @"不同意";
        }
    }
    
    if ([ids length] == 0){
        [PROMPT_VIEW showMessage:@"请先选择批审项, 点击列表项可选中或取消"];
        return;
    }
    
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        NSString *userid = [[UserManager sharedUserManager] userId];
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"status":status,
                                 @"opinion":opinion,
                                 @"staffId":ids,
                                 @"updatetime": updatetimes,
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        [SMAttendAuditingBatchLeaveRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                [_editButton setTitle:@"批审" forState:UIControlStateNormal];
                [_batchAuditPanel setHidden:YES];
                _currentPage = 0;
                _notShowLoading = YES;
                [self startDataRequest];
            }
            else{
                [PROMPT_VIEW showMessage:@"审核失败，请重试"];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
            [PROMPT_VIEW showMessage:@"审核被取消"];
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            [PROMPT_VIEW showMessage:@"审核不成功，请重试"];
        }];
        
    }];
}

-(void)batchAuditingTx
{
    
}
//-------------------------------------------------------//
//          新增按钮
//-------------------------------------------------------//

-(void)editLeave:(SMAttendLeaveModel*)model
{
    if (model == nil){return;}
    if ([model.status isEndWithString:@"通过"]) {
        //return;
    }
    
    if (_editLeavePickWindow == nil) {
        self.editLeavePickWindow = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
        CALayer *hudLayer = [CALayer layer];
        hudLayer.frame = CGRectMake(0, 0, _editLeavePickWindow.width, _editLeavePickWindow.height);
        hudLayer.backgroundColor = [UIColor blackColor].CGColor;
        hudLayer.opacity = 0.6;
        
        _editLeavePickWindow.backgroundColor = [UIColor clearColor];
        _editLeavePickWindow.windowLevel =UIWindowLevelNormal;
        _editLeavePickWindow.alpha =1.f;
        _editLeavePickWindow.hidden =NO;
        [_editLeavePickWindow.layer addSublayer:hudLayer];
        self.editLeavePickView = [ITTXibViewUtils loadViewFromXibNamed:@"SMEditLeavePickView"];
        [_editLeavePickWindow addSubview:_editLeavePickView];
        
        UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        tapGestureR.cancelsTouchesInView = NO;
        [[_editLeavePickWindow superview] addGestureRecognizer:tapGestureR];
    }
    
    [_editLeavePickWindow makeKeyAndVisible];
    [_editLeavePickView editLeaveData:model];
    [_editLeavePickView showEditLeavePickViewWithFinishBlock:^(SMAttendLeaveModel *model, int optype, NSString *opinion) {
        AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
        [[appDelegate window] makeKeyAndVisible];
        [self.editLeavePickWindow setHidden:YES];
        
        NSLog(@"pick return optype: %d", optype);
        
        if (optype >= 0){
            [self editAttendLeave:model optype:[NSString stringWithFormat:@"%d", optype]];
        }
        
    }];
}
-(void)addNewLeave
{
    if (_editLeavePickWindow == nil) {
        self.editLeavePickWindow = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
        CALayer *hudLayer = [CALayer layer];
        hudLayer.frame = CGRectMake(0, 0, _editLeavePickWindow.width, _editLeavePickWindow.height);
        hudLayer.backgroundColor = [UIColor blackColor].CGColor;
        hudLayer.opacity = 0.6;
        
        _editLeavePickWindow.backgroundColor = [UIColor clearColor];
        _editLeavePickWindow.windowLevel =UIWindowLevelNormal;
        _editLeavePickWindow.alpha =1.f;
        _editLeavePickWindow.hidden =NO;
        [_editLeavePickWindow.layer addSublayer:hudLayer];
        self.editLeavePickView = [ITTXibViewUtils loadViewFromXibNamed:@"SMEditLeavePickView"];
        [_editLeavePickWindow addSubview:_editLeavePickView];
        
        UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        tapGestureR.cancelsTouchesInView = NO;
        [[_editLeavePickWindow superview] addGestureRecognizer:tapGestureR];
    }
    
    [_editLeavePickWindow makeKeyAndVisible];
    [_editLeavePickView editLeaveData:nil];
    [_editLeavePickView showEditLeavePickViewWithFinishBlock:^(SMAttendLeaveModel *model, int optype, NSString *opinion) {
        AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
        [[appDelegate window] makeKeyAndVisible];
        [self.editLeavePickWindow setHidden:YES];
        
        NSLog(@"pick return optype: %d", optype);
        
        if (optype >= 0){
            [self AddNewAttendLeave:model optype:[NSString stringWithFormat:@"%d", optype]];
        }
        
    }];
}

-(void)AddNewAttendLeave:(SMAttendLeaveModel *)model optype:(NSString*)status
{
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        NSString *userid = [[UserManager sharedUserManager] userId];
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"type": model.type,
                                 @"starttime":model.startTime,
                                 @"endtime":model.endTime,
                                 @"reason":model.reason,
                                 @"sumtime":model.sumTime,
                                 @"status":status
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        
        [SMAttendSaveLeaveRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                //[_preferentialArray addObject:regModel];
                //[_tableView reloadData];
                _currentPage = 0;
                _notShowLoading = YES;
                [self startDataRequest];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            
        }];
    }];
}
-(void)editAttendLeave:(SMAttendLeaveModel *)model optype:(NSString*)status
{
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        
        if ([status isEqualToString:@"100"]){
            NSString *userid = [[UserManager sharedUserManager] userId];
            NSDictionary *params = @{
                                     @"userid":userid,
                                     @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                     @"id":model.id,
                                     };
            ITTDINFO(@"request params :[%@]" ,params);
            
            [SMAttendRemoveLeaveRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                NSLog(@"start loading for remove row");
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            } onRequestFinished:^(ITTBaseDataRequest *request) {
                if (request.isSuccess) {
                    [_preferentialArray removeObjectAtIndex:_currentIndex];
                    _currentIndex=-1;
                    [self.tableView reloadData];
                }
                else{
                    
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
                [PROMPT_VIEW showMessage:@"删除未能完成"];
            }];
        }
        else{
            NSString *userid = [[UserManager sharedUserManager] userId];
            NSDictionary *params = @{
                                     @"userid":userid,
                                     @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                     @"type": model.type,
                                     @"starttime":model.startTime,
                                     @"endtime":model.endTime,
                                     @"reason":model.reason,
                                     @"sumtime":model.sumTime,
                                     @"status":status,
                                     @"id":model.id
                                     };
            ITTDINFO(@"request params :[%@]" ,params);
            
            
            [SMAttendSaveLeaveRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                NSLog(@"start loading");
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            } onRequestFinished:^(ITTBaseDataRequest *request) {
                if (request.isSuccess) {
                    //[_preferentialArray addObject:regModel];
                    //[_tableView reloadData];
                    _currentPage = 0;
                    _notShowLoading = YES;
                    [self startDataRequest];
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
                
            }];
        }
        
    }];
}



-(void)editReg:(SMAttendRegModel*)model
{
    if (model == nil){return;}
    if ([model.status isEndWithString:@"通过"]) {
        //return;
    }
    
    if (_editRegPickWindow == nil) {
        self.editRegPickWindow = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
        CALayer *hudLayer = [CALayer layer];
        hudLayer.frame = CGRectMake(0, 0, _editRegPickWindow.width, _editRegPickWindow.height);
        hudLayer.backgroundColor = [UIColor blackColor].CGColor;
        hudLayer.opacity = 0.6;
        
        _editRegPickWindow.backgroundColor = [UIColor clearColor];
        _editRegPickWindow.windowLevel =UIWindowLevelNormal;
        _editRegPickWindow.alpha =1.f;
        _editRegPickWindow.hidden =NO;
        [_editRegPickWindow.layer addSublayer:hudLayer];
        self.editRegPickView = [ITTXibViewUtils loadViewFromXibNamed:@"SMEditRegPickView"];
        [_editRegPickWindow addSubview:_editRegPickView];
        
        UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        tapGestureR.cancelsTouchesInView = NO;
        [[_editRegPickWindow superview] addGestureRecognizer:tapGestureR];
    }
    
    [_editRegPickWindow makeKeyAndVisible];
    [_editRegPickView editRegData:model];
    [_editRegPickView showEditRegPickViewWithFinishBlock:^(SMAttendRegModel *regModel, int optype, NSString *opinion) {
        AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
        [[appDelegate window] makeKeyAndVisible];
        [self.editRegPickWindow setHidden:YES];
        
        NSLog(@"pick return optype: %d", optype);
        
        if (optype >= 0){
            [self EditAttendReg:model optype:[NSString stringWithFormat:@"%d", optype]];
        }
        
    }];
}

-(void)addNewReg
{
    if (_editRegPickWindow == nil) {
        self.editRegPickWindow = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
        CALayer *hudLayer = [CALayer layer];
        hudLayer.frame = CGRectMake(0, 0, _editRegPickWindow.width, _editRegPickWindow.height);
        hudLayer.backgroundColor = [UIColor blackColor].CGColor;
        hudLayer.opacity = 0.6;
        
        _editRegPickWindow.backgroundColor = [UIColor clearColor];
        _editRegPickWindow.windowLevel =UIWindowLevelNormal;
        _editRegPickWindow.alpha =1.f;
        _editRegPickWindow.hidden =NO;
        [_editRegPickWindow.layer addSublayer:hudLayer];
        self.editRegPickView = [ITTXibViewUtils loadViewFromXibNamed:@"SMEditRegPickView"];
        [_editRegPickWindow addSubview:_editRegPickView];
        
        UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        tapGestureR.cancelsTouchesInView = NO;
        [[_editRegPickWindow superview] addGestureRecognizer:tapGestureR];
    }
    
    [_editRegPickWindow makeKeyAndVisible];
    [_editRegPickView editRegData:nil];
    [_editRegPickView showEditRegPickViewWithFinishBlock:^(SMAttendRegModel *regModel, int optype, NSString *opinion) {
        AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
        [[appDelegate window] makeKeyAndVisible];
        [self.editRegPickWindow setHidden:YES];
        
        NSLog(@"pick return optype: %d", optype);
        
        if (optype >= 0){
            [self AddNewAttendReg:regModel optype:[NSString stringWithFormat:@"%d", optype]];
        }
        
    }];
}

-(void)AddNewAttendReg:(SMAttendRegModel *)regModel optype:(NSString*)status
{
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        
            NSString *userid = [[UserManager sharedUserManager] userId];
            NSDictionary *params = @{
                                     @"userid":userid,
                                     @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                     @"date":regModel.date,
                                     @"time":regModel.time,
                                     @"reason":regModel.reason,
                                     @"status":status
                                     };
            ITTDINFO(@"request params :[%@]" ,params);
            
            
            [SMAttendSaveRegRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                NSLog(@"start loading");
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            } onRequestFinished:^(ITTBaseDataRequest *request) {
                if (request.isSuccess) {
                    //[_preferentialArray addObject:regModel];
                    //[_tableView reloadData];
                    _currentPage = 0;
                    _notShowLoading = YES;
                    [self startDataRequest];
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
                
            }];
        
        
    }];
}

-(void)EditAttendReg:(SMAttendRegModel *)regModel optype:(NSString*)status
{
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        
        if ([status isEqualToString:@"100"]){
            
            NSString *userid = [[UserManager sharedUserManager] userId];
            NSDictionary *params = @{
                                     @"userid":userid,
                                     @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                     @"id":regModel.id,
                                     };
            ITTDINFO(@"request params :[%@]" ,params);
            
            [SMAttendRemoveRegRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                NSLog(@"start loading for remove row");
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            } onRequestFinished:^(ITTBaseDataRequest *request) {
                if (request.isSuccess) {
                    [_preferentialArray removeObjectAtIndex:_currentIndex];
                    _currentIndex=-1;
                    [self.tableView reloadData];
                }
                else{
                    
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
                [PROMPT_VIEW showMessage:@"删除未能完成"];
            }];
            
        }
        else{
            NSString *userid = [[UserManager sharedUserManager] userId];
            NSDictionary *params = @{
                                     @"userid":userid,
                                     @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                     @"date":regModel.date,
                                     @"time":regModel.time,
                                     @"reason":regModel.reason,
                                     @"status":status,
                                     @"id":regModel.id,
                                     };
            ITTDINFO(@"request params :[%@]" ,params);
            
            
            [SMAttendSaveRegRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                NSLog(@"start loading");
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            } onRequestFinished:^(ITTBaseDataRequest *request) {
                if (request.isSuccess) {
                    //[_preferentialArray addObject:regModel];
                    //[_tableView reloadData];
                    _currentPage = 0;
                    _notShowLoading = YES;
                    [self startDataRequest];
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
                
            }];
        }
        
    }];
}



//-----edit tx --------
-(void)editTx:(SMAttendTxModel*)model{
    
    if (model != nil){
        if ([model.status intValue] >= 2){
            //return;
        }
    }
    
    if (_editTxPickWindow == nil) {
        self.editTxPickWindow = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
        CALayer *hudLayer = [CALayer layer];
        hudLayer.frame = CGRectMake(0, 0, _editTxPickWindow.width, _editTxPickWindow.height);
        hudLayer.backgroundColor = [UIColor blackColor].CGColor;
        hudLayer.opacity = 0.6;
        
        _editTxPickWindow.backgroundColor = [UIColor clearColor];
        _editTxPickWindow.windowLevel =UIWindowLevelNormal;
        _editTxPickWindow.alpha =1.f;
        _editTxPickWindow.hidden =NO;
        [_editTxPickWindow.layer addSublayer:hudLayer];
        self.editTxPickView = [ITTXibViewUtils loadViewFromXibNamed:@"SMEditTxPickView"];
        [_editTxPickWindow addSubview:_editTxPickView];
        
        UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        tapGestureR.cancelsTouchesInView = NO;
        [[_editTxPickWindow superview] addGestureRecognizer:tapGestureR];
    }
    
    [_editTxPickWindow makeKeyAndVisible];
    [_editTxPickView editData:model];
    [_editTxPickView showEditTxPickViewWithFinishBlock:^(SMAttendTxModel *model, int optype, NSString *opinion) {
        AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
        [[appDelegate window] makeKeyAndVisible];
        [self.editTxPickWindow setHidden:YES];
        
        NSLog(@"pick return optype: %d", optype);
        
        if (optype >= 0){
            [self AddNewAttendTx:model optype:[NSString stringWithFormat:@"%d", optype]];
        }
        
    }];
}
-(void)addNewTx
{
    [self editTx:nil];
}
-(void)AddNewAttendTx:(SMAttendTxModel *)model optype:(NSString*)status
{
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        NSString *userid = [[UserManager sharedUserManager] userId];
        if (IS_STRING_EMPTY(model.id)){
            NSDictionary *params = @{
                                     @"userid":userid,
                                     @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                     @"extraworkTime":model.extraworkTime,
                                     @"extraworkDate":model.extraworkDate,
                                     @"restDate":model.restDate,
                                     @"restTime":model.restTime,
                                     @"remark":model.remark,
                                     @"status":status
                                     };
            ITTDINFO(@"request params :[%@]" ,params);
            
            [SMAttendSaveTxRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                NSLog(@"start loading");
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            } onRequestFinished:^(ITTBaseDataRequest *request) {
                if (request.isSuccess) {
                    _currentPage = 0;
                    _notShowLoading = YES;
                    [self startDataRequest];
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
                
            }];
        }
        else{
            
            if ([status isEqualToString:@"100"]){
                NSString *userid = [[UserManager sharedUserManager] userId];
                NSDictionary *params = @{
                                         @"userid":userid,
                                         @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                         @"id":model.id,
                                         };
                ITTDINFO(@"request params :[%@]" ,params);
                
                [SMAttendRemoveTxRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                    NSLog(@"start loading for remove row");
                    [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
                } onRequestFinished:^(ITTBaseDataRequest *request) {
                    if (request.isSuccess) {
                        [_preferentialArray removeObjectAtIndex:_currentIndex];
                        _currentIndex=-1;
                        [self.tableView reloadData];
                    }
                    else{
                        
                    }
                } onRequestCanceled:^(ITTBaseDataRequest *request) {
                } onRequestFailed:^(ITTBaseDataRequest *request) {
                    [PROMPT_VIEW showMessage:@"删除未能完成"];
                }];
            }
            else{
                //update ...
                NSDictionary *params = @{
                                         @"userid":userid,
                                         @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                         @"extraworkTime":model.extraworkTime,
                                         @"extraworkDate":model.extraworkDate,
                                         @"restDate":model.restDate,
                                         @"restTime":model.restTime,
                                         @"remark":model.remark,
                                         @"status":status,
                                         @"id":model.id
                                         };
                ITTDINFO(@"request params :[%@]" ,params);
                
                
                [SMAttendSaveTxRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                    NSLog(@"start loading");
                    [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
                } onRequestFinished:^(ITTBaseDataRequest *request) {
                    if (request.isSuccess) {
                        _currentPage = 0;
                        _notShowLoading = YES;
                        [self startDataRequest];
                    }
                } onRequestCanceled:^(ITTBaseDataRequest *request) {
                } onRequestFailed:^(ITTBaseDataRequest *request) {
                    
                }];
            }
            
        }
    }];
}
//-----end of edit tx --------

//-------audit tx --------

-(void)auditTx:(SMAttendTxModel*)model{
    
    if (model != nil){
        if ([model.status intValue] >= 2){
            return;
        }
    }
    
    if (_pickWindow == nil) {
        self.pickWindow = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
        CALayer *hudLayer = [CALayer layer];
        hudLayer.frame = CGRectMake(0, 0, _pickWindow.width, _pickWindow.height);
        hudLayer.backgroundColor = [UIColor blackColor].CGColor;
        hudLayer.opacity = 0.6;
        
        _pickWindow.backgroundColor = [UIColor clearColor];
        _pickWindow.windowLevel =UIWindowLevelNormal;
        _pickWindow.alpha =1.f;
        _pickWindow.hidden =NO;
        [_pickWindow.layer addSublayer:hudLayer];
        
        UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        tapGestureR.cancelsTouchesInView = NO;
        [[_pickWindow superview] addGestureRecognizer:tapGestureR];
    }
    
    if (self.auditTxPickView == nil){
        self.auditTxPickView = [ITTXibViewUtils loadViewFromXibNamed:@"SMAuditTxPickView"];
        _auditTxPickView.tag =  kTagKaoQinPickViewAuditTx;
        [_pickWindow addSubview:_auditTxPickView];
    }
    
    [_pickWindow bringSubviewToFront:[_pickWindow viewWithTag:kTagKaoQinPickViewAuditTx]];
    [_pickWindow makeKeyAndVisible];
    
    [_auditTxPickView editData:model];
    [_auditTxPickView showTxPickViewWithFinishBlock:^(SMAttendTxModel *model, int optype, NSString *opinion) {
        AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
        [[appDelegate window] makeKeyAndVisible];
        [self.pickWindow setHidden:YES];
        
        NSLog(@"pick return optype: %d", optype);
        
        if (!_batch_audit_status){
            if (optype >= 0){
                [self auditAttendTx:model optype:[NSString stringWithFormat:@"%d", optype]];
            }
        }
        else{
            [_batchAuditIDList addObject:model.id];
        }
        
    }];
}

-(void)auditAttendTx:(SMAttendTxModel *)model optype:(NSString*)status
{
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        NSString *userid = [[UserManager sharedUserManager] userId];
        
        //verfiy ...
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"id":model.id,
                                 @"updatetime":model.updatetime,
                                 @"datasetcode": @"synverify_daoxiu"
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        [SMAttendAuditVerfiyRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            if(!_notShowLoading){
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            }
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                NSArray *itemlist = [request.handleredResult objectForKey:@"data"];
                SMAuditVerfiyModel *ver = [[SMAuditVerfiyModel alloc]initWithDataDic: [itemlist objectAtIndex:0]];
                if ([[ver num] isEqualToString:@"1"]){
                    
                    //[self ToAuditingReg:model operType:self.curOperType opinion:self.curOpinion];
                    //-----------------------------
                    NSDictionary *params = @{
                                             @"userid":userid,
                                             @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                             @"id":model.id,
                                             @"opinion":model.opinion,
                                             @"status":status
                                             };
                    ITTDINFO(@"request params :[%@]" ,params);
                    
                    [SMAttendAuditTxRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                        NSLog(@"start loading");
                        [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
                    } onRequestFinished:^(ITTBaseDataRequest *request) {
                        if (request.isSuccess) {
                            _currentPage = 0;
                            _notShowLoading = YES;
                            [self startDataRequest];
                        }
                    } onRequestCanceled:^(ITTBaseDataRequest *request) {
                    } onRequestFailed:^(ITTBaseDataRequest *request) {
                        
                    }];
                    //------end of ----------------
                }
                else{
                    [PROMPT_VIEW showMessage:@"已审核"];
                }
            }
            else{
                [PROMPT_VIEW showMessage:@"网络不给力啊！验证是否审批没成功！再试试吧。"];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
            [PROMPT_VIEW hidden];
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            [PROMPT_VIEW hidden];
        }];
        
    }];
}
//------- end of audit tx -----------




-(void)removeRow:(int)id
{
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
         if ([[UserManager sharedUserManager] isAttendLeaveType]){
            SMAttendLeaveModel *model = [_preferentialArray objectAtIndex:_selectedRow];
            if (![[model status] isEndWithString:@"通过"]){
                
            }
        }
        else if ([[UserManager sharedUserManager] attendType] == kTagKaoQinOneChoiceMyTx){
            [self startTxDataRequest];
        }
        else if ([[UserManager sharedUserManager] attendType] == kTagKaoQinOneChoiceAuditTx){
            [self startAuditTxDataRequest];
        }
    }];
    
    
}



//========
//-------------------------------------------------------------------------------//






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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




