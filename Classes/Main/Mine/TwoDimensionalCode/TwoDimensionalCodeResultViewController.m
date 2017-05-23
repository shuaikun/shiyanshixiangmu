//
//  TwoDimensionalCodeResultViewController.m
//  SinaLiftCircle
//
//  Created by 王琦 on 13-10-31.
//
//

#import "TwoDimensionalCodeResultViewController.h"
#import "WWQrcodeDataRequest.h"
#import "WWQrcodeModel.h"
#import "WWPourWasteViewController.h"
#import "ITTRefreshTableHeaderView.h"
#import "WWQrcodeListItemCell.h"
#import "WWBindQrcodeRequest.h"
#import "SZMineViewController.h"
#import "WWUnbindQrcodeRequest.h"

@interface TwoDimensionalCodeResultViewController ()
<
ITTRefreshTableHeaderDelegate
,UIScrollViewDelegate
>

@property (retain, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *bindButton;
@property (weak, nonatomic) IBOutlet UIButton *unbindButton;
@property (nonatomic, strong) NSArray *lists;
@property (nonatomic, strong) WWQrcodeModel *qrcodeModel;
@property (weak, nonatomic) IBOutlet UIView *hrView;


@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIButton *showMoreDiscountBtn;
@property (nonatomic, strong) ITTRefreshTableHeaderView *refreshView;
@property (nonatomic,readwrite) BOOL pullTableIsRefreshing;
@property (nonatomic, strong) NSMutableArray *preferentialCellArray;

@end

@implementation TwoDimensionalCodeResultViewController

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
    [self setTitle:@"包装物信息"];
    
    _scrollView.top = _hrView.bottom;
    _scrollView.height = self.view.height - _hrView.bottom;
    [_showMoreDiscountBtn setHidden:YES];
    
    [_bindButton setHidden:YES];
    [_unbindButton setHidden:YES];
    _userIdLabel.text = _symbolString;
    
    _preferentialCellArray = [NSMutableArray array];
    
    UIColor *topColor = [UIColor whiteColor];
    [[self view] setBackgroundColor:topColor];
    [[self baseTopView] setBackgroundColor: topColor];
    [self setTopViewBackButtonImageStyle:0];
    [self setupRefrashHeader];
    
    self.pullTableIsRefreshing = NO;
    [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
    [self setRefreshViewHidden:YES];
    [self parseQrcode:_symbolString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}

- (IBAction)bindButtonDidClick:(id)sender {
    [self bindQrcode];
}
- (IBAction)unbindButtonDidClick:(id)sender {
    
    
    UIAlertView *apsAlter = [[UIAlertView alloc]initWithTitle:nil message:@"确认现在要送交包装物吗？" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"送交", nil];
    [apsAlter show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self unbindQrcode];
    }
}



-(void) unbindQrcode
{
    
    
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        //NSString *userid = [[UserManager sharedUserManager] userId];
        //if (IS_STRING_EMPTY(userid)){
        //    userid = @"temp";
        //}
        NSString *token = ssoToken; //[[UserManager sharedUserManager] ssoTokenWithUserId:userid];
        if (IS_STRING_EMPTY(token)){
            token = @"34321532153215321543215321532";
        }
        
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:self.qrcodeModel.qrCode forKey:@"qrcode"];
        [paramDict setObject:userId forKey:@"user_id"];
        [paramDict setObject:token forKey:@"token"];
        
        NSString *deptCode = [[UserManager sharedUserManager] deptCode];
        if ([deptCode length] == 0){
            deptCode = [[UserManager sharedUserManager] groupCode];
        }
        [paramDict setObject:deptCode forKey:@"dep_code"];
        
        NSLog(@"paramDict is %@",paramDict);
        [WWUnbindQrcodeRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            
            if (request.isSuccess) {
                [self popMasterViewController];
                //[self gotoMineViewController];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            
        }];
    }];
}

-(void) bindQrcode
{
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        //NSString *userid = [[UserManager sharedUserManager] userId];
        //if (IS_STRING_EMPTY(userid)){
        //    userid = @"temp";
        //}
        NSString *token = ssoToken; //[[UserManager sharedUserManager] ssoTokenWithUserId:userid];
        if (IS_STRING_EMPTY(token)){
            token = @"34321532153215321543215321532";
        }
        
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:self.qrcodeModel.qrCode forKey:@"qrcode"];
        [paramDict setObject:userId forKey:@"user_id"];
        [paramDict setObject:token forKey:@"token"];
        
        NSString *deptCode = [[UserManager sharedUserManager] deptCode];
        if ([deptCode length] == 0){
            deptCode = [[UserManager sharedUserManager] groupCode];
        }
        [paramDict setObject:deptCode forKey:@"dep_code"];
        
        NSLog(@"paramDict is %@",paramDict);
        [WWBindQrcodeRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            
            if (request.isSuccess) {
                
                //[self gotoMineViewController];
                [self popMasterViewController];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            
        }];
    }];
}

