//
//  AppDelegate.m
//  iTotem
//
//  Created by Rainbow on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ITTTabBarView.h"
#import "CatalogViewController.h"
#import "TabViewController.h"
#import "ITTCommonMacros.h"
#import "LocaleUtils.h"
#import "ITTNetworkTrafficManager.h"
#import "ITTDrawerNavigationViewController.h"
#import "FirstViewController.h"
#import "ITTVersionController.h"
#import "SMHomePageViewController.h"
#import "ImageSliderViewDemoViewController.h"
#import "WXApi.h"
#import "SZNearByViewController.h"
#import "SZMoreViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "SZAllPreferentialViewController.h"
#import "SZMineViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "SZPostDeviceTokenRequest.h"
#import "SZMerchantDetailViewController.h"
#import "SZCouponDetailViewController.h"
#import "SZMembershipCardDetailViewController.h"
#import "SZIntroductionViewController.h"
#import "SZActivityViewController.h"
//#import "MYIntroductionView.h"
#import "SMAttendanceViewController.h"
#import "SMReportMainViewController.h"
#import "SMAttendMainViewController.h"
#import "SZWebViewController.h"
#import "SMDocSearchViewController.h"

#define  APNS_NOTIFICATION_HAS_NEW_ADict             @"is_apns_notification_has_new_aDict"

#import "XGPush.h"
#import "XGSetting.h"

#import <SMS_SDK/SMS_SDK.h>


@interface AppDelegate ()
<MYIntroductionDelegate>
{
    ITTTabBarView *_customTabBarView;     
}
@end


@implementation AppDelegate

@synthesize tabBarController = _tabBarController;
@synthesize homePageController = _homePageController;

static AppDelegate *_appDelegate;
#pragma mark - private methods
- (void)consoleDeviceNetworkTrafficStatus
{
    [[ITTNetworkTrafficManager sharedManager] consoleDeviceNetworkTrafficInfo];
}

#pragma mark - public methods
+ (AppDelegate*)GetAppDelegate
{
    return _appDelegate;
}

#pragma mark - lifecyle methods

- (void)dealloc
{
    _appDelegate = nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationFade)];
    
	ITTDINFO(@"%@", [[NSBundle mainBundle] infoDictionary]);
    //test for commit
    _appDelegate = self;
    _window = [[ITTIdlingWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[UIDevice currentDevice] is4InchScreen]) {
        ITTDINFO(@"this is iphone 5 4-inch screen");
    }
    BOOL ok = true;
	
	
    //注册push
    if ([[UserManager sharedUserManager] needNotificaionMsg]) {
        ok = [self push_application:application didFinishLaunchingWithOptions:launchOptions];
        //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    }

    [self setupShareSDK];
    [self setupRootViewController];
    [self setupIntroView];
    [self setupUmengSDK];
    
    //init status bar window
//    _statusBarWindow = [[ITTStatusBarWindow alloc] init];
//    [_statusBarWindow makeKeyAndVisible];
    
    ITTDINFO(@"mac address:%@", [[UIDevice currentDevice] macAddress]);
    ITTDINFO(@"platformString] %@", [[UIDevice currentDevice] platformString]);
    ITTDINFO(@"userMemory %fM", [[UIDevice currentDevice] userMemory]/(1024*1024.0));
    ITTDINFO(@"totalMemory %fM", [[UIDevice currentDevice] totalMemory]/(1024*1024.0));
    ITTDINFO(@"device identifier %@", [[UIDevice currentDevice] deviceIdentifier]);
    /*
    //setup MagicalRecord for CoreData
    [MagicalRecordHelpers setupCoreDataStackWithStoreNamed:@"MyDatabase.sqlite"];
    [self consoleDeviceNetworkTrafficStatus];
    */
    ITTDINFO(@"local:%@", [LocaleUtils getLanguageCode]);
    ITTDINFO(@"didFinishLaunchingWithOptions");
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        //这里定义自己的处理方式
        [self parsePushNotificationWithDictionay:userInfo];
    }
    
    return ok;
}

