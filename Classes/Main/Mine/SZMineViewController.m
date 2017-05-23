//
//  SZMineViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMineViewController.h"
#import "ITTImageView.h"
#import "SZMyFriendsViewController.h"
#import "SZFriendsCircleViewController.h"
#import "SZMyCouponViewController.h"
#import "SZMyMembershipCardViewController.h"
#import "SZMyCollectViewController.h"
#import "SZMyCommentViewController.h"
#import "SZMyHistoryViewController.h"
#import "SZPersonalDynamicViewController.h"
#import "SZMyInfomationViewController.h"
#import "SZUserCenterRequest.h"
#import "SZUserCenterModel.h"
#import "UserManager.h"
#import "TwoDimensionalCodeScanViewController.h"
#import "SZRegistViewController.h"
#import "SZWebViewController.h"
#import "AppDelegate.h"
#import "XGPush.h"
#import "SMPushUnRegTokenRequest.h"
#import "WWPackageInfoCell.h"
#import "UserManager.h"
#import "TwoDimensionalCodeResultViewController.h"
#import "WWasteAddRequest.h" 
#import "SKUplodaQDCodeRequest.h"

@interface SZMineViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet ITTImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageCountLabel;


@property (weak, nonatomic) IBOutlet UIImageView *couponCountImageView;
@property (weak, nonatomic) IBOutlet UIImageView *membershipCardCountImageView;
@property (weak, nonatomic) IBOutlet UIImageView *collectCountImageView;
@property (weak, nonatomic) IBOutlet UIImageView *commentCountImageView;
@property (weak, nonatomic) IBOutlet UIImageView *friendsCountImageView;
@property (weak, nonatomic) IBOutlet UIImageView *circleMessageCountImageView;
@property (weak, nonatomic) IBOutlet UIImageView *circleMessageHintImageView;
@property (weak, nonatomic) IBOutlet UILabel *couponCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *membershipCardCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsCountLabel;
    @property (weak, nonatomic) IBOutlet UIButton *uplodaQDCode;//上传二维码信息
@property (weak, nonatomic) IBOutlet UILabel *circleMessageCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (weak, nonatomic) IBOutlet UILabel *packageLabel;//包装物label
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;//扫描二维码即可接受包装物

@property (strong, nonatomic) NSString *userId;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL isLogin;


- (IBAction)onModifyButtonClicked:(id)sender;
- (IBAction)onRegistButtonClicked:(id)sender;
- (IBAction)onLoginButtonClicked:(id)sender;
- (IBAction)onOneButtonClicked:(id)sender;
- (IBAction)onResignCurrentUserButtonClicked:(id)sender;



@property (weak, nonatomic) IBOutlet UIView *group1View;
@property (weak, nonatomic) IBOutlet UIView *group2View;
@property (weak, nonatomic) IBOutlet UIView *group3View;

@property (nonatomic, strong) NSMutableArray *preferentialCellArray;
    @property (nonatomic, strong) NSMutableArray *mutabelArrayaQRCode;

@end

@implementation SZMineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    //type 2学校 4处置企业
    if ([[UserManager sharedUserManager].orgTypeUser isEqualToString:@"4"]) {
        self.uplodaQDCode.clipsToBounds = YES;
        self.uplodaQDCode.layer.cornerRadius = 5;
        self.packageLabel.text = @"已回收包装物";
        self.scanLabel.text = @"扫码二维码即可回收包装物";
        self.uplodaQDCode.hidden = NO;
    }
    
    _headImageView.layer.cornerRadius = _headImageView.width/2.f;
    _headImageView.clipsToBounds = YES;
    if ([[UserManager sharedUserManager] isLogin])
    {
        _logoutButton.hidden = NO;
        _modifyButton.hidden = YES;
        _registButton.hidden = YES;
        _loginButton.hidden = YES;
        _scrollView.contentSize = CGSizeMake(320, 565);
    }
    _modifyButton.hidden = YES;
    
    NSString *portraitUrl = [[UserManager sharedUserManager] portraitUrl];
    if(IS_STRING_NOT_EMPTY(portraitUrl)){
        [_headImageView loadImage:[[UserManager sharedUserManager] portraitUrl] placeHolder:[UIImage imageNamed:@"SZ_Mine_Default_Head.png"]];
    }
    else{
        _headImageView.image = [UIImage imageNamed:@"SZ_Mine_Default_Head.png"];
    }
    
    _isLogin = [[UserManager sharedUserManager] isLogin];
    if(_isLogin){
        NSString *userId = [[UserManager sharedUserManager] userId];
        if(IS_STRING_NOT_EMPTY(userId)){
            _userId = userId;
            int gender = [[[UserManager sharedUserManager] gender] intValue];
            if(gender == USER_GENDER_MALE){
                _nameLabel.text = [NSString stringWithFormat:@"%@（高富帅）",[[UserManager sharedUserManager] realName]];
            }
            else if(gender == USER_GENDER_FEMALE)
            {
                _nameLabel.text = [NSString stringWithFormat:@"%@（白富美）",[[UserManager sharedUserManager] realName]];
            }
            else{
                _nameLabel.text = [NSString stringWithFormat:@"%@",[[UserManager sharedUserManager] realName]];
            }
            _mobileLabel.text = [NSString stringWithFormat:@"%@", [[UserManager sharedUserManager] mobileNum]];
            _groupNameLabel.text = [NSString stringWithFormat:@"%@", [[UserManager sharedUserManager] groupName]];
            _nameLabel.top = 18;
            
//            _packageCountLabel.text = @"0";
            
            if(!_isLoading){
                _isLoading = YES;
                [self beginUserCenterRequest];
            }
        }
    }
    else{
        [self setMessageCountWithUnLogIn];
        //        [[UserManager sharedUserManager] userId];
    }
}

