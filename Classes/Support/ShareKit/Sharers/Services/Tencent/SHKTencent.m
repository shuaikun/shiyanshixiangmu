//
//  SHKTencent.m
//  AsiaScene
//
//  Created by Rainbow on 5/4/11.
//  Copyright 2011 iTotemStudio. All rights reserved.
//

#import "SHKTencent.h"
#import "SHKTencentOAuthView.h"
#import "OAMutableURLRequestForTencent.h"
#import "OAAsynchronousDataFetcherForTencent.h"

@implementation NSURL (QAdditions)

#pragma mark -
#pragma mark Class methods

+ (NSDictionary *)parseURLQueryString:(NSString *)queryString {
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
	for(NSString *pair in pairs) {
		NSArray *keyValue = [pair componentsSeparatedByString:@"="];
		if([keyValue count] == 2) {
			NSString *key = keyValue[0];
			NSString *value = keyValue[1];
			value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			if(key && value)
				dict[key] = value;
		}
	}
	return [NSDictionary dictionaryWithDictionary:dict];
}
@end

@implementation SHKTencent

@synthesize xAuth;
@synthesize delegate;

- (id)init{
	if ((self = [super init])){	
		// OAUTH		
		self.consumerKey = SHKTencentKey;		
		self.secretKey = SHKTencentSecret;
 		self.authorizeCallbackURL = [NSURL URLWithString:SHKTencentCallbackUrl];// HOW-TO: In your Twitter application settings, use the "Callback URL" field.  If you do not have this field in the settings, set your application type to 'Browser'.
		
		// XAUTH
		self.xAuth = NO;
		
		// You do not need to edit these, they are the same for everyone
	    self.authorizeURL = [NSURL URLWithString:@"https://open.t.qq.com/cgi-bin/authorize"];
	    self.requestURL = [NSURL URLWithString:@"https://open.t.qq.com/cgi-bin/request_token"];
	    self.accessURL = [NSURL URLWithString:@"https://open.t.qq.com/cgi-bin/access_token"]; 
        
	}	
	return self;
}


#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle{
	return @"腾讯微博";
}

#pragma mark -
#pragma mark Configuration : Dynamic Enable

- (BOOL)shouldAutoShare{
	return NO;
}


#pragma mark -
#pragma mark Authorization
- (Class)getOAuthViewClass{
    return [SHKTencentOAuthView class];
}


- (BOOL)isAuthorized{		
	return [self restoreAccessToken];
}

- (void)promptAuthorization{		
	if (xAuth){
		[super authorizationFormShow]; // xAuth process
	}else{
		[super promptAuthorization]; // OAuth process		
	}
}


#pragma mark xAuth

+ (NSString *)authorizationFormCaption{
	return @"创建一个腾讯微博帐号";
}

+ (NSArray *)authorizationFormFields{
	return @[[SHKFormFieldSettings label:@"用户名" key:@"username" type:SHKFormFieldTypeText start:nil],
			[SHKFormFieldSettings label:@"密码" key:@"password" type:SHKFormFieldTypePassword start:nil]];
}

- (void)authorizationFormValidate:(SHKFormController *)form{
	self.pendingForm = form;
	[self tokenAccess];
}
- (void)tokenRequestModifyRequest:(OAMutableURLRequest *)oRequest{
	[oRequest setOAuthParameterName:@"oauth_callback" withValue:authorizeCallbackURL.absoluteString];
}
- (void)tokenAccessModifyRequest:(OAMutableURLRequest *)oRequest{	
	[oRequest setOAuthParameterName:@"oauth_verifier" withValue:(self.authorizeResponseQueryVars)[@"oauth_verifier"]];
}
// override super class for some special logic
- (void)tokenRequest
{
	[[SHKActivityIndicator currentIndicator] displayActivity:@"连接中..."];
    OAMutableURLRequestForTencent *oRequest = [[OAMutableURLRequestForTencent alloc] initWithURL:requestURL 
                                                                                        consumer:consumer token:nil 
                                                                                           realm:nil 
                                                                               signatureProvider:signatureProvider 
                                                                                           nonce:[self generateNonce] 
                                                                                       timestamp:[NSString stringWithFormat:@"%ld", time(NULL)]];
    
	
    [oRequest setHTTPMethod:@"POST"];
	[self tokenRequestModifyRequest:oRequest];
	
    OAAsynchronousDataFetcherForTencent *fetcher = [OAAsynchronousDataFetcherForTencent asynchronousTencentFetcherWithRequest:oRequest
                                                                                                                     delegate:self
                                                                                                            didFinishSelector:@selector(tokenRequestTicket:didFinishWithData:)
                                                                                                              didFailSelector:@selector(tokenRequestTicket:didFailWithError:)];
    
    [fetcher startByUrl:[requestURL absoluteString]];
    
	[oRequest release];
}
- (void)tokenAccess:(BOOL)refresh
{
	if (!refresh)
		[[SHKActivityIndicator currentIndicator] displayActivity:@""];
	
    OAMutableURLRequestForTencent *oRequest = [[OAMutableURLRequestForTencent alloc] initWithURL:accessURL consumer:consumer token:(refresh ? accessToken : requestToken) realm:nil signatureProvider:signatureProvider nonce:[self generateNonce] timestamp:[NSString stringWithFormat:@"%ld", time(NULL)]];
    
    [oRequest setHTTPMethod:@"POST"];
	
	[self tokenAccessModifyRequest:oRequest];
	
    OAAsynchronousDataFetcherForTencent *fetcher = [OAAsynchronousDataFetcherForTencent asynchronousTencentFetcherWithRequest:oRequest
                                                                                                                     delegate:self
                                                                                                            didFinishSelector:@selector(tokenAccessTicket:didFinishWithData:)
                                                                                                              didFailSelector:@selector(tokenAccessTicket:didFailWithError:)];
    
    [fetcher startByUrl:[accessURL absoluteString]];
    
	[oRequest release];
}