- (void)setupShareSDK
{
    [SMS_SDK registerApp:WW_MobSMS_AppKey withSecret:WW_MobSMS_AppSecret];
    
    /**
     
     //激活托管模式
     //[ShareSDK registerApp:SZ_ShareSDK_APP_KEY  useAppTrusteeship:YES];
     //托管模式
     //    [ShareSDK importWeChatClass:[WXApi class]];
     //托管模式
     //    [ShareSDK importQQClass:[QQApiInterface class]
     //            tencentOAuthCls:[TencentOAuth class]];
     //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
     
     */
    
    
    //非托管配置 ShareSDK
    [ShareSDK registerApp:SZ_ShareSDK_APP_KEY];
    [ShareSDK connectSinaWeiboWithAppKey:SZ_ShareSDK_WEIBO_APP_KEY
                               appSecret:SZ_ShareSDK_WEIBO_APP_SECRET
                             redirectUri:SZ_ShareSDK_WEIBO_APP_RedirectURL];
    
    [ShareSDK connectWeChatWithAppId:SZ_ShareSDK_WEIXIN_APP_ID       //此参数为申请的微信AppID
                           wechatCls:[WXApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:SZ_ShareSDK_QZONE_APP_KEY    //该参数填入申请的QQ AppId
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectQZoneWithAppKey:SZ_ShareSDK_QZONE_APP_KEY      //该参数填入申请的QQ AppId
                           appSecret:SZ_ShareSDK_QZONE_APP_SECRET
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
}

- (void)setupUmengSDK
{
//channelId为nil或@""时，默认会被被当作@"App Store"渠道
    [MobClick startWithAppkey:SZ_Umeng_APP_KEY reportPolicy:SEND_INTERVAL   channelId:nil];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //打开debug模式
    [MobClick setLogEnabled:YES];
    [MobClick checkUpdate];
    //关闭错误报告
    [MobClick setCrashReportEnabled:YES];
}


#pragma mark - setup root ViewController

- (void)setupRootViewController
{
    /*
    _tabBarController = [[HomeTabBarController alloc] init];
    _masterNavigationController = [[UINavigationController alloc] initWithRootViewController:_tabBarController];
    _masterNavigationController.navigationBar.hidden = YES;
    _window.rootViewController = _masterNavigationController;
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    */
    
    
    _homePageController = [[WWHomePageViewController alloc] init];
    _masterNavigationController = [[UINavigationController alloc] initWithRootViewController:_homePageController];
    _masterNavigationController.navigationBar.hidden = YES;
    _window.rootViewController = _masterNavigationController;
    //_window.backgroundColor = [UIColor greenColor];
    [_window makeKeyAndVisible];
}

- (void)skipIntro
{
    [[self introductionView] skipIntroduction];
    //[self introductionDidFinishWithType:MYFinishTypeSkipButton];
}

- (void)setupIntroView
{
//纵向介绍页
//    if ([[UserManager sharedUserManager] isFirstOpenForViewControllerClass:[SZIntroductionViewController class]]) {
//        SZIntroductionViewController *introVC = [[SZIntroductionViewController alloc] initWithNibName:@"SZIntroductionViewController" bundle:nil];
//        introVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        __weak typeof(self) weakSelf = self;
//        [introVC showIntroductionWithFinishBlock:^{
//            [weakSelf setupTabs:YES];
//        }];
//        
//        
//        [_window.rootViewController presentViewController:introVC animated:YES completion:nil];
//    }else
//    {
//        [self setupTabs:YES];
//    }
//横向介绍页
    
    
    //[self setupTabs:NO];
    //return;
    
    //if ([[UserManager sharedUserManager] isFirstOpenForViewControllerClass:[MYIntroductionPanel class]]){
    MYIntroductionPanel *panel;
    //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if (self.window.frame.size.height <= 480){
        panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Default"] description:@""];
    }
    else if (self.window.frame.size.height > 480 && self.window.frame.size.height <= 960){
        panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Default-667h@2x"] description:@""];
    }
    else if (self.window.frame.size.height > 960 && self.window.frame.size.height <= 1136){
        panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Default-568h@2x"] description:@""];
    }
    else if (self.window.frame.size.height > 1136 && self.window.frame.size.height <= 1334){
        panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Default-667h@2x"] description:@""];
    }
        //STEP 1 Construct Panels
    
        //You may also add in a title for each panel
        //MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"SZ_INTRO_PAGE_2"] description:@""];
        
        //MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"SZ_INTRO_PAGE_3"] description:@""];
        
        /*A more customized version*/
        _introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height) headerText:nil panels:@[panel] languageDirection:MYLanguageDirectionLeftToRight];
        [_introductionView setBackgroundImage:nil];
        
        //Set delegate to self for callbacks (optional)
        _introductionView.delegate = self;
        
        //STEP 3: Show introduction view
        [_introductionView showInView:self.window];
    
        [self performSelector:@selector(skipIntro) withObject:nil afterDelay:4.0];
    
    
        //setNeedsStatusBarAppearanceUpdate];
    
    //}else
    //{
    //    [self setupTabs:NO];
    //}

}
#pragma mark - MYIntroductionDelegate
-(void)introductionDidFinishWithType:(MYFinishType)finishType{
    if (finishType == MYFinishTypeSkipButton) {
        NSLog(@"Did Finish Introduction By Skipping It");
    }
    else if (finishType == MYFinishTypeSwipeOut){
        NSLog(@"Did Finish Introduction By Swiping Out");
    }
    
    [self setupTabs:NO];
}

