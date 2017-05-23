
//
//  SZWebViewDelegate.m
//  iTotemFramework
//
//  Created by Grant on 14-4-24.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZWebViewDelegate.h"
#import "SZActivityViewController.h"
#import "SZMerchantDetailViewController.h"
#import "SZCouponDetailViewController.h"
#import "SZMembershipCardDetailViewController.h"
#import "KeyboardTextView.h"
#import "SZLoginViewController.h"
#import "SZNewMessageViewController.h"
#import "SZActivityStoreViewController.h"

@interface SZWebViewDelegate ()
<UIAlertViewDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) KeyboardTextView *keyboardView;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) NSString *alertInfo;
@property (nonatomic, strong) NSString *alertCallback;
@end


@implementation SZWebViewDelegate
- (void)loadRequestWithUrlString:(NSString *)urlString
{
    [self clearCach];
    NSMutableString *finalString = [NSMutableString stringWithFormat:@"%@",urlString];
    if (IS_STRING_NOT_EMPTY(urlString)
        && _webView)
    {
//        && [urlString rangeOfString:@"&user_id"].location !=NSNotFound) {
//        if ([[UserManager sharedUserManager] isLogin]) {
//            NSString *userId = [[UserManager sharedUserManager] userId];
//            [finalString appendFormat:@"&user_id=%@&sso_token=%@",userId,SSO_TOKEN];
//        }
        NSURL *url = [NSURL URLWithString:finalString];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        _webView.delegate = self;
        [_webView loadRequest:request];
    }

}

- (void)clearCach
{
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlComps = [urlString
                         componentsSeparatedByString:@"://"];
    if([urlComps count] && [urlComps[0]
                            isEqualToString:@"objc"])
    {
        if ([urlComps count]>1 && urlComps[1]) {
            NSString *functionURL = urlComps[1];
            
            NSArray *functionComps = [functionURL componentsSeparatedByString:@"/?"];
            if ([functionComps count] && functionComps[0]) {
                NSString *functionName = [NSString stringWithFormat:@"%@:callBack:",functionComps[0]];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                NSString *jsFunctionName = nil;
                if ([functionComps count]>1 && functionComps[1]) {
                    NSArray *paramArray = nil;
                    paramArray = [functionComps[1] componentsSeparatedByString:@"&"];
                    for (NSString *paramStr in paramArray) {
                        NSArray *paramComps = [paramStr componentsSeparatedByString:@"="];
                        NSString *key = paramComps[0];
                        NSString *value = @"";
                        if ([paramComps count]>1) {
                            value = paramComps[1];
                        }
                        if ([key isEqualToString:@"callback"]) {
                            jsFunctionName = value;
                            continue;
                        }
                        [params setObject:value forKey:key];
                    }
                }
                [self invokeFunctionName:functionName jsFunctionName:jsFunctionName params:params];
                return NO;
            }
        }
    }
    else if(!_isNestedHtmlRequest && urlString && [urlString hasPrefix:[NSString stringWithFormat:@"%@?app=html&act=news",SZHOST_URL]])
    {
        SZNewMessageViewController *msgVC = [[SZNewMessageViewController alloc] initWithNibName:@"SZNewMessageViewController" bundle:nil];
        [msgVC setupUrl:urlString];
        [UIView pushMasterViewController:msgVC];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (_titleLabel && IS_STRING_NOT_EMPTY(title)) {
        _titleLabel.text = title;
    }

}

- (void)invokeFunctionName:(NSString *)ocFunction
            jsFunctionName:(NSString *)jsFunction
                    params:(NSDictionary *)params
{
    
    SEL ocSel = NSSelectorFromString(ocFunction);
    if ([self respondsToSelector:ocSel]) {
        
        NSMethodSignature *signature = nil;
        signature = [self methodSignatureForSelector:ocSel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:ocSel];
        int argumentNumber = 2;
		if (params) {
			[invocation setArgument:&params atIndex:argumentNumber];
            argumentNumber++;
        }
        if (jsFunction.length>0) {
            [invocation setArgument:&jsFunction atIndex:argumentNumber];
            argumentNumber++;
        }
        [invocation invoke];
    }
}

- (void)userstatus:(NSDictionary *)userInfo callBack:(NSString *)callBack
{

//    NSString *functionStr = [NSString stringWithFormat:@"%@(%@,%@,'%@','%@',%@);",callBack,@"1",@"'man'",@"images/face.png",@"usermy",@"1"];

    __weak typeof(self) weakSelf = self;
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        typeof(weakSelf) strongSelf = weakSelf;
        NSString *gender = [[UserManager sharedUserManager] gender];
        NSString *portraitUrl =[[UserManager sharedUserManager] portraitUrl];
        NSString *realName =[[UserManager sharedUserManager] realName];
        
        NSString *functionStr = [NSString stringWithFormat:@"%@(%@,%@,'%@','%@','%@');",callBack,userId,gender,portraitUrl,realName,[[UserManager sharedUserManager] ssoTokenWithUserId:userId]];
        [strongSelf.webView stringByEvaluatingJavaScriptFromString:functionStr];
    }];
}