- (void)tokenAccessTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	/*if (xAuth) 
	 {
	 if (ticket.didSucceed)
	 {
	 [item setCustomValue:[[pendingForm formValues] objectForKey:@"followMe"] forKey:@"followMe"];
	 [pendingForm close];
	 }
	 
	 else
	 {
	 [self tokenAccessTicket:ticket didFailWithError:[SHK error:[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]]];
	 return;
	 }
	 }
	 else
	 {
	 if (ticket.didSucceed)
	 {
	 if (delegate){
	 [delegate recievedDidSucceed];
	 }
	 }
	 }*/
	[super tokenAccessTicket:ticket didFinishWithData:data];		
}


#pragma mark -
#pragma mark UI Implementation

- (void)show{
    [item setCustomValue:item.text forKey:@"status"];
    [self showTencentForm];
}

- (void)showTencentForm{
	ITTShareFormViewController *rootView = [[ITTShareFormViewController alloc] initShareName:@"腾讯微博" text:[item customValueForKey:@"status"] image:item.image];	
	rootView.delegate = self;
	
	// force view to load so we can set textView text
	//[rootView view];
	
	[self pushViewController:rootView animated:NO];
	[rootView release];
    
	[[SHK currentHelper] showViewController:self];	
}


#pragma mark - Share API Methods

- (BOOL)validate{
	NSString *status = [item customValueForKey:@"status"];
	return status != nil && status.length <= 140;
}

- (BOOL)send{	
	if (![self validate]){
		[self show];
	}else{	
		if (item.image!=nil){
			[self sendImage];
        }else{
            [self sendStatus];        
        }
		
		// Notify delegate
		[self sendDidStart];	
		
		return YES;
	}
	
	return NO;
}

- (void)sendStatus{
	OAMutableURLRequestForTencent *oRequest = [[OAMutableURLRequestForTencent alloc] initWithURL:[NSURL URLWithString:@"http://open.t.qq.com/api/t/add"] 
                                                                                        consumer:consumer 
                                                                                           token:accessToken 
                                                                                           realm:nil 
                                                                               signatureProvider:nil 
                                                                                           nonce:[self generateNonce] 
                                                                                       timestamp:[NSString stringWithFormat:@"%ld", time(NULL)]];
	
	[oRequest setHTTPMethod:@"POST"];
	
    [oRequest setOAuthParameterName:@"content" withValue:[item customValueForKey:@"status"]];
    [oRequest setOAuthParameterName:@"clientip" withValue:@"127.0.0.1"];
    
	OAAsynchronousDataFetcherForTencent *fetcher = [OAAsynchronousDataFetcherForTencent asynchronousTencentFetcherWithRequest:oRequest
                                                                                                                     delegate:self
                                                                                                            didFinishSelector:@selector(sendStatusTicket:didFinishWithData:)
                                                                                                              didFailSelector:@selector(sendStatusTicket:didFailWithError:)];	
	
	[fetcher startByUrl:@"http://open.t.qq.com/api/t/add"];
	[oRequest release];
	
}

- (void)sendStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {	
	// TODO better error handling here
	
	if (ticket.didSucceed) {
		[self sendDidFinish];
	}else{
        NSHTTPURLResponse *response = ticket.response;
        if (response.statusCode == 400) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"不要太贪心哦，发一次就够啦！" 
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release]; 
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                            message:@"网络连接或服务器异常！" 
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release]; 
        }
        ITTDINFO(@"statusCode:%d", response.statusCode);
        
        [self sendDidFinish];
	}
}

- (void)sendStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                    message:@"网络连接或服务器异常！" 
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release]; 
    [self sendDidFinish];
}