- (void)setupTabs:(BOOL)needLocationSuggest
{
    NSMutableArray *viewControllers = [NSMutableArray array];
 
    
   
    SZNearByViewController *nearByViewController = [[SZNearByViewController alloc] initWithNibName:@"SZNearByViewController" bundle:nil];
    nearByViewController.pageFrom = SZNearByPageFromDefault;
    UINavigationController *tabNavController2 = [[UINavigationController alloc] initWithRootViewController:nearByViewController];
    tabNavController2.navigationBarHidden = YES;
    [viewControllers addObject:tabNavController2];
     
    
    
    SMDocSearchViewController *tabViewController3 = [[SMDocSearchViewController alloc] initWithNibName:@"SMDocSearchViewController" bundle:nil];
    UINavigationController *tabNavController3 = [[UINavigationController alloc] initWithRootViewController:tabViewController3];
    tabNavController3.navigationBarHidden = YES;
    [viewControllers addObject:tabNavController3];
    
    SMHomePageViewController *tabViewController1 = [[SMHomePageViewController alloc] initWithNibName:@"SMHomePageViewController" bundle:nil];
    UINavigationController *tabNavController1 = [[UINavigationController alloc] initWithRootViewController:tabViewController1];
    tabNavController1.navigationBarHidden = YES;
    [tabViewController1 needLocationSuggest:needLocationSuggest];
    [viewControllers addObject:tabNavController1];
    
    
    /*
    SMAttendanceViewController *tabViewController3 = [[SMAttendanceViewController alloc] initWithNibName:@"SMAttendanceViewController" bundle:nil];
    UINavigationController *tabNavController3 = [[UINavigationController alloc] initWithRootViewController:tabViewController3];
    tabNavController3.navigationBarHidden = YES;
    [viewControllers addObject:tabNavController3];
    */
    
    /*
    SZAllPreferentialViewController *tabViewController3 = [[SZAllPreferentialViewController alloc] initWithNibName:@"SZAllPreferentialViewController" bundle:nil];
    UINavigationController *tabNavController3 = [[UINavigationController alloc] initWithRootViewController:tabViewController3];
    tabNavController3.navigationBarHidden = YES;
    [viewControllers addObject:tabNavController3];
    */
    
    /*
    SZMineViewController *tabViewController4 = [[SZMineViewController alloc] initWithNibName:@"SZMineViewController" bundle:nil];
    UINavigationController *tabNavController4 = [[UINavigationController alloc] initWithRootViewController:tabViewController4];
    tabNavController4.navigationBarHidden = YES;
    [viewControllers addObject:tabNavController4];
    
    SZMoreViewController *moreViewController = [[SZMoreViewController alloc] initWithNibName:@"SZMoreViewController" bundle:nil];
    UINavigationController *tabNavController5 = [[UINavigationController alloc] initWithRootViewController:moreViewController];
    tabNavController5.navigationBarHidden = YES;
    [viewControllers addObject:tabNavController5];
     */
    
    _tabBarController.viewControllers = viewControllers;
    _tabBarController.selectedIndex = 0;
}

