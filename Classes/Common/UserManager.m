//
//  UserManager.m
//  iTotemFramework
//
//  Created by Grant on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "UserManager.h"
#import "ITTObjectSingleton.h"
#import "SZLoginViewController.h"
//#import "SMLoginViewController.h"
#import "SZMineViewController.h"
#import "SZRegistViewController.h"
#import "AppDelegate.h"
#import "XGPush.h"
#import "NSFileManager_BugFixExtensions.h"

NSString *const SKOrgType = @"sKOrgType";
NSString *const kSZUserId    = @"kSZUserId";
NSString *const kSZMobileNum = @"kSZMobileNum";
NSString *const kSZRealName  = @"kSZRealName";
NSString *const kSZGender    = @"kSZGender";
NSString *const kSZPortraitUrl  = @"kSZPortraitUrl";
NSString *const kSZCity      = @"kSZCity";
NSString *const kSZOnlyWifi      = @"kSZOnlyWifi";
NSString *const kSZNeedNotifiMsg = @"kSZNeedNotifiMsg";
NSString *const kSZApnsId = @"kSZApnsId";
NSString *const kSSO_TOKEN_KEY_IN_KEYCHAIN = @"com.knowesoft.oax.ssotoken";
NSString *const kSZNews     = @"kSZNews";

NSString *const kSMRole     = @"kSMRole";
NSString *const kSMLNews    = @"新闻";
NSString *const kSMLNotice  = @"通知";
NSString *const kSMVNews    = @"11";
NSString *const kSMVNotice  = @"12";

NSString *const kSZVCArray = @"kSZVCArray";

NSString *const kSMAttendType = @"kSMAttendType";
NSString *const kSMReportType = @"kSMReportType";

NSString *const kSMReportRefresh = @"kSMReportRefresh";
NSString *const kSMHomeViewHisArray  = @"kSMHomeViewHisArray";


NSString *const kWWName = @"kWWName";
NSString *const kWWGroupCode = @"kWWGroupCode";
NSString *const kWWGroupName = @"kWWGroupName";
NSString *const kWWGroupType = @"kWWGroupType";
NSString *const kSMDeptname = @"kSMDeptname";
NSString *const kSMDeptcode = @"kSMDeptcode";

#define SZ_DEFAULT_CITY @"宿州"
#define SZ_GPS_INTERVAL 20 //定位时间间隔 20秒
#define SZ_DEFAULT_NEWS @"通知";

NSString *const validationSecondNotificationName = @"validationSecondNotificationName";
@interface UserManager ()
<UIAlertViewDelegate>
{
    BOOL _onlyShowImageOnWifi;
    BOOL _needNotificaionMsg;
    NSString *_ssoToken;
}
@property (strong, nonatomic) NSTimer *validationCodeTimer;
@property (strong, nonatomic) NSMutableArray *controllersArray;
@property (nonatomic, copy) void(^loginBlock)(NSString *userId, NSString *ssoToken);
@property (readwrite, nonatomic) BOOL isWifiAlertShowing;
@property (readwrite, nonatomic) NSTimeInterval locationTimestamp;
@property (strong, nonatomic) CLLocation *currentLocation;
 
@property (strong, nonatomic) NSMutableArray *homeArray;



@end



@implementation UserManager
ITTOBJECT_SINGLETON_BOILERPLATE(UserManager, sharedUserManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        _controllersArray = [UserManager objectForKey:kSZVCArray];
        if (_controllersArray == nil) {
            _controllersArray = [NSMutableArray array];
        }
        _locationTimestamp = 0;
        
        
        NSString *hisString = [UserManager objectForKey:@"view_his_string"];
        NSArray *array = [hisString componentsSeparatedByString:@"|"];
        _homeArray = [NSMutableArray arrayWithArray:array];
        
        //_wasteTypeArray = [NSMutableArray array];
        
        _needRefreshHomeViewHis = true;
    }
    return self;
}


#pragma mark - get function

-(NSString *)deptName
{
    return [UserManager objectForKey:kSMDeptname];
}