- (void)redirect:(NSDictionary *)userInfo callBack:(NSString *)callBack
{
    if (!userInfo) {
        return;
    }
    NSString *type = userInfo[@"type"];
    NSString *goodsId = userInfo[@"id"];
    if (!type || !goodsId) {
        return;
    }
    
    if([type isEqualToString:@"activity"]) {
        SZActivityViewController *activityVC = [[SZActivityViewController alloc] initWithNibName:@"SZActivityViewController" bundle:nil];
        NSString *userId = [[UserManager sharedUserManager] userId];
        [activityVC setupUrlWithACCId:goodsId userId:userId];
        [UIViewController pushMasterViewController:activityVC];
        
    }
    else
    {
        [[UserManager sharedUserManager] getCurrentLocationWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, BOOL isSuccess) {
            if ([type isEqualToString:@"store"]) {
                SZMerchantDetailViewController *merchantViewController = [[SZMerchantDetailViewController alloc] initWithNibName:@"SZMerchantDetailViewController" bundle:nil];
                merchantViewController.requestModel.store_id = goodsId;
                merchantViewController.requestModel.lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
                merchantViewController.requestModel.lng = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
                [UIViewController pushMasterViewController:merchantViewController];
            }else if([type isEqualToString:@"coupon"]) {
                SZCouponDetailViewController *couponDetailViewController = [[SZCouponDetailViewController alloc] initWithNibName:@"SZCouponDetailViewController" bundle:nil];
                couponDetailViewController.goods_id = goodsId;
                couponDetailViewController.lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
                couponDetailViewController.lng = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
                [UIViewController pushMasterViewController:couponDetailViewController];
                
            }else if([type isEqualToString:@"card"]) {
                SZMembershipCardDetailViewController *membershipCardDetailViewController = [[SZMembershipCardDetailViewController alloc] initWithNibName:@"SZMembershipCardDetailViewController" bundle:nil];
                membershipCardDetailViewController.goods_id = goodsId;
                membershipCardDetailViewController.lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
                membershipCardDetailViewController.lng = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
                [UIViewController pushMasterViewController:membershipCardDetailViewController];
                
            }
            else if([type isEqualToString:@"storelist"]) {
                SZActivityStoreViewController *activityStoreViewController = [[SZActivityStoreViewController alloc] initWithNibName:@"SZActivityStoreViewController" bundle:nil];
                activityStoreViewController.accId = goodsId;
                activityStoreViewController.lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
                activityStoreViewController.lng = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
                [UIViewController pushMasterViewController:activityStoreViewController];
            }
            else{
                NSLog(@"unknow type %@",type);
            }
        }];
    
    }
    
    

}

- (void)keyboard:(NSDictionary *)userInfo callBack:(NSString *)callBack
{
    if (_keyboardView == nil) {
        self.keyboardView = [KeyboardTextView instanceFromNib];
    }

    [_keyboardView show];
    [_keyboardView sendBtnDidClickedBlock:^(KeyboardTextView *keyboardTextView, NSString *text) {
        NSString *functionStr = [NSString stringWithFormat:@"%@('%@');",callBack,text];
        [_webView stringByEvaluatingJavaScriptFromString:functionStr];
        [keyboardTextView hide];
        [keyboardTextView destroy];
    }];
    
}

- (void)hideKeyboard:(NSDictionary *)userInfo callBack:(NSString *)callBack
{
    [_keyboardView hide];
}

- (void)alert:(NSDictionary *)userInfo callBack:(NSString *)callBack
{
    NSString *btnLeft =  [userInfo[@"btn0"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *btnRight = [userInfo[@"btn1"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (IS_STRING_EMPTY(btnLeft)) {
        btnLeft = btnRight;
        btnRight = nil;
    }
    if (IS_STRING_EMPTY(btnRight)) {
        btnRight = nil;
    }
    NSString *title = [userInfo[@"title"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *content = [userInfo[@"content"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.alertInfo = userInfo[@"info"];
    self.alertCallback = callBack;
    self.alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:btnLeft otherButtonTitles:btnRight, nil];
    [self.alertView show];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.alertView != alertView) {
        return;
    }
    if (self.alertInfo.length == 0) {
        self.alertInfo = @"";
    }
    
    if (self.alertCallback.length == 0) {
        self.alertCallback = @"";
        
    }else
    {
        NSString *btnIndexStr = [NSString stringWithFormat:@"%d",buttonIndex];
        NSString *functionStr = [NSString stringWithFormat:@"%@('%@',%@);",self.alertCallback,self.alertInfo,btnIndexStr];
        
        [self.webView stringByEvaluatingJavaScriptFromString:functionStr];
    }
    
    self.alertInfo = @"";
    self.alertCallback = @"";
    self.alertView = nil;
}

- (void)hideKeyboard
{
    [_keyboardView hide];
    [_keyboardView destroy];
}
@end