-(void)setMyPackageList:(int)count
{
    [_preferentialCellArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat curTop = self.group1View.top + self.group1View.height;
    for (int i=0; i<count; i++) {
        WWQrcodeModel *model1 = [WWQrcodeModel alloc];
        model1.containerIdentifier = [NSString stringWithFormat:@"%@%d", @"#1213", i];
        if (i % 2 == 0){
            model1.containerType = @"PVC塑料桶材质";
            model1.containerSize = @"100X80cm";
        }
        else{
            model1.containerType = @"PP塑料桶";
            model1.containerSize = @"130X60cm";
        }
        model1.createdAt = @"2015-03-18 11:25:28";
        
        WWPackageInfoCell *cell = [WWPackageInfoCell cellFromNib];
        [cell showCellWithFinishBlock:^(WWQrcodeModel *model) {
            [self packageItemSelected:model];
        } data:model1];
        [_preferentialCellArray addObject:cell];
        cell.top = curTop,curTop+=cell.height;
        [_scrollView addSubview:cell];
    }
    
    
    _packageCountLabel.text = [NSString stringWithFormat:@"%d", count];
    
    self.group3View.top = curTop + 15;
    self.logoutButton.top = self.group3View.top + self.group3View.height + 15;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, self.logoutButton.top+20);
}
-(void)packageItemSelected:(WWQrcodeModel*)model
{
    TwoDimensionalCodeResultViewController *twoDimensionalCodeResultViewController = [[TwoDimensionalCodeResultViewController alloc] initWithNibName:@"TwoDimensionalCodeResultViewController" bundle:nil];
    twoDimensionalCodeResultViewController.symbolString = model.qrCode;
    twoDimensionalCodeResultViewController.onlyView = true;
    [self.navigationController pushViewController:twoDimensionalCodeResultViewController animated:YES];
    
    [PROMPT_VIEW showMessage:[NSString stringWithFormat:@"包装物编号： %@", model.containerIdentifier]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"我的"];
    self.mutabelArrayaQRCode = [NSMutableArray array];

//    _headImageView.layer.cornerRadius = _headImageView.width/2.f;
//    _headImageView.clipsToBounds = YES;
//    if ([[UserManager sharedUserManager] isLogin])
//    {
//        _logoutButton.hidden = NO;
//        _modifyButton.hidden = YES;
//        _registButton.hidden = YES;
//        _loginButton.hidden = YES;
//        _scrollView.contentSize = CGSizeMake(320, 565);
//    }
//    _modifyButton.hidden = YES;
//    
//    NSString *portraitUrl = [[UserManager sharedUserManager] portraitUrl];
//    if(IS_STRING_NOT_EMPTY(portraitUrl)){
//        [_headImageView loadImage:[[UserManager sharedUserManager] portraitUrl] placeHolder:[UIImage imageNamed:@"SZ_Mine_Default_Head.png"]];
//    }
//    else{
//        _headImageView.image = [UIImage imageNamed:@"SZ_Mine_Default_Head.png"];
//    }
//    _isLogin = [[UserManager sharedUserManager] isLogin];
//    if(_isLogin){
//        NSString *userId = [[UserManager sharedUserManager] userId];
//        if(IS_STRING_NOT_EMPTY(userId)){
//            _userId = userId;
//            int gender = [[[UserManager sharedUserManager] gender] intValue];
//            if(gender == USER_GENDER_MALE){
//                _nameLabel.text = [NSString stringWithFormat:@"%@（高富帅）",[[UserManager sharedUserManager] realName]];
//            }
//            else if(gender == USER_GENDER_FEMALE)
//            {
//                _nameLabel.text = [NSString stringWithFormat:@"%@（白富美）",[[UserManager sharedUserManager] realName]];
//            }
//            else{
//                _nameLabel.text = [NSString stringWithFormat:@"%@",[[UserManager sharedUserManager] realName]];
//            }
//            _mobileLabel.text = [NSString stringWithFormat:@"%@", [[UserManager sharedUserManager] mobileNum]];
//            _groupNameLabel.text = [NSString stringWithFormat:@"%@", [[UserManager sharedUserManager] groupName]];
//            _nameLabel.top = 18;
//            
//            _packageCountLabel.text = @"0";
//            
//            if(!_isLoading){
//                _isLoading = YES;
//                [self beginUserCenterRequest];
//            }
//        }
//    }
//    else{
//        [self setMessageCountWithUnLogIn];
//        //        [[UserManager sharedUserManager] userId];
//    }
    
    _preferentialCellArray = [NSMutableArray array];
    
    //UIImage *img =[UIImage imageNamed:@"WW_HOME_BG.png"];
    //[self.view setBackgroundColor: [UIColor colorWithPatternImage:img]];
    //UIColor *topViewBg = [UIColor clearColor];
    //[self setTopViewBackgroundColor:topViewBg];
    //[self.view setBackgroundColor:topViewBg];
    //[self setTitleColor: [UIColor whiteColor]];
    //[self setTopViewBackButtonImageStyle:0];
    //[_scrollView setBackgroundColor:[UIColor clearColor]];
    
    self.group1View.hidden = NO;
    self.group2View.hidden = YES;
    self.group3View.top = self.group1View.top + self.group1View.height + 15;    
    self.logoutButton.top = self.group3View.top + self.group3View.height + 15;
    UIColor *topViewBg = [UIColor whiteColor];     
    [self setTopViewBackgroundColor:topViewBg];
    //[self.view setBackgroundColor:topViewBg];
    [self setTitleColor: [UIColor blackColor]];
    
    
    //[self hiddenBackButton];
    [self.view bringSubviewToFront:_modifyButton];
    [self.view bringSubviewToFront:_registButton];
    [self.view bringSubviewToFront:_loginButton];
    [_logoutButton setImageName:@"SZ_COMMON_ADD" stretchWithLeft:10.f top:0 forState:UIControlStateNormal];
    [_logoutButton setImageName:@"SZ_COMMON_ADD_H" stretchWithLeft:10.f top:0 forState:UIControlStateHighlighted];
    if (IS_IOS_7) {
        _scrollView.contentOffset = CGPointMake(0,20);
        _scrollView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
}

- (void)beginUserCenterRequest
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:_userId forKey:@"user_id"];
    NSString *orgCode = [[UserManager sharedUserManager] groupCode];
    if (orgCode == nil){
        orgCode = @"";
    }
    [paramDict setObject:orgCode forKey:@"org_code"];
    NSString *deptCode = [[UserManager sharedUserManager] deptCode];
    if (deptCode == nil){
        deptCode = @"";
    }
    [paramDict setObject:deptCode forKey:@"dep_code"];
    NSLog(@"paramDict is %@",paramDict);
    [SZUserCenterRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        NSLog(@"start loading");
//        [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        _isLoading = NO;
        if (request.isSuccess) {
            NSArray *list = [request.handleredResult objectForKey:@"data"];
            if(list){
                NSLog(@"model is %@",list);
                [self setMessageCountPatternWithModel:list];
            }
        }
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        _isLoading = NO;
    }];
}