- (void)resetTabs
{
    [self setupTabs:NO];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application{
    [MagicalRecordHelpers cleanUp];
}

- (UINavigationController *)currentNavigationController
{
    UINavigationController *selectedVC = (UINavigationController *)[_tabBarController selectedViewController];
    return selectedVC;
}
//URL 回调方法
- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}


#pragma mark - NOTIFICATION
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [self push_application:app didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    //    ed7080aaa364874dc8a722a73d75f16d06ba3432e0594afa68e259fa5267b062
    NSString *newToken = [NSString stringFromDeviceToken:deviceToken];
    NSLog(@"push token====%@",newToken);
    [[UserManager sharedUserManager] setApnsId:newToken];
    
    // post the token to server when only people choose the site
//    [self postDeviceTokenAndUserInfo:newToken isOpen:[[UserManager sharedUserManager] needNotificaionMsg]];
}

//注册push功能失败 后 返回错误信息，执行相应的处理
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Error in registration for APNS. Error: %@", error);
    [self push_application:app didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self parsePushNotificationWithDictionay:userInfo];
    [self push_application:application didReceiveRemoteNotification:userInfo];
}

- (void)parsePushNotificationWithDictionay:(NSDictionary *)userInfo
{
    if (![[UserManager sharedUserManager] needNotificaionMsg]) {
        return;
    }
    
    NSDictionary *apnsDictid = [userInfo objectForKey:@"aps"];
    NSInteger badge     = [[apnsDictid objectForKey:@"badge"] integerValue];
    NSString *alert     = [apnsDictid objectForKey:@"alert"];
    
    NSString *content   = [userInfo objectForKey:@"content"];
    NSString *actionType= [userInfo objectForKey:@"action_type"];
    NSString *actionId  = [userInfo objectForKey:@"action_id"];
    NSString *pushId    = [userInfo objectForKey:@"id"];
    
    NSString *url       = [userInfo objectForKey:@"url"];
    
    alert       = IsNull(alert)     ?@"":alert;
    content     = IsNull(content)   ?@"":content;
    actionType  = IsNull(actionType)?@"":actionType;
    actionId    = IsNull(actionId)  ?@"":actionId;
    pushId      = IsNull(pushId)    ?@"":pushId;
    
    actionType  = IsNull(url)       ?actionType:@"url";
    actionId    = IsNull(url)       ?actionId:url;
    url         = IsNull(url)       ?@"":url;
    
    
    UIApplication *application = [UIApplication sharedApplication];
    if (application.applicationState == UIApplicationStateActive) {
        NSDictionary *newDict = @{@"title"      : alert
                                  ,@"content"   : content
                                  ,@"actionType": actionType
                                  ,@"actionId"  : actionId
                                  ,@"pushId"    : pushId
                                  ,@"url"       : url};

        [[NSUserDefaults standardUserDefaults] setObject:newDict forKey:APNS_NOTIFICATION_HAS_NEW_ADict];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIAlertView *apsAlter = [[UIAlertView alloc]initWithTitle:nil message:alert delegate:self cancelButtonTitle:@"忽略"  otherButtonTitles:@"查看", nil];
        [apsAlter show];
    }else
    {
        if ([actionType isEqualToString:@"url"]){
            [self showWebViewControllWithType:actionType Url:actionId Title:alert];
        }else{
            [self showViewControllerWithType:actionType goodsId:actionId];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary *apnDict = [[NSUserDefaults standardUserDefaults]objectForKey:APNS_NOTIFICATION_HAS_NEW_ADict];
        if (apnDict)
        {
            NSLog(@"**********推送消息****%@",apnDict);
            NSString *actionType= [apnDict objectForKey:@"actionType"];
            NSString *actionId  = [apnDict objectForKey:@"actionId"];
            if ([actionType isEqualToString:@"url"]){
                [self showWebViewControllWithType:actionType Url:actionId Title:[apnDict objectForKey:@"title"]];
            }
            else{
                [self showViewControllerWithType:actionType goodsId:actionId];
            }
        }else
        {
            [self clearApnsInformation];
        }
    }
}



-(void)clearApnsInformation {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:APNS_NOTIFICATION_HAS_NEW_ADict];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:0];
}


