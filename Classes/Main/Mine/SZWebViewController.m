//
//  SZWebViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-5-6.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZWebViewController.h"

@interface SZWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SZWebViewController

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
    
    UIColor *topColor = UIColorBackground;
    [[self view] setBackgroundColor:topColor];
    [[self baseTopView] setBackgroundColor: topColor];
    if (IS_STRING_EMPTY(_topViewTitle)){
        _topViewTitle = @"网页";
    }
    [self setTitle:_topViewTitle];
    
    if(IS_STRING_NOT_EMPTY(_urlStr)){
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
        [PROMPT_VIEW showActivity:@"数据载入中"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    
    if (IS_STRING_NOT_EMPTY(_htmlStr)){
        [PROMPT_VIEW showActivity:@"数据载入中"];
        NSString *htmlString = @"<!doctype html><html><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0\"><meta name=\"format-detection\" content=\"telephone=no\"><link href=\"http://s0.pstatp.com/inapp/TTDefaultCSS.css\" rel=\"stylesheet\" type=\"text/css\"></head><body><article>";
        
        //_htmlStr = [_htmlStr stringByReplacingOccurrencesOfString:@" src=" withString:@" alt_src="];
        _htmlStr = [_htmlStr stringByReplacingOccurrencesOfString:@" height=" withString:@" alt_height="];
        _htmlStr = [_htmlStr stringByReplacingOccurrencesOfString:@" HEIGHT:" withString:@" alt_height:"];
        _htmlStr = [_htmlStr stringByReplacingOccurrencesOfString:@" border=" withString:@" alt_border="];
        
        htmlString = [htmlString stringByAppendingString:_htmlStr];
        htmlString = [htmlString stringByAppendingString:@"</article></body></html>"];
        
        [_webView loadHTMLString:htmlString baseURL:nil];
        //[_webView setScalesPageToFit:YES];
        [_webView setContentScaleFactor:1.0];         

        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [PROMPT_VIEW hideWithAnimation];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [PROMPT_VIEW hideWithAnimation];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if([error code] != NSURLErrorCancelled){
        NSLog(@"%@", error);
        [PROMPT_VIEW showMessage:@"加载失败"];
    }
}

- (void)baseTopViewBackButtonClicked
{
    if([_webView canGoBack]){
        [_webView goBack];
    }
    else{
        [_webView stopLoading];
        [self popMasterViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