- (void)setMessageCountWithUnLogIn
{
    _headImageView.image = [UIImage imageNamed:@"SZ_Mine_Default_Head.png"];
    _nameLabel.text = @"请先登录";
    _mobileLabel.text = @"";
    _groupNameLabel.text = @"";
    _couponCountLabel.text = @"";
    _membershipCardCountLabel.text = @"";
    _collectCountLabel.text = @"";
    _commentCountLabel.text = @"";
    _friendsCountLabel.text = @"";
    _circleMessageCountLabel.text = @"";
    _circleMessageCountImageView.hidden = YES;
    _circleMessageHintImageView.hidden = YES;
    _logoutButton.hidden = YES;
    _modifyButton.hidden = YES;
    _registButton.hidden = YES;
    _loginButton.hidden = NO;
    _scrollView.contentSize = CGSizeMake(320, 816);
    
    _nameLabel.top = 42;
    _packageCountLabel.text = @"0";
    [self setMyPackageList:0];
}

- (void)setMessageCountPatternWithModel:(NSArray *)model
{
    _modifyButton.hidden = YES;
    _nameLabel.top = 16;
    _couponCountLabel.text =  @"";
    _membershipCardCountLabel.text = @"";
    _collectCountLabel.text = @"";
    _commentCountLabel.text = @"";
    _friendsCountLabel.text = @"";
    _circleMessageCountLabel.text = @"";
    _circleMessageCountImageView.hidden = YES;
    _circleMessageCountImageView.image = [UIImage imageNamed:@"SZ_Mine_Number_No_Bg.png"];
    _circleMessageHintImageView.hidden = YES;
    
    
    [_preferentialCellArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat curTop = self.group1View.top + self.group1View.height;
    for (int i=0; i<[model count]; i++) {
        WWQrcodeModel *model1 = [[WWQrcodeModel alloc] initWithDataDic:[model objectAtIndex:i]];
        WWPackageInfoCell *cell = [WWPackageInfoCell cellFromNib];
        [cell showCellWithFinishBlock:^(WWQrcodeModel *model) {
            [self packageItemSelected:model];
        } data:model1];
        [_preferentialCellArray addObject:cell];
        cell.top = curTop,curTop+=cell.height;
        [_scrollView addSubview:cell];
    }
    
    _packageCountLabel.text = [NSString stringWithFormat:@"%d", [model count]];
    
    self.group3View.top = curTop + 15;
    self.logoutButton.top = self.group3View.top + self.group3View.height + 15;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, self.logoutButton.top + 70);
    NSLog(@"scrollView height: %d, contentSize.height: %d", _scrollView.height, _scrollView.contentSize.height);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//二维码上传
- (IBAction)uplodaQDCodeAction:(id)sender {
    
    NSString * qDCodeStr = @"";
    if (self.mutabelArrayaQRCode.count == 0) {
        [PROMPT_VIEW showMessage:@"请扫描二维码"];
        return;
    }
    //所有的二维码做成一个字符串
    for (NSString * str in self.mutabelArrayaQRCode) {
        if (qDCodeStr.length == 0) {
            qDCodeStr = str;
        } else {
            qDCodeStr = [NSString stringWithFormat:@"%@,%@",str,qDCodeStr];
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [SKUplodaQDCodeRequest requestWithParameters:@{@"qrCodes":qDCodeStr} withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        [PROMPT_VIEW showActivityWithMask:@"数据上传中"];
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        if (request.isSuccess){
            [PROMPT_VIEW showMessage:@"二维码上传成功"];
            [weakSelf.mutabelArrayaQRCode removeAllObjects];
            weakSelf.packageCountLabel.text = [NSString stringWithFormat:@"%zd",weakSelf.mutabelArrayaQRCode.count];
        }
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        
        NSLog(@"request ------- %@ ",request);
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
        NSLog(@"request ======  %@ ",request);
        
    }];
    
    
}

- (IBAction)onModifyButtonClicked:(id)sender
{
    SZMyInfomationViewController *myInfomationViewController = [[SZMyInfomationViewController alloc] initWithNibName:@"SZMyInfomationViewController" bundle:nil];
    [self pushMasterViewController:myInfomationViewController];
}

- (IBAction)onRegistButtonClicked:(id)sender
{
    SZRegistViewController *registVC = [[SZRegistViewController alloc] initWithNibName:@"SZRegistViewController" bundle:nil];
    [self pushMasterViewController:registVC];
}

- (IBAction)onLoginButtonClicked:(id)sender
{
    [[UserManager sharedUserManager] userIdWithLoginBlock:nil];
}

- (IBAction)onOneButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int tag = button.tag;
    __weak typeof(self) weakSelf = self;
    switch (tag) {
        case kTagMineOneChoiceUserDynamic:
        {
            [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                /*
                typeof(self) strongSelf = weakSelf;
                SZPersonalDynamicViewController *personalDynamicViewController = [[SZPersonalDynamicViewController alloc] initWithNibName:@"SZPersonalDynamicViewController" bundle:nil];
                personalDynamicViewController.name = [[UserManager sharedUserManager] realName];
                [personalDynamicViewController setupUrlWithUserId:userId isFriend:NO];
                [strongSelf pushMasterViewController:personalDynamicViewController];
                 */
            }];
        }
            break;
        case kTagMineOneChoiceCoupon:
        {
            [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                typeof(self) strongSelf = weakSelf;
                SZMyCouponViewController *myCouponViewController = [[SZMyCouponViewController alloc] initWithNibName:@"SZMyCouponViewController" bundle:nil];
                [strongSelf pushMasterViewController:myCouponViewController];
            }];
        }
            break;
        case kTagMineOneChoiceMembershipCard:
        {
            [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                typeof(self) strongSelf = weakSelf;
                SZMyMembershipCardViewController *myMembershipCardViewController = [[SZMyMembershipCardViewController alloc] initWithNibName:@"SZMyMembershipCardViewController" bundle:nil];
                [strongSelf pushMasterViewController:myMembershipCardViewController];
            }];
        }
            break;
        case kTagMineOneChoiceSave:
        {
            [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                typeof(self) strongSelf = weakSelf;
                SZMyCollectViewController *myCollectViewController = [[SZMyCollectViewController alloc] initWithNibName:@"SZMyCollectViewController" bundle:nil];
                [strongSelf pushMasterViewController:myCollectViewController];
            }];
        }
            break;
        case kTagMineOneChoiceComment:
        {
            [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                typeof(self) strongSelf = weakSelf;
                SZMyCommentViewController *myCommentViewController = [[SZMyCommentViewController alloc] initWithNibName:@"SZMyCommentViewController" bundle:nil];
                [strongSelf pushMasterViewController:myCommentViewController];
            }];
        }
            break;
        case kTagMineOneChoiceHistory:
        {
            [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                typeof(self) strongSelf = weakSelf;
                SZMyHistoryViewController *myHistoryViewController = [[SZMyHistoryViewController alloc] initWithNibName:@"SZMyHistoryViewController" bundle:nil];
                [strongSelf pushMasterViewController:myHistoryViewController];
            }];
        }
            break;
        case kTagMineOneChoiceFriends:
        {
            [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                typeof(self) strongSelf = weakSelf;
                SZMyFriendsViewController *myFriendsViewController = [[SZMyFriendsViewController alloc] initWithNibName:@"SZMyFriendsViewController" bundle:nil];
                myFriendsViewController.friendsCount = _friendsCountLabel.text;
                [strongSelf pushMasterViewController:myFriendsViewController];
            }];
        }
            break;
        case kTagMineOneChoiceCircle:
        {
            [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                typeof(self) strongSelf = weakSelf;
                SZFriendsCircleViewController *friendsCircleViewController = [[SZFriendsCircleViewController alloc] initWithNibName:@"SZFriendsCircleViewController" bundle:nil];
                [friendsCircleViewController setupUrlWithUserId:userId];
                [strongSelf pushMasterViewController:friendsCircleViewController];
            }];
        }
            break;
        case kTagMineOneChoiceDimensionCode:
        {
            
            TwoDimensionalCodeScanViewController *twoDimensionalCodeScanViewController = [[TwoDimensionalCodeScanViewController alloc] initWithNibName:@"TwoDimensionalCodeScanViewController" bundle:nil];
            twoDimensionalCodeScanViewController.getQRCode = ^(NSMutableArray *mutableArrayForCode) {
                [self.mutabelArrayaQRCode addObjectsFromArray:mutableArrayForCode];
                self.packageCountLabel.text = [NSString stringWithFormat:@"%zd",self.mutabelArrayaQRCode.count];
            };
            //已扫描过得传输过去防止出现重复
            twoDimensionalCodeScanViewController.arrayForQRCode = self.mutabelArrayaQRCode;
            twoDimensionalCodeScanViewController.login = self.login;
            [self pushMasterViewController:twoDimensionalCodeScanViewController];
        }
            break;
        default:
        {
            
        }
            break;
    }
}

- (IBAction)onResignCurrentUserButtonClicked:(id)sender
{
    [[UserManager sharedUserManager] logout];
    [self setMessageCountWithUnLogIn]; 
    [[AppDelegate GetAppDelegate] resetTabs];
    return;
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{@"userid": [NSString stringWithFormat:@"u%@", [[UserManager sharedUserManager] userId]]
                             ,@"devid":[[UserManager sharedUserManager] apnsId]
                             ,@"appkey":@"123456"
                             ,@"ct":@"ios"};
    NSLog(@"push unreg: %@", params);
    [SMPushUnRegTokenRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request)
     {
         [PROMPT_VIEW showMessage:@"正在注销推送服务..."];
     } onRequestFinished:^(ITTBaseDataRequest *request) {
         if (request.isSuccess) {
             [PROMPT_VIEW showMessage:@"成功注销推送服务"];
         }
     } onRequestCanceled:nil onRequestFailed:nil];
}


@end