- (void)postDeviceTokenAndUserInfo:(NSString *)tokenString isOpen:(BOOL)isOpen{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SZINDEX_BROADCAST_METHORD forKey:PARAMS_METHOD_KEY];
    if (IS_STRING_EMPTY(tokenString)) {
        NSLog(@"push token is empty, using simulator?");
        return;
    }
    [dict setObject:tokenString forKey:@"imei"];
    [dict setObject:@"ios" forKey:@"plat"];
    if (isOpen) {
        [dict setObject:@"1" forKey:@"open"];//1开
    }else
    {
        [dict setObject:@"0" forKey:@"open"];//0关
    }

//    if ([[UserManager sharedUserManager] isLogin]) {
//        [dict setObject:[[UserManager sharedUserManager] userId] forKey:@"user_id"];
//    }
    
    [SZPostDeviceTokenRequest requestWithParameters:dict withIndicatorView:nil withCancelSubject:nil
                                     onRequestStart:nil
                                  onRequestFinished:^(ITTBaseDataRequest *request) {
                                      [[UserManager sharedUserManager] setNeedNotificaionMsg:isOpen];
                                  }
                                  onRequestCanceled:nil
                                    onRequestFailed:nil];
}

-(void) showWebViewControllWithType:(NSString *)type Url:(NSString *)url Title:(NSString *)title
{
    // 清除数据
    [MobClick event:UMNotificationClick];
    [self clearApnsInformation];
    if (IS_STRING_NOT_EMPTY(type)){
        if ([type isEqualToString:@"url"]){
            SZWebViewController *activityVC = [[SZWebViewController alloc] initWithNibName:@"SZWebViewController" bundle:nil];
            [activityVC setUrlStr:url];
            [activityVC setTitle:title];
            [UIViewController pushMasterViewController:activityVC];
        }
    }
}

//消息落地
- (void)showViewControllerWithType:(NSString *)type
                           goodsId:(NSString *)goodsId
{
    // 清除数据
    [MobClick event:UMNotificationClick];
    [self clearApnsInformation];
    if (IS_STRING_NOT_EMPTY(type)){
        if ([type isEqualToString:@"url"]){
            SZWebViewController *activityVC = [[SZWebViewController alloc] initWithNibName:@"SZWebViewController" bundle:nil];
            [activityVC setUrlStr:goodsId];
            [activityVC setTitle:@""];
            [UIViewController pushMasterViewController:activityVC];
            return;
        }
    }
    
    if (IS_STRING_NOT_EMPTY(type) && IS_STRING_NOT_EMPTY(goodsId))
    {
        [[UserManager sharedUserManager] getCurrentLocationWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, BOOL isSuccess) {
            if ([type isEqualToString:@"1"]) {
                SZActivityViewController *activityVC = [[SZActivityViewController alloc] initWithNibName:@"SZActivityViewController" bundle:nil];
                NSString *userId = [[UserManager sharedUserManager] userId];
                [activityVC setupUrlWithACCId:goodsId userId:userId];
                [UIViewController pushMasterViewController:activityVC];
            }else if ([type isEqualToString:@"2"]) {
                SZMerchantDetailViewController *merchantViewController = [[SZMerchantDetailViewController alloc] initWithNibName:@"SZMerchantDetailViewController" bundle:nil];
                merchantViewController.requestModel.store_id = goodsId;
                merchantViewController.requestModel.lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
                merchantViewController.requestModel.lng = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];;
                [UIViewController pushMasterViewController:merchantViewController];
            }else if([type isEqualToString:@"3"]) {
                SZCouponDetailViewController *couponDetailViewController = [[SZCouponDetailViewController alloc] initWithNibName:@"SZCouponDetailViewController" bundle:nil];
                couponDetailViewController.goods_id = goodsId;
                couponDetailViewController.lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
                couponDetailViewController.lng = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
                [UIViewController pushMasterViewController:couponDetailViewController];
                
            }else if([type isEqualToString:@"4"]) {
                SZMembershipCardDetailViewController *membershipCardDetailViewController = [[SZMembershipCardDetailViewController alloc] initWithNibName:@"SZMembershipCardDetailViewController" bundle:nil];
                membershipCardDetailViewController.goods_id = goodsId;
                membershipCardDetailViewController.lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
                membershipCardDetailViewController.lng = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
                [UIViewController pushMasterViewController:membershipCardDetailViewController];
                
            }else{
                NSLog(@"unknow type %@",type);
            }
        }];
    }

}