-(NSString *)deptCode
{
    return [UserManager objectForKey:kSMDeptcode];
}
-(NSString *)groupCode
{
    return [UserManager objectForKey:kWWGroupCode];
}
-(NSString *)groupName
{
    return [UserManager objectForKey:kWWGroupName];
}
-(NSString *)groupType
{
    return [UserManager objectForKey:kWWGroupType];
}
- (NSString *)orgTypeUser
{
    return [UserManager objectForKey:SKOrgType];
}
- (NSString *)userId
{
//    if ([self isLogin]) {
        NSString *userId = [UserManager objectForKey:kSZUserId];
        return userId;
//    }else
//    {
//        SZLoginViewController *loginVC = [[SZLoginViewController alloc] initWithNibName:@"SZLoginViewController" bundle:nil];
//        [UIViewController pushMasterViewController:loginVC];
//        return nil;
//    }
}

- (NSString *)apnsId
{
    NSString *apnsId = [UserManager objectForKey:kSZApnsId];
    return apnsId;
}

- (void)setApnsId:(NSString *)apnsId
{
    if (IS_STRING_NOT_EMPTY(apnsId) && ![apnsId isEqualToString:[self apnsId]]) {
        [[NSUserDefaults standardUserDefaults] setObject:apnsId forKey:kSZApnsId];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL)isFirstOpenForViewControllerClass:(Class)aClass
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *className = NSStringFromClass(aClass);
    NSString *md5 = [[NSString stringWithFormat:@"%@%@",version,className] md5];

    for (NSString *controllerStr in _controllersArray) {
        if ([controllerStr isEqualToString:md5]) {
            return NO;
        }
    }
    [_controllersArray addObject:md5];
    [[NSUserDefaults standardUserDefaults] setObject:_controllersArray forKey:kSZVCArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}


- (void)userIdWithLoginBlock:(void(^)(NSString *userId, NSString *ssoToken))block
{

    if ([self isLogin]) {
        NSString *userId = [UserManager objectForKey:kSZUserId];
        if (block) {
            block(userId,[self ssoTokenWithUserId:userId]);
        }

    }else
    {
        SZLoginViewController *loginVC = [[SZLoginViewController alloc] initWithNibName:@"SZLoginViewController" bundle:nil];
        self.loginBlock = block;
        if(![UIViewController containMasterClass:[SZLoginViewController class]])//防止重复调用
        {
            [UIViewController pushMasterViewController:loginVC];
        }
    }
}

+ (void)didFinishLoginWithviewController:(UIViewController *)viewController;
{
    UserManager *userManager = [self sharedUserManager];
    UINavigationController *naviC = [((AppDelegate*)([UIApplication sharedApplication].delegate)) masterNavigationController];
    SZLoginViewController *loginVC = nil;
    SZRegistViewController *registVC = nil;
    NSArray *viewControllers = naviC.viewControllers;
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[SZLoginViewController class]]) {
            loginVC = (SZLoginViewController *)vc;
        }else if([vc isKindOfClass:[SZRegistViewController class]])
        {
            registVC = (SZRegistViewController *)vc;
        }
    }
    if (registVC) {
        [registVC.navigationController popViewControllerAnimated:NO];
    }
    if (loginVC) {
        [loginVC.navigationController popViewControllerAnimated:NO];
    }
    
    if (userManager.loginBlock) {
        NSString *userId = [userManager userId];
        userManager.loginBlock(userId,[userManager ssoTokenWithUserId:userId]);
    }
    [PROMPT_VIEW showMessage:@"登录成功"];
}

- (BOOL)isLogin
{
    NSString *userId = [UserManager objectForKey:kSZUserId];
    return IS_STRING_NOT_EMPTY(userId);
}
- (NSString *)mobileNum
{
    return [UserManager objectForKey:kSZMobileNum];
}
- (NSString *)realName
{
    return [UserManager objectForKey:kSZRealName];
}
- (NSString *)gender;
{
    return [UserManager objectForKey:kSZGender];
}
- (NSString *)portraitUrl
{
    return [UserManager objectForKey:kSZPortraitUrl];
}



-(NSString *)roles
{
    return [UserManager objectForKey:kSMRole];
}






-(NSString*)news {
    NSString *newsStr = [UserManager objectForKey:kSZNews];
    if (IS_STRING_EMPTY(newsStr)) {
        newsStr = SZ_DEFAULT_NEWS;
        [self setNews:newsStr];
    }
    return newsStr;
}