- (void) parseQrcode:(NSString*) qrcode
{
    
    NSString *userid = [[UserManager sharedUserManager] userId];
    if (IS_STRING_EMPTY(userid)){
        userid = @"temp";
    }
    NSString *token = [[UserManager sharedUserManager] ssoTokenWithUserId:userid];
    if (IS_STRING_EMPTY(token)){
        token = @"34321532153215321543215321532";
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:qrcode forKey:@"qrcode"];
    [paramDict setObject:userid forKey:@"userid"];
    [paramDict setObject:token forKey:@"token"];
    NSLog(@"paramDict is %@",paramDict);
    [WWQrcodeDataRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        NSLog(@"start loading");
        [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        
        if (request.isSuccess) {
            self.qrcodeModel = [request.handleredResult objectForKey:NETDATA];
            
            NSLog(@"qrcode data: %@", self.qrcodeModel);
            NSLog(@"qrcode code: %@", self.qrcodeModel.containerIdentifier);
            NSLog(@"qrcode type: %@", self.qrcodeModel.containerType);
            
            [self performSelector:@selector(parseQrcode) withObject:nil afterDelay:0.3];
        }
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
    }];
}

-(void)parseQrcode
{
    NSString *msg = @"未知信息";
    BOOL canPour = false;
    BOOL canBind = false;
    if (self.qrcodeModel != nil){
        switch (self.qrcodeModel.packageBoxStatus) {
            case kPackageBoxNone:
                msg = @"包装物不可用";
                break;
            case kPackageBoxActive:
                msg = @"包装物可用";
                canBind = true;
                break;
            case kPackageBoxBinded:
                msg = @"包装物可倒入废物";
                canPour = true;
                break;
            case kPackageBoxFreeze:
                msg = @"包装物被封存";
                break;
            case kPackageBoxDestory:
                msg = @"包装物已销毁";
                break;
            default:
                break;
        }
    }
    _userIdLabel.text = msg;
    [PROMPT_VIEW showMessage:msg];
    
    [self loadListData];
    
    if (canPour){
        [self performSelector:@selector(gotoPourWaster) withObject:nil afterDelay:0.5];
        return;
    }
    
    if (canBind){
        [_bindButton setHidden:NO];
        [self performSelector:@selector(gotoBind) withObject:nil afterDelay:0.5];
        return;
    }
}
-(void)gotoBind
{
    
}
-(void)gotoPourWaster{
    if (self.onlyView == false){
        WWPourWasteViewController *pourWasteViewController = [[WWPourWasteViewController alloc] initWithNibName:@"WWPourWasteViewController" bundle:nil];
        pourWasteViewController.symbolString = _symbolString;
        pourWasteViewController.login = self.login;
        [[UserManager sharedUserManager] setInt:0 withKey:kWWPourWasteStep];
        [self.navigationController pushViewController:pourWasteViewController animated:YES];
    }
    else{
        //self
        [_unbindButton setHidden:NO];
        [self.view bringSubviewToFront:_unbindButton];
    }
}
-(void)gotoMineViewController{
    SZMineViewController *pourWasteViewController = [[SZMineViewController alloc] initWithNibName:@"SZMineViewController" bundle:nil];
    [self.navigationController pushViewController:pourWasteViewController animated:YES];
}

-(void)loadListData
{
    __weak typeof(self) weakSelf = self;
    weakSelf.pullTableIsRefreshing = NO;
    
    [_preferentialCellArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    CGFloat curTop = 0;
    for (WWQrcodeListItemModel *itemModel in self.qrcodeModel.list) {
        WWQrcodeListItemCell *cell = [WWQrcodeListItemCell cellFromNib];
        [cell getDataSourceFromModel:itemModel];
        [_preferentialCellArray addObject:cell];
        cell.top = curTop,curTop+=cell.height;
        [_scrollView addSubview:cell];
    }
    _showMoreDiscountBtn.top = curTop+9;
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _showMoreDiscountBtn.bottom+60);
    _showMoreDiscountBtn.hidden = YES;
    
    
    [PROMPT_VIEW hideWithAnimation];
    
    self.pullTableIsRefreshing = NO;
    [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
    [self setRefreshViewHidden:YES];
}


- (IBAction)navigationBackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [self loadListData];
}



@end