#pragma mark - ShareSDK

- (void)shareWithTitle:(NSString *)title
               content:(NSString *)content
                 image:(UIImage *)image
{
    [self shareWithContent:content
            defaultContent:nil
                     image:image
                     title:title
                       url:APP_DOWNLOAD_URL
               description:content
                 mediaType:SSPublishContentMediaTypeNews];
}



- (void)shareWithContent:(NSString *)content
          defaultContent:(NSString *)defaultContent
                   image:(UIImage *)image
                   title:(NSString *)title
                     url:(NSString *)url
             description:(NSString *)description
               mediaType:(SSPublishContentMediaType)mediaType

{
    id<ISSContent> publishContent = nil;
    if (image) {
        publishContent = [ShareSDK content:content
                                           defaultContent:defaultContent
                                                    image:[ShareSDK imageWithData:UIImageJPEGRepresentation(image, 0.8) fileName:@"sharedImage" mimeType:@"image/jpeg"]
                                                    title:title
                                                      url:url
                                              description:description
                                                mediaType:mediaType];
    }else
    {
        publishContent = [ShareSDK content:content
                                           defaultContent:defaultContent
                                                    image:nil
                                                    title:title
                                                      url:url
                                              description:description
                                                mediaType:SSPublishContentMediaTypeNews];
    }
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                    if (ShareTypeWeixiFav == type) {
                                        [PROMPT_VIEW showMessage:@"收藏成功"];
                                    }else
                                    {
                                        [PROMPT_VIEW showMessage:@"分享成功"];
                                    }

                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                    if (ShareTypeWeixiFav == type) {
                                        [PROMPT_VIEW showMessage:@"收藏失败"];
                                    }else
                                    {
                                        [PROMPT_VIEW showMessage:@"分享失败"];
                                    }
                                }
                            }];

}




//------------------------------------------------------------------------------------------------------------
//  push
//------------------------------------------------------------------------------------------------------------

- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

- (BOOL)push_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
#ifdef __IPHONE_8_0 //这里主要是针对iOS 8.0,相应的8.1,8.2等版本各程序员可自行发挥，如果苹果以后推出更高版本还不会使用这个注册方式就不得而知了……
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }  else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
#else
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
    
    
    [XGPush startApp:2200135290 appKey:@"I3AF9U4X26YM"];
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    //[XGPush registerPush];  //注册Push服务，注册后才能收到推送
    [XGPush handleLaunching:launchOptions];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //清除所有通知(包含本地通知)
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    
    //本地推送示例
    /*
     NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:10];
     
     NSMutableDictionary *dicUserInfo = [[NSMutableDictionary alloc] init];
     [dicUserInfo setValue:@"myid" forKey:@"clockID"];
     NSDictionary *userInfo = dicUserInfo;
     
     [XGPush localNotification:fireDate alertBody:@"测试本地推送" badge:2 alertAction:@"确定" userInfo:userInfo];
     */
    
    // Override point for customization after application launch.
    return YES;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    
    //删除推送列表中的这一条
    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    
    //清空推送列表
    //[XGPush clearLocalNotifications];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    [application registerForRemoteNotifications];
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif


- (void)push_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock ,deviceToken: %@",deviceTokenStr);
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
    //注册设备
    [[XGSetting getInstance] setChannel:@"appstore"];
    [[XGSetting getInstance] setGameServer:@"OAX"];
    [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
    //[XGPush registerDevice:deviceToken];
    
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
}

//如果deviceToken获取不到会进入此事件
- (void)push_application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    //[PROMPT_VIEW showMessage:str];
    NSLog(@"%@",str);
    
}

- (void)push_application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
    
    
    //回调版本示例
    /*
     void (^successBlock)(void) = ^(void){
     //成功之后的处理
     NSLog(@"[XGPush]handleReceiveNotification successBlock");
     };
     
     void (^errorBlock)(void) = ^(void){
     //失败之后的处理
     NSLog(@"[XGPush]handleReceiveNotification errorBlock");
     };
     
     void (^completion)(void) = ^(void){
     //失败之后的处理
     NSLog(@"[xg push completion]userInfo is %@",userInfo);
     };
     
     [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
     */
}









@end
