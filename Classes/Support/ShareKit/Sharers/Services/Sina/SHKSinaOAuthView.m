//
//  SHKSinaOAuthView.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/16/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "SHKSinaOAuthView.h"

@interface SHKSinaOAuthView ()

@end

@implementation SHKSinaOAuthView
- (void)webViewDidFinishLoad:(UIWebView *)aWebView{	
	[self stopSpinner];
	
	if ([webView.request.URL.host isEqualToString:@"api.t.sina.com.cn"]) {
        NSString *pinText = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('getCodeWrap')[0].getElementsByTagName('span')[0].innerHTML"];
		if (pinText && [pinText length] > 0){
			// Get query
			//NSLog(@"pin:%@",pinText);
            NSString *oauth_verifier = pinText;
            NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithCapacity:0];
            
            queryParams[@"oauth_verifier"] = oauth_verifier;
            [delegate tokenAuthorizeView:self didFinishWithSuccess:YES queryParams:queryParams error:nil];
            self.delegate = nil;
			//return NO;
		}
	}
	
	
}


@end