- (void)sendImage{
	
	OAMutableURLRequestForTencent *oRequest = [[OAMutableURLRequestForTencent alloc] initWithURL:[NSURL URLWithString:@"http://open.t.qq.com/api/t/add_pic"]
                                                                                        consumer:consumer
                                                                                           token:accessToken
                                                                                           realm:nil 
                                                                               signatureProvider:nil 
                                                                                           nonce:[self generateNonce] 
                                                                                       timestamp:[NSString stringWithFormat:@"%ld", time(NULL)]];
	[oRequest setHTTPMethod:@"POST"];
	
    [oRequest setOAuthParameterName:@"content" withValue:[item customValueForKey:@"status"]];
    
    [oRequest prepareByUrl:@"http://open.t.qq.com/api/t/add_pic"];
	
	CGFloat compression = 0.9f;
	NSData *imageData = UIImageJPEGRepresentation([item image], compression);
	
	// TODO
	// Note from Nate to creator of sendImage method - This seems like it could be a source of sluggishness.
	// For example, if the image is large (say 3000px x 3000px for example), it would be better to resize the image
	// to an appropriate size (max of img.ly) and then start trying to compress.
	
	while ([imageData length] > 700000 && compression > 0.1) {
		// NSLog(@"Image size too big, compression more: current data size: %d bytes",[imageData length]);
		compression -= 0.1;
		imageData = UIImageJPEGRepresentation([item image], compression);
		
	}
	
    //generate boundary string
	CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
    
	NSData *boundaryBytes = [[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
	[oRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
	
    NSMutableData *bodyData = [NSMutableData data];
	NSString *formDataTemplate = @"\r\n--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@";
	
	NSDictionary *listParams = [NSURL parseURLQueryString:oRequest.queryString];
	for (NSString *key in listParams) {
		
		NSString *value = [listParams valueForKey:key];
		NSString *formItem = [NSString stringWithFormat:formDataTemplate, boundary, key, value];
		[bodyData appendData:[formItem dataUsingEncoding:NSUTF8StringEncoding]];
	}
	[bodyData appendData:boundaryBytes];
    
    [bodyData appendData:[@"Content-Disposition: form-data; name=\"pic\"; filename=\"upload.jpg\"\r\nContent-Type: \"application/octet-stream\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:imageData];
    [bodyData appendData:boundaryBytes];
    
    [oRequest setValue:[NSString stringWithFormat:@"%d", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
	[oRequest setHTTPBody:bodyData];
    
	// setting the body of the post to the reqeust
	
	// Notify delegate
	[self sendDidStart];
	
	// Start the request
	OAAsynchronousDataFetcherForTencent *fetcher = [OAAsynchronousDataFetcherForTencent asynchronousTencentFetcherWithRequest:oRequest
                                                                                                                     delegate:self
                                                                                                            didFinishSelector:@selector(sendImageTicket:didFinishWithData:)
                                                                                                              didFailSelector:@selector(sendImageTicket:didFailWithError:)];	
	
	[fetcher startByUrl:@"http://open.t.qq.com/api/t/add_pic"];
	
	
	[oRequest release];
    
    
}

- (void)sendImageTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	// TODO better error handling here
	// NSLog([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	
	if (ticket.didSucceed) {
		[self sendDidFinish];
		// Finished uploading Image, now need to posh the message and url in twitter
		NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"QQ return String: %@",dataString);
		NSRange startingRange = [dataString rangeOfString:@"<url>" options:NSCaseInsensitiveSearch];
		//NSLog(@"found start string at %d, len %d",startingRange.location,startingRange.length);
		NSRange endingRange = [dataString rangeOfString:@"</url>" options:NSCaseInsensitiveSearch];
		//NSLog(@"found end string at %d, len %d",endingRange.location,endingRange.length);
		
		if (startingRange.location != NSNotFound && endingRange.location != NSNotFound) {
			NSString *urlString = [dataString substringWithRange:NSMakeRange(startingRange.location + startingRange.length, endingRange.location - (startingRange.location + startingRange.length))];
			//NSLog(@"extracted string: %@",urlString);
			[item setCustomValue:[NSString stringWithFormat:@"%@ %@",[item customValueForKey:@"status"],urlString] forKey:@"status"];
			[self sendStatus];
		}
		
		
	} else {
        NSHTTPURLResponse *response = ticket.response;
        if (response.statusCode == 400) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"不要太贪心哦，发一次就够啦！" 
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release]; 
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                            message:@"网络连接或服务器异常！" 
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release]; 
        }
        ITTDINFO(@"statusCode:%d", response.statusCode);
        
        [self sendDidFinish];
        
	}
}

- (void)sendImageTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                    message:@"网络连接或服务器异常！" 
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release]; 
}

#pragma mark - ITTShareFormViewController Methods
- (void)onFormSendBtnClicked:(ITTShareFormViewController*)formVC{
    item.image = formVC.imageView.image;
    item.text = formVC.textView.text;
    [self send];
}
@end
