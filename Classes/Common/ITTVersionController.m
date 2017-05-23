//
//  ITTVersionManager.m
//  iTotemFramework
//
//  Created by Sword on 13-12-17.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "ITTVersionController.h"
#import "ITTVersion.h"
#import "ITTObjectSingleton.h"
#import "ITTMaskActivityView.h"

typedef enum {
	UpdateOptionImmediately,
	UpdateOptionRemindMeLater,
	UpdateOptionRemindNever
}UpdateOption;

#define CHECK_UPDATE_MINIMUM_TIME_INTERVAL 10 //24 * 60 * 60

static NSString *const KEY_REMIND_LATER	= @"KEY_REMIND_LATER";
static NSString *const KEY_REMIND_NEVER	= @"KEY_REMIND_NEVER";
static NSString *const KEY_CHECK_UPDATE_TIMESTAMPE	= @"KEY_CHECK_UPDATE_TIMESTAMPE";
static NSString *const KEY_CHECK_ATLAUNCH	= @"KEY_CHECK_ATLAUNCH";
static NSString *const VersionAppLookupURLFormat = @"http://itunes.apple.com/%@/lookup";
static NSString *const VersioniOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
static NSString *const KEY_APP_ID = @"KEY_APP_ID";

@interface ITTVersionController()<UIAlertViewDelegate, NSURLConnectionDelegate, SKStoreProductViewControllerDelegate>
{
	NSMutableData		*_responseData;
	NSURLConnection		*_connection;
	BOOL				_cancelUpdate;
	ITTVersion			*_version;
	ITTMaskActivityView	*_activityView;
}

@property (nonatomic, strong) ITTVersion *storeVersion;

@end

@implementation ITTVersionController

ITTOBJECT_SINGLETON_BOILERPLATE(ITTVersionController, sharedInstance)

- (id)init
{
    self = [super init];
	if ( self) {
		[self restore];
		[self registerApplicationiNotification];
        [self registerMemoryWarningNotification];
	}
	return self;
}

#pragma mark - private methods
- (void)showIndicator:(BOOL)show
{
	if (!_activityView) {
		_activityView = [ITTMaskActivityView loadFromXib];
	}
	if (show) {
		[_activityView showInView:[self rootView] withHintMessage:@"正在加载..." onCancleRequest:^(ITTMaskActivityView *view){
			_cancelUpdate = TRUE;
			if (_connection) {
				[_connection cancel];
				_connection = nil;
			}
			
			[view hide];
		}];
	}
	else {
		[_activityView hide];
	}
}

- (void)restore
{
	_cancelUpdate = TRUE;
	_showLoadingWhenCheck = FALSE;
	_version = [[ITTVersion alloc] init];
	_version.appid = [USER_DEFAULT stringForKey:KEY_APP_ID];
}

- (void)registerApplicationiNotification
{
	[[NSNotificationCenter defaultCenter] addObserver:USER_DEFAULT
											 selector:@selector(synchronize)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:USER_DEFAULT
											 selector:@selector(synchronize)
												 name:UIApplicationWillTerminateNotification
											   object:nil];
}

- (void)registerMemoryWarningNotification
{
#if TARGET_OS_IPHONE
    // Subscribe to app events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearCacheData)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
#ifdef __IPHONE_4_0
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported){
        // When in background, clean memory in order to have less chance to be killed
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCacheData)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
#endif
#endif
}

- (void)checkUpdateDelay
{
	ITTDINFO(@"checkUpdateDelay");
}

- (void)clearCacheData
{
}

- (ITTVersion*)versionWithData:(NSData*)data
{
	ITTVersion *storeVersion = nil;
	NSError *error = nil;
	id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	ITTDINFO(@"result %@", result);
	if (!error) {
		NSDictionary *appDic = result[@"results"][0];
		storeVersion = [[ITTVersion alloc] initWithDataDic:appDic];
		if (!storeVersion.appid || ![storeVersion.appid length]) {
			storeVersion = nil;
		}
	}
	else {
		ITTDERROR(@"can not parse version update json string");
	}
	return storeVersion;
}

- (UIAlertView*)alertViewWithVersion:(ITTVersion*)version
{
	NSString *versionUpdateTitle = NSLocalizedString(@"VERSION_CHECK_TITLE", @"alert view title");
	NSString *updateImmediately = NSLocalizedString(@"VERSION_UPDATE_IMMEDIATELY", nil);
	NSString *remindLater = NSLocalizedString(@"VERSION_UPDATE_REMIND_LATER", nil);
	NSString *neverRemind = NSLocalizedString(@"VERSION_UPDATE_REMIND_NEVER", nil);
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:versionUpdateTitle message:version.versionDetails delegate:self cancelButtonTitle:nil otherButtonTitles:updateImmediately, remindLater, neverRemind, nil];
	return alertView;
}

- (void)didDoneCheckNewVersionUpdate:(ITTVersion*)storeVersion
{
	[self showIndicator:FALSE];
    //record user selection timestamp
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    [USER_DEFAULT setDouble:timestamp forKey:KEY_CHECK_UPDATE_TIMESTAMPE];
    
	//has update version
	if (NSOrderedDescending == [storeVersion.version compare:_version.version]) {

        self.storeVersion = storeVersion;
		/*
		 * update imeediately, otherwise alert user
		 */
		if (_version.needForceUpdate) {
			[self updateNow];
		}
		else {
			UIAlertView *alertView = [self alertViewWithVersion:storeVersion];
			[alertView show];
		}
	}
}

