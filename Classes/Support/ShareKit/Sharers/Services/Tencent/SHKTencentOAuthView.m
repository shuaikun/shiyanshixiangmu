//
//  SHKTencentOAuthView.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/17/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "SHKTencentOAuthView.h"

@interface SHKTencentOAuthView ()

@end

@implementation SHKTencentOAuthView

- (void)webViewDidFinishLoad:(UIWebView *)aWebView{	
	[self stopSpinner];
	
	if ([webView.request.URL.host isEqualToString:@"open.t.qq.com"]){
        if ([webView.request.URL.absoluteString rangeOfString:@"oauth_verifier"].location != NSNotFound)
        {
            NSMutableDictionary *queryParams = nil;
            if (webView.request.URL.query != nil){
                queryParams = [NSMutableDictionary dictionaryWithCapacity:0];
                NSArray *vars = [webView.request.URL.query componentsSeparatedByString:@"&"];
                NSArray *parts;
                for(NSString *var in vars){
                    parts = [var componentsSeparatedByString:@"="];
                    if (parts.count == 2)
                        queryParams[parts[0]] = parts[1];
                }
            }
            [delegate tokenAuthorizeView:self didFinishWithSuccess:YES queryParams:queryParams error:nil];
            self.delegate = nil;
        }
        
    }	
}


@end