- (void)setNews:(NSString *)news
{
    if (IS_STRING_NOT_EMPTY(news)) {
        [UserManager setObject:news forKey:kSZNews];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSZNews];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)newsCode
{
    NSString *newscode = @"";
    NSString *newsStr = [self news];
    if ([newsStr isEqualToString:kSMLNews]){
        return [newscode stringByAppendingString:kSMVNews];
    }
    else if ([newsStr isEqualToString:kSMLNotice])
    {
        return [newscode stringByAppendingString:kSMVNotice];
    }
    else{
        return [newscode stringByAppendingString:kSMVNotice];
    }
}



-(Boolean) isNewsType:(NSString *)newscode
{
    if (IS_STRING_NOT_EMPTY(newscode)){
        return [newscode isEqualToString:kSMVNews];
    }
   
    NSString *newsStr = [self news];
    return [newsStr isEqualToString:kSMLNews];
}

-(Boolean) isNoticeType:(NSString *)newscode
{
    if (IS_STRING_NOT_EMPTY(newscode)){
        return [newscode isEqualToString:kSMVNotice];
    }
    NSString *newsStr = [self news];
    return [newsStr isEqualToString:kSMLNotice];
}

- (NSString *)city
{
    NSString *cityStr = [UserManager objectForKey:kSZCity];
//    if (IS_STRING_EMPTY(cityStr)) {
//        cityStr = SZ_DEFAULT_CITY;
//        [self setCity:cityStr];
//    }
    return cityStr;
}

- (NSString *)ssoTokenWithUserId:(NSString *)userId
{
    if (IS_STRING_EMPTY(_ssoToken) && IS_STRING_NOT_EMPTY(userId)) {
        NSString *tokenKey = [self ssoTokenKeyWithUserId:userId];
        //_ssoToken = [UserManager loadInKeychain:tokenKey];
        _ssoToken = [UserManager objectForKey:tokenKey];
    }
    return _ssoToken;
}

- (NSString *)cityCode
{
    NSString *cityStr = [self city];
    NSString *cityCode = nil;
    if ([cityStr isEqualToString:@"宿州"]) {
        cityCode = @"sz";
    }
    else if ([cityStr isEqualToString:@"唐山"])
    {
        cityCode = @"ts";
    }else
    {
        cityCode = @"";
    }
    return cityCode;
}

- (void)setCityCode:(NSString *)cityCode
{
     [self setCity:[self getCityNameWithCode:cityCode]];
        
}

- (NSString *)getCityNameWithCode:(NSString *)cityCode
{
    if (IS_STRING_NOT_EMPTY(cityCode)) {
        if ([cityCode isEqualToString:@"sz"]) {
            return@"宿州";
            
        }else if ([cityCode isEqualToString:@"ts"]) {
            return @"唐山";
        }else
        {
            return nil;
        }
    }else
    {
        return nil;
    }
}

- (void)setCity:(NSString *)city
{
    if (IS_STRING_NOT_EMPTY(city)) {
        [UserManager setObject:city forKey:kSZCity];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSZCity];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL)onlyShowImageOnWifi
{
    _onlyShowImageOnWifi = [UserManager boolForKey:kSZOnlyWifi];
    return _onlyShowImageOnWifi;
}

- (void)setOnlyShowImageOnWifi:(BOOL)onlyShowImageOnWifi
{
    if (_onlyShowImageOnWifi != onlyShowImageOnWifi) {
        _onlyShowImageOnWifi = onlyShowImageOnWifi;
        [UserManager setBool:onlyShowImageOnWifi forKey:kSZOnlyWifi];
    }
    if (_onlyShowImageOnWifi == NO) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kOnlyShowImageOnWifiSwitchOff object:nil];
    }
}