- (void)checkNewVersion
{
	@synchronized (self) {
        @autoreleasepool {
			if (_showLoadingWhenCheck) {
				[self showIndicator:TRUE];
			}
			NSString *iTunesServiceURL = [NSString stringWithFormat:VersionAppLookupURLFormat, _version.countryCode];
			if (_version.appid && [_version.appid length]) {
				iTunesServiceURL = [iTunesServiceURL stringByAppendingFormat:@"?id=%@", _version.appid];
			}
			else {
				iTunesServiceURL = [iTunesServiceURL stringByAppendingFormat:@"?bundleId=%@", _version.bundleIdentifier];
			}
			ITTDINFO(@"iTunesServiceURL %@", iTunesServiceURL);
			NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:iTunesServiceURL]
													 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
												 timeoutInterval:60];
			_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:TRUE];
		}
	}
}

- (void)updateNow
{
	/*
	 * SKStoreProductViewController is not available before ios6
	 */
    if (_version.builtinUpdate && [SKStoreProductViewController class] && [self.storeVersion.appid length]) {
		[self showIndicator:TRUE];
        _version = self.storeVersion;
		_cancelUpdate = FALSE;
        NSString *identifer = _version.appid;
        SKStoreProductViewController *productViewController = [[SKStoreProductViewController alloc] init];
        productViewController.delegate = self;
        [productViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: identifer}
										 completionBlock:^(BOOL result, NSError *error) {
											[self showIndicator:FALSE];
											 if (!_cancelUpdate && result) {
												 [[self rootViewController] presentViewController:productViewController animated:YES completion:nil];
											 }
											 else {
                                                 [self jumpToAppStoreUpdate];
											 }
										 }];
		
    }
	/*
	 * jump to app sotre to download
	 */
	else {
        [self jumpToAppStoreUpdate];
	}
}

- (void)jumpToAppStoreUpdate
{
    NSURL *url = [NSURL URLWithString:_version.storeUrl];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];        
    }
}

- (UIView*)rootView
{
	if (_rootViewController) {
		return _rootViewController.view;
	}
	else {
		UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
		return keyWindow;
	}
}

- (UIViewController*)rootViewController
{
	if (_rootViewController) {
		return _rootViewController;
	}
	else {
		UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
		UIViewController *rootViewController = keyWindow.rootViewController;
		return rootViewController;
	}
}

- (void)releaseConnection
{
	_connection = nil;
	_responseData = nil;
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	ITTDINFO(@"- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response");
	NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
	if (200 == statusCode) {
		_responseData = [[NSMutableData alloc] init];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	ITTDINFO(@"- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data");
	[_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	ITTDINFO(@"- (void)connectionDidFinishLoading:(NSURLConnection *)connection");
	[self showIndicator:FALSE];
	if (_responseData && [_responseData length]) {
		ITTVersion *storeVersion = [self versionWithData:_responseData];
		if (storeVersion) {
			//same app
			if ([storeVersion.appid isEqualToString:_version.appid] ||
				[storeVersion.bundleIdentifier isEqualToString:_version.bundleIdentifier]) {
				[self didDoneCheckNewVersionUpdate:storeVersion];
			}
		}
	}
	[self releaseConnection];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self releaseConnection];
    [self showIndicator:FALSE];
    
	ITTDERROR(@"- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error");
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [[self rootViewController] dismissViewControllerAnimated:TRUE completion:NULL];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	ITTDINFO(@"button index %d", buttonIndex);
	switch (buttonIndex) {
		case UpdateOptionImmediately:
			[self updateNow];
			break;
		case UpdateOptionRemindMeLater:
			[USER_DEFAULT setBool:TRUE forKey:KEY_REMIND_LATER];
			break;
		case UpdateOptionRemindNever:
			[USER_DEFAULT setBool:TRUE forKey:KEY_REMIND_NEVER];
			break;
		default:
			break;
	}
}

/*!
 * 默认的稍后提醒时间间隔是一天, 此函数用来判断用户上次选择稍后提醒和当前时间的间隔是否超过一天
 */
- (BOOL)expiredSinceLastCheck
{
    BOOL expired = FALSE;
    NSTimeInterval lastCheckTimestamp = [USER_DEFAULT doubleForKey:KEY_CHECK_UPDATE_TIMESTAMPE];
    NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
    if (currentTimestamp - lastCheckTimestamp > CHECK_UPDATE_MINIMUM_TIME_INTERVAL) {
        expired = TRUE;
    }
    return expired;
}

#pragma mark - public methods
- (void)checkUpdate
{
    BOOL remindNever = [USER_DEFAULT boolForKey:KEY_REMIND_NEVER];
    BOOL remindLater = [USER_DEFAULT boolForKey:KEY_REMIND_LATER];
    if (!remindNever) {
        if (remindLater) {
            if ([self expiredSinceLastCheck]) {
                [self checkNewVersion];                
            }
        }
        else {
            [self checkNewVersion];
        }
    }
}

- (void)forceCheckUpdate
{
    [self checkNewVersion];
}

- (void)checkUpdateWithVersion:(ITTVersion*)version
{
    [USER_DEFAULT removeObjectForKey:KEY_REMIND_LATER];
    [USER_DEFAULT removeObjectForKey:KEY_REMIND_NEVER];
    self.storeVersion = version;
    [self didDoneCheckNewVersionUpdate:version];
}
@end
