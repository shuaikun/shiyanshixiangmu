//
//  SHKTwitterAuthView.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/21/10.

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import "SHKOAuthView.h"
#import "SHK.h"
#import "SHKOAuthSharer.h"

@implementation SHKOAuthView

@synthesize webView, delegate, spinner;

- (void)dealloc
{
	[webView release];
	[delegate release];
	[spinner release];
	[super dealloc];
}

- (id)initWithURL:(NSURL *)authorizeURL delegate:(id)d
{
    if ((self = [super initWithNibName:nil bundle:nil])) 
	{
		[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																								 target:self
																								 action:@selector(cancel)] autorelease] animated:NO];
		
		self.delegate = d;
		
        UIWebView *wv = [[UIWebView alloc] initWithFrame:CGRectZero];
		self.webView = wv;
        [wv release];
		webView.delegate = self;
		webView.scalesPageToFit = YES;
		webView.dataDetectorTypes = UIDataDetectorTypeNone;
		[webView release];
		
		[webView loadRequest:[NSURLRequest requestWithURL:authorizeURL]];		
		
    }
    return self;
}

- (void)loadView 
{ 	
	self.view = webView;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	// Remove the SHK view wrapper from the window
	[[SHK currentHelper] viewWasDismissed];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{	
	if(delegate == nil){
        return YES;
    }
	
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[self startSpinner];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView{	
	[self stopSpinner];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{	
	if ([error code] != NSURLErrorCancelled && [error code] != 102 && [error code] != NSURLErrorFileDoesNotExist)
	{
		[self stopSpinner];
		[delegate tokenAuthorizeView:self didFinishWithSuccess:NO queryParams:nil error:error];
	}
}

- (void)startSpinner
{
	if (spinner == nil)
	{
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		self.spinner = indicator;
        [indicator release];
		[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:spinner] autorelease] animated:NO];
		spinner.hidesWhenStopped = YES;
		[spinner release];
	}
	
	[spinner startAnimating];
}

- (void)stopSpinner
{
	[spinner stopAnimating];	
}


#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (void)cancel
{
	[delegate tokenAuthorizeCancelledView:self];
	[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
}

@end