- (BOOL)needNotificaionMsg
{
    _needNotificaionMsg = YES;
    if ([UserManager objectForKey:kSZNeedNotifiMsg] == nil) {
        [UserManager setObject:@"1" forKey:kSZNeedNotifiMsg];//开
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([[UserManager objectForKey:kSZNeedNotifiMsg] isEqualToString:@"0"])
    {
        _needNotificaionMsg = NO;
    }
    return _needNotificaionMsg;
}

- (void)setNeedNotificaionMsg:(BOOL)needNotificaionMsg
{
    if (_needNotificaionMsg != needNotificaionMsg) {
        _needNotificaionMsg = needNotificaionMsg;
        if(needNotificaionMsg)
        {
            [UserManager setObject:@"1" forKey:kSZNeedNotifiMsg];//开
        }else
        {
            [UserManager setObject:@"0" forKey:kSZNeedNotifiMsg];//关
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



#pragma mark - setFunction
- (void)storeUserInfoWithUserId:(NSString *)userId
                       realName:(NSString *)realName
                         gender:(NSString *)gender
                    portraitUrl:(NSString *)portraitUrl
                       ssoToken:(NSString *)ssoToken
                       deptname:(NSString *)deptname
                          roles:(NSString *)roles
                        orgType:(NSInteger)orgType
{
    //角色不为空 2：学校 4：处置企业
    if (orgType) {
        [UserManager setObject:[NSString stringWithFormat:@"%zd",orgType] forKey:SKOrgType];
    } else {
        [UserManager setObject:@"2" forKey:SKOrgType];
    }
    //
    NSString *userIdStr = [NSString stringWithFormat:@"%@",userId];
    if (IS_STRING_NOT_EMPTY(userIdStr)) {
        [UserManager setObject:[NSString stringWithFormat:@"%@",userIdStr] forKey:kSZUserId];
    }
    
   
    if (IS_STRING_NOT_EMPTY(ssoToken) && ![[ssoToken encodeUrl] isEqualToString:_ssoToken]) {
        _ssoToken = nil;
        NSString *tokenKey = [self ssoTokenKeyWithUserId:userId];
        //[UserManager saveToKeychain:tokenKey data:[ssoToken encodeUrl]];
        [UserManager setObject:[NSString stringWithFormat:@"%@",ssoToken] forKey:tokenKey];
    }
    
    if (IS_STRING_NOT_EMPTY(realName) && ![realName isEqualToString:[self realName]]) {
        [UserManager setObject:realName forKey:kSZRealName];
    }
    
    if (IS_STRING_NOT_EMPTY(portraitUrl) && ![portraitUrl isEqualToString:[self portraitUrl]]) {
        [UserManager setObject:portraitUrl forKey:kSZPortraitUrl];
    }
    
    NSString *genderStr = [NSString stringWithFormat:@"%@",gender];
    if (IS_STRING_NOT_EMPTY(genderStr) && ![genderStr isEqualToString:[self gender]]) {
        [UserManager setObject:genderStr forKey:kSZGender];
    }
    
    NSString *deptnameStr = [NSString stringWithFormat:@"%@",deptname];
    if (IS_STRING_NOT_EMPTY(deptnameStr) && ![deptnameStr isEqualToString:[self deptName]]) {
        [UserManager setObject:deptnameStr forKey:kSMDeptname];
    }
    
    NSString *roleStr = [NSString stringWithFormat:@"%@",roles];
    if (IS_STRING_NOT_EMPTY(roleStr) && ![roleStr isEqualToString:[self roles]]) {
        [UserManager setObject:roleStr forKey:kSMRole];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)ssoTokenKeyWithUserId:(NSString *)userId
{
    NSString *tokenKey = [NSString stringWithFormat:@"%@-weifei-%@",kSSO_TOKEN_KEY_IN_KEYCHAIN,userId];
    tokenKey = [tokenKey md5];
    return tokenKey;
}

- (void)storeUserInfoWithMobileNum:(NSString *)mobileNum
{
    if (IS_STRING_NOT_EMPTY(mobileNum) && ![mobileNum isEqualToString:[self mobileNum]]) {
        [UserManager setObject:mobileNum forKey:kSZMobileNum];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeUserInfoWithRealName:(NSString *)realName
{
    if (IS_STRING_NOT_EMPTY(realName) && ![realName isEqualToString:[self realName]]) {
        [UserManager setObject:realName forKey:kSZRealName];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeUserInfoWithGender:(NSString *)gender
{
    if (IS_STRING_NOT_EMPTY(gender) && ![gender isEqualToString:[self gender]]) {
        [UserManager setObject:gender forKey:kSZGender];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeUserInfoWithPortraitUrl:(NSString *)portraitUrl
{
    if (IS_STRING_NOT_EMPTY(portraitUrl) && ![portraitUrl isEqualToString:[self portraitUrl]]) {
        [UserManager setObject:portraitUrl forKey:kSZPortraitUrl];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)storeUserInfoWithDeptcode:(NSString *)deptcode
{
    if (![deptcode isEqualToString:[self deptCode]]) {
        [UserManager setObject:deptcode forKey:kSMDeptcode];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeUserInfoWithDeptname:(NSString *)deptname
{
    if (![deptname isEqualToString:[self deptName]]) {
        [UserManager setObject:deptname forKey:kSMDeptname];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (void)storeUserInfoWithRoles:(NSString *)roles
{
    if (IS_STRING_NOT_EMPTY(roles) && ![roles isEqualToString:[self roles]]) {
        [UserManager setObject:roles forKey:kSMRole];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeUserInfoWithGroupCode:(NSString *)groupCode
{
    if (IS_STRING_NOT_EMPTY(groupCode) && ![groupCode isEqualToString:[self groupCode]]) {
        [UserManager setObject:groupCode forKey:kWWGroupCode];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeUserInfoWithGroupName:(NSString *)groupName
{
    if (IS_STRING_NOT_EMPTY(groupName) && ![groupName isEqualToString:[self groupName]]) {
        [UserManager setObject:groupName forKey:kWWGroupName];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeUserInfoWithGroupType:(NSString *)groupType
{
    if (IS_STRING_NOT_EMPTY(groupType) && ![groupType isEqualToString:[self groupType]]) {
        [UserManager setObject:groupType forKey:kWWGroupType];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)logout
{
    //NSString *tag = [NSString stringWithFormat:@"%@:%@", @"userId", [self userId]];
    //[XGPush delTag:tag];
    
    _ssoToken = nil;
    NSString *ssoTokenKey = [self ssoTokenKeyWithUserId:[self userId]];
    //[UserManager delete:ssoTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ssoTokenKey];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSZUserId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSZMobileNum];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSZRealName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSZPortraitUrl];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSZGender];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kWWGroupCode];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kWWGroupName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSMDeptcode];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSMDeptname];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kWWGroupName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kWWGroupType];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - private function
+ (id)objectForKey:(NSString *)defaultName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)boolForKey:(NSString *)defaultName{
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}

- (void)getCurrentLocationNeedAlert:(BOOL)needAlert
                          WithBlock:(GTLocationRequestBlock)block
{
    if (!needAlert) {
        
    }
}

- (void)getCurrentLocationWithBlock:(GTLocationRequestBlock)block
{
    NSTimeInterval timeDita = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSinceReferenceDate] - self.locationTimestamp;
    
    if (timeDita<SZ_GPS_INTERVAL && self.currentLocation) {
        block(self.currentLocation,INTULocationAccuracyNone,YES);
        return;
    }
    [PROMPT_VIEW showActivityWithMask:@"定位中"];
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyNeighborhood
                                                                timeout:20.f
                                                   delayUntilAuthorized:NO
                                                                  block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status){
                                                                      [PROMPT_VIEW hidden];
                                                                      if (status == INTULocationStatusSuccess)
                                                                      {
                                                                          self.currentLocation = currentLocation;
                                                                          self.locationTimestamp = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSinceReferenceDate];
                                                                          block(currentLocation,achievedAccuracy,YES);
                                                                          return;
                                                                      }
                                                                      else if (status == INTULocationStatusTimedOut)
                                                                      {
                                                                          // You may wish to inspect achievedAccuracy here to see if it is acceptable, if you plan to use currentLocation
                                                                          NSLog(@"Location request timed out. Current Location:\n%@", currentLocation);
                                                                          block(currentLocation,achievedAccuracy,NO);
                                                                          [PROMPT_VIEW showMessage:@"定位超时"];
                                                                      }
                                                                      else
                                                                      {
                                                                          // An error occurred
                                                                          if (status == INTULocationStatusServicesNotDetermined)
                                                                          {
                                                                              NSLog(@"Error: User has not responded to the permissions alert.");
                                                                              [PROMPT_VIEW showMessage:@"请选择允许我们为您定位"];
                                                                          } else if (status == INTULocationStatusServicesDenied) {
                                                                              NSLog(@"Error: User has denied this app permissions to access device location.");
                                                                              [UIAlertView  popupAlertByDelegate:nil title:nil message:@"请到系统设置中打开定位功能"];
                                                                          } else if (status == INTULocationStatusServicesRestricted) {
                                                                              NSLog(@"Error: User is restricted from using location services by a usage policy.");
                                                                              [UIAlertView  popupAlertByDelegate:nil title:nil message:@"定位服务受到使用条款限制"];
                                                                          } else if (status == INTULocationStatusServicesDisabled) {
                                                                              NSLog(@"Error: Location services are turned off for all apps on this device.");
                                                                              [UIAlertView  popupAlertByDelegate:nil title:nil message:@"请到系统设置中打开定位功能"];
                                                                          } else {
                                                                              NSLog(@"An unknown error occurred.\n(Are you using iOS Simulator with location set to 'None'?)");
//                                                                              [PROMPT_VIEW showMessage:@"使用模拟器假坐标"];
                                                                              //33.646,116.966 宿州
                                                                              //39.893,116.447 首东国际
                                                                              CLLocation *fackLocation = [[CLLocation alloc] initWithLatitude:39.893 longitude:116.447];
                                                                              block(fackLocation,achievedAccuracy,YES);
                                                                              return;
                                                                          }
                                                                      }
                                                                      block(currentLocation,achievedAccuracy,NO);

    }];
}

- (void)startValidationCodeTimer
{
    if (!_validationCodeTimer) {
        _validationSecond = 60;
        _validationCodeTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(sendValidationCodeNotification:) userInfo:nil repeats:YES];
        //使用NSRunLoopCommonModes模式，把timer加入到当前Run Loop中。
        [[NSRunLoop currentRunLoop] addTimer:_validationCodeTimer forMode:NSRunLoopCommonModes];
        [self sendValidationCodeNotification:_validationCodeTimer];
    }
}

- (BOOL)isOnTimer
{
    if (_validationCodeTimer) {
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark - private function
- (void)sendValidationCodeNotification:(NSTimer *)timer
{
    if (_validationSecond==0) {
        [_validationCodeTimer invalidate];
        _validationCodeTimer = nil;
    }else
    {
        _validationSecond--;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:validationSecondNotificationName object:nil];
}


#pragma mark - KeyChain
/*
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
}

+ (void)saveToKeychain:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}

+ (id)loadInKeychain:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}
 */

- (void)showWifiAlert
{
    if (self.isWifiAlertShowing) {
        return;
    }else
    {
        self.isWifiAlertShowing = YES;
        [[[UIAlertView alloc] initWithTitle:@"网络不可用" message:@"无法与服务器通讯。请连接到移动数据网络或者WiFi" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.isWifiAlertShowing = NO;
}



-(BOOL) isAttendRegType{
    return [[UserManager objectForKey:kSMAttendType] intValue] == kTagKaoQinOneChoiceMyReg;
}
-(BOOL) isAttendLeaveType
{
    return [[UserManager objectForKey:kSMAttendType] intValue] == kTagKaoQinOneChoiceMyLeave;
}
-(BOOL) isAttendAuditRegType
{
    return [[UserManager objectForKey:kSMAttendType] intValue] == kTagKaoQinOneChoiceAuditReg;
}

-(BOOL) isAttendAuditLeaveType{
    return [[UserManager objectForKey:kSMAttendType] intValue] == kTagKaoQinOneChoiceAuditLeave;
}
-(void) setAttendType:(int)type
{
    [UserManager setObject:[NSString stringWithFormat:@"%d", type] forKey:kSMAttendType];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
}
-(int) attendType{
    return [[UserManager objectForKey:kSMAttendType] intValue];
}

-(void) setReportType:(int)type
{
    [UserManager setObject:[NSString stringWithFormat:@"%d", type] forKey:kSMReportType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void) setReportNeedtoRefresh:(BOOL)refresh
{
    [UserManager setObject:[NSString stringWithFormat:@"%d", refresh] forKey:kSMReportRefresh];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(BOOL) reportNeedtoRefresh
{
    return [[UserManager objectForKey:kSMReportRefresh] boolValue];
}


-(NSString*)getStringWithKey:(NSString*)key
{
    return [UserManager objectForKey:key];
}
-(void)setString:(NSString*)value withKey:(NSString*)key
{
    [UserManager setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(int)getIntWithKey:(NSString*)key
{
    return [[UserManager objectForKey:key] intValue];
}
-(void)setInt:(int)value withKey:(NSString*)key
{
    NSString *va = [NSString stringWithFormat:@"%d", value];
    [UserManager setObject:va forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//file:///var/mobile/Applications/ABF85393-41ED-40EC-AA57-0AC134771B40/com.knowesoft.legalregs.app/docs/(6)%20%E7%AC%AC%E5%85%AD%E7%BC%96%20%E6%B8%85%E6%B4%81%E7%94%9F%E4%BA%A7%E5%AE%A1%E6%A0%B8/(3)%20%E4%B8%89%20%E5%9B%BD%E5%AE%B6%E6%A0%87%E5%87%86/%E6%B8%85%E6%B4%81%E7%94%9F%E4%BA%A7%E6%A0%87%E5%87%86/%E6%B8%85%E6%B4%81%E7%94%9F%E4%BA%A7%E6%A0%87%E5%87%86%20%E9%93%9C%E7%94%B5%E8%A7%A3%E4%B8%9A.pdf

-(NSArray*)getDocCatalogWithFilter:(NSString *)path
{
    NSFileManager *theFileManager = [NSFileManager defaultManager];
    
    NSArray *theAllURLs = @[];
    NSArray *theURLs = NULL;
    NSError *theError = NULL;
    NSEnumerator *theEnumerator = NULL;
    id theErrorHandler = ^(NSURL *url, NSError *error) { NSLog(@"ERROR: %@", error); return(YES); };
    NSURL *theDocumentsURL = [[theFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL *theBundleURL = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"docs"];
  
    theBundleURL = [theBundleURL URLByStandardizingPath];
    theEnumerator = [theFileManager tx_enumeratorAtURL:theBundleURL includingPropertiesForKeys:NULL options:0 errorHandler:theErrorHandler];
    theURLs = [theEnumerator allObjects];
    theAllURLs = [theAllURLs arrayByAddingObjectsFromArray:theURLs];
    
    
    
    NSArray *theSubDir = NULL;
    theSubDir = [theAllURLs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        BOOL isDir = TRUE;
        return ([[NSFileManager defaultManager] fileExistsAtPath:[evaluatedObject path] isDirectory:&isDir] && isDir);
    }
                                                         ]];
    
    //theSubDir = [theSubDir sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    //    return([[obj1 lastPathComponent] compare:[obj2 lastPathComponent]]);
    //}];
    
    [[UserManager sharedUserManager] setDocCatalog:theSubDir];
    
    //NSArray *firstSplit = [str componentsSeparatedByString:@"|"];
    
    
    theAllURLs = [theAllURLs filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"lastPathComponent LIKE '*.pdf' || lastPathComponent LIKE '*.PDF'"]];
    
    theAllURLs = [theAllURLs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[NSFileManager defaultManager] fileExistsAtPath:[evaluatedObject path]];
    }]];
    
    /*
     theAllURLs = [theAllURLs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
     NSLog(@"evaluatedObject: %@", evaluatedObject);
     BOOL isok = FALSE;
     NSString *pth =[evaluatedObject path];
     if ([[NSFileManager defaultManager] fileExistsAtPath:pth]){
     NSString *lastpth = [[evaluatedObject lastPathComponent] lowercaseString];
     NSRange parametersRange = [lastpth rangeOfString:@".pdf"];
     if (parametersRange.location > 0) {
     isok = TRUE;
     }
     }
     return isok;
     }]];
     */
    
    //theAllURLs = [theAllURLs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    //    return([[obj1 lastPathComponent] compare:[obj2 lastPathComponent]]);
    //}];
    return nil;
}


-(NSArray*)getDocFileWithKeyword:(NSString*)keyword
{
    if (self.docUrls == nil){
        return nil;
    }
    
    NSArray *data = self.docUrls;
    NSArray *finds = @[];
    finds = [data filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *pth = [evaluatedObject lastPathComponent];
        NSRange range = [pth rangeOfString:keyword];
        return (range.length > 0);
    }]];
    
    return finds;
}


-(NSArray*)getDocFileWithLayer:(int)layer filter:(NSString*) parent inPath:(NSString*)inpath
{
    if (self.docUrls == nil){
        return nil;
    }
    
    if (inpath == nil){
        return nil;
    }
    
    if (parent == nil){
        parent = @"docs";
    }
    
    NSArray *data = self.docUrls;
    NSMutableArray *files = [NSMutableArray array];
    NSArray *alls = [data[0] pathComponents];
    int pos = [alls indexOfString:@"docs"]+1;
    
    for (int i = 0; i<[data count]; i++) {
        //NSRange rang = [[[data[i] path] stringByAppendingString:@"/"] rangeOfString:inpath];
        //if (rang.length > 0)
        {
            NSArray *coms = [data[i] pathComponents];
            //NSString *parent2 = [coms objectAtIndex:6+layer];
            //if ([parent2 isEqualToString:parent]){
            //    if ([coms count] > 7+layer){
                    NSString *file = [coms objectAtIndex:pos+layer];
                    if ([[data[i] lastPathComponent] isEqualToString:file]){
                        [files addObject:data[i]];
                    }
            //    }
            //}
        }
    }
    return files;
    
}


-(NSString*)formatDisplayTitle:(NSString*)title
{
    NSArray *data = @[@"(1)",@"(2)",@"(3)",@"(4)",@"(5)",@"(6)",@"(7)",@"(8)",@"(9)",@"(10)"];
    
    NSString *result = title;
    for (int i=0; i<[data count]; i++){
        result = [result stringByReplacingOccurrencesOfString:data[i] withString:@""];
    }
    
    return result;
}

-(NSArray*)getDocCatalogWithLayer:(int)layer filter:(NSString*)parent inPath:(NSString*)inpath
{
    if (self.docCatalog == nil){
        return nil;
    }
    if (inpath == nil){
        return nil;
    }
    
    NSArray *data = self.docCatalog;
    NSMutableArray *catalogs = [NSMutableArray array];
    
    NSArray *alls = [data[0] pathComponents];
    int pos = [alls indexOfString:@"docs"]+1;
    
    for (int i = 0; i<[data count]; i++) {
        //NSRange rang = [[[data[i] path] stringByAppendingString:@"/"] rangeOfString:inpath];
        //if (rang.length > 0)
        {
            NSArray *coms = [data[i] pathComponents];
            if ([coms count] > pos+layer){
                NSString *catalog = [coms objectAtIndex:pos+layer];
                BOOL isdir = true;
                if (parent != nil){
                    NSString *parent2 = [coms objectAtIndex:pos-1+layer];
                    if ([parent isEqualToString:parent2]){
                        isdir = true;
                    }
                    else{
                        isdir = false;
                    }
                }
                
                if ((![catalogs contentString:catalog]) && isdir){
                    [catalogs addObject:catalog];
                }
            }
        }
    }
    return catalogs;
}

-(void)setDocData:(NSArray*)data
{
    [[NSUserDefaults standardUserDefaults] setAccessibilityElements:data];
}

-(NSArray*)addHomeViewHis:(NSString*)file
{
    if (file == nil){
        return _homeArray;
    }
    if ([_homeArray contentString:file]){
        [_homeArray removeObject:file];
    }
    
    NSRange range;
    range = [file rangeOfString:@"docs"];
    if (range.location != NSNotFound) {
        file = [file substringFromIndex:range.location+range.length+1];
        NSLog(@"found at location = %d, length = %d",range.location,range.length);
    } 
    
    [_homeArray insertObject:file atIndex:0];
    //[[NSUserDefaults standardUserDefaults] setObject:_homeArray forKey:kSMHomeViewHisArray];
    NSString *hisString = [_homeArray componentsJoinedByString:@"|"];
    [UserManager setObject:hisString forKey:@"view_his_string"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _needRefreshHomeViewHis = true;
    
    return _homeArray;
}

-(BOOL)homeViewHisChanged;
{
    return _needRefreshHomeViewHis;
}
-(void)setHomeViewHisChanged:(BOOL)changed
{
    _needNotificaionMsg = changed;
}




//-----------wf---------------------
//-----------wf---------------------
//-----------wf---------------------



@end
