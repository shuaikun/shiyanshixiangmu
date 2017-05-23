//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewController.h"

@interface SVWebViewController () <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIWebView *mainWebView;
@property (nonatomic, retain) NSURL *URL;

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;
- (void)updateToolbarItems;

- (void)goBackClicked:(UIBarButtonItem *)sender;
- (void)goForwardClicked:(UIBarButtonItem *)sender;
- (void)reloadClicked:(UIBarButtonItem *)sender;
- (void)stopClicked:(UIBarButtonItem *)sender;

@end


@implementation SVWebViewController

@synthesize availableActions;

@synthesize URL, mainWebView;
@synthesize backBarButtonItem, forwardBarButtonItem, refreshBarButtonItem, stopBarButtonItem, titleLabel;

#pragma mark - setters and getters

- (UIBarButtonItem *)backBarButtonItem {
    
    if (!backBarButtonItem) {
        self.backBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClicked:)] autorelease];
        backBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		backBarButtonItem.width = 18.0f;
    }
    return backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    
    if (!forwardBarButtonItem) {
        self.forwardBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/forward"] style:UIBarButtonItemStylePlain target:self action:@selector(goForwardClicked:)] autorelease];
        forwardBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		forwardBarButtonItem.width = 18.0f;
    }
    return forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    
    if (!refreshBarButtonItem) {
        self.refreshBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadClicked:)] autorelease];
    }
    
    return refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    
    if (!stopBarButtonItem) {
        self.stopBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopClicked:)] autorelease];
    }
    return stopBarButtonItem;
}

#pragma mark - Initialization

- (id)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL*)pageURL {
    
    if(self = [super init]) {
        self.URL = pageURL;
        self.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsMailLink;
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    CGFloat navViewTop = -20;
    if (IS_IOS_7) {
        navViewTop = 0;
    }
    UIView *navView = [[[UIView alloc] initWithFrame:CGRectMake(0, navViewTop, 320, 64)] autorelease];
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:navView.bounds] autorelease];
    imageView.image = [UIImage imageNamed:@"nav_bg_red.png"];
    [navView addSubview:imageView];
    
    UIButton *backButton = [[[UIButton alloc] initWithFrame:CGRectMake(-5, 20, 44, 44)] autorelease];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    [backButton setImage:[UIImage imageNamed:@"nav_back_btn.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"nav_back_btn_hl.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(50, 27, 220, 40)] autorelease];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    [self.view addSubview:navView];
    
    CGFloat mainWebViewTop = 44;
    if (IS_IOS_7) {
        mainWebViewTop = 64;
    }
    self.mainWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, mainWebViewTop, 320, [UIScreen mainScreen].bounds.size.height-108)] autorelease];
    mainWebView.delegate = self;
    mainWebView.scalesPageToFit = YES;
    [mainWebView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    [self.view addSubview:mainWebView];
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    [self updateToolbarItems];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.mainWebView = nil;
    self.backBarButtonItem = nil;
    self.forwardBarButtonItem = nil;
    self.refreshBarButtonItem = nil;
    self.stopBarButtonItem = nil;
    self.titleLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
    [self setLoadingView:NO];
}

#pragma mark- 加载框
- (void)setLoadingView:(BOOL)yesOrNo
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.mainWebView.frame];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.3;
       // _maskView.hidden = YES;
        [self.view addSubview:_maskView];
    }

    if (yesOrNo) {
        _maskView.hidden = NO;
        [PROMPT_VIEW showActivity:@"正在加载..."];
    }else {
        _maskView.hidden = YES;
        [PROMPT_VIEW hidden];

    }
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.mainWebView.canGoBack;
    self.forwardBarButtonItem.enabled = self.mainWebView.canGoForward;
    
    UIBarButtonItem *refreshStopBarButtonItem = self.mainWebView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 5.0f;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *items;
    
    if(self.availableActions == 0) {
        items = [NSArray arrayWithObjects:
                 flexibleSpace,
                 self.backBarButtonItem,
                 flexibleSpace,
                 self.forwardBarButtonItem,
                 flexibleSpace,
                 refreshStopBarButtonItem,
                 flexibleSpace,
                 nil];
    } else {
        items = [NSArray arrayWithObjects:
                 fixedSpace,
                 self.backBarButtonItem,
                 flexibleSpace,
                 self.forwardBarButtonItem,
                 flexibleSpace,
                 refreshStopBarButtonItem,
                 fixedSpace,
                 nil];
    }
    self.navigationController.toolbar.tintColor = [UIColor blackColor];
    NSLog(@"%f",self.navigationController.toolbar.frame.size.height);
    self.toolbarItems = items;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self updateToolbarItems];
    [self setLoadingView:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self updateToolbarItems];
    [self setLoadingView:NO];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems];
    [self setLoadingView:NO];

}

#pragma mark - Target actions

- (void)goBackClicked:(UIBarButtonItem *)sender {
    [mainWebView goBack];
}

- (void)goForwardClicked:(UIBarButtonItem *)sender {
    [mainWebView goForward];
}

- (void)reloadClicked:(UIBarButtonItem *)sender {
    [mainWebView reload];
}

- (void)stopClicked:(UIBarButtonItem *)sender {
    [mainWebView stopLoading];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self updateToolbarItems];
}

- (void)doneButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError *)error 
{
	[self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)dealloc
{
    mainWebView.delegate = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.backBarButtonItem = nil;
    self.forwardBarButtonItem = nil;
    self.refreshBarButtonItem = nil;
    self.stopBarButtonItem = nil;
    self.titleLabel = nil;
    self.mainWebView = nil;
    self.URL = nil;
    [super dealloc];
}
@end
