//
//  SHKSina.m
//
//  Created by lian jie on 1/18/11.
//  Copyright 2011 2009-2010 Dow Jones & Company, Inc. All rights reserved.
//

#import "SHKSina.h"
#import "SHKSinaOAuthView.h"
#import "ITTShareFormViewController.h"

@implementation SHKSina

@synthesize xAuth;

- (id)init{
	if (self = [super init]){	
		// OAUTH		
		self.consumerKey = SHKSinaKey;		
		self.secretKey = SHKSinaSecret;
 		self.authorizeCallbackURL = [NSURL URLWithString:SHKSinaCallbackUrl];// HOW-TO: In your Twitter application settings, use the "Callback URL" field.  If you do not have this field in the settings, set your application type to 'Browser'.
		
		// XAUTH
		self.xAuth = NO;
		
		// You do not need to edit these, they are the same for everyone
	    self.authorizeURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/oauth/authorize"];
	    self.requestURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/oauth/request_token"];
	    self.accessURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/oauth/access_token"]; 
	}	
	return self;
}


#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle{
	return @"新浪微博";
}


#pragma mark -
#pragma mark Configuration : Dynamic Enable

- (BOOL)shouldAutoShare{
	return NO;
}


#pragma mark -
#pragma mark Authorization
- (Class)getOAuthViewClass{
    return [SHKSinaOAuthView class];
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
	return @"创建一个新浪微博帐号";
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

- (void)tokenAccessTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	if (ticket.didSucceed){
        //do something if needed
	}
	[super tokenAccessTicket:ticket didFinishWithData:data];		
}


#pragma mark -
#pragma mark UI Implementation

- (void)show{
    [item setCustomValue:item.text forKey:@"status"];
    [self showSinaForm];
}

- (void)showSinaForm{
	ITTShareFormViewController *rootView = [[ITTShareFormViewController alloc] initShareName:@"新浪微博" text:[item customValueForKey:@"status"] image:item.image];	
	rootView.delegate = self;
	
	// force view to load so we can set textView text
	//[rootView view];
	
	[self pushViewController:rootView animated:NO];
	[rootView release];
    
	[[SHK currentHelper] showViewController:self];	
}

- (void)sendForm:(ITTShareFormViewController *)form{	
	[item setCustomValue:form.textView.text forKey:@"status"];
	[self tryToSend];
}


#pragma mark -


#pragma mark -
#pragma mark Share API Methods

- (BOOL)validate{
	NSString *status = [item customValueForKey:@"status"];
	return status != nil && status.length <= 140;
}

- (BOOL)send{	
	if (![self validate]){
		[self show];
	}else{	
		if (item.image != nil){
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

- (void)sendImage{
	
	OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.t.sina.com.cn/statuses/upload.json"]
																	consumer:consumer
																	   token:accessToken
																	   realm:nil
														   signatureProvider:signatureProvider];
	[oRequest setHTTPMethod:@"POST"];
	
	OARequestParameter *statusParam = [[OARequestParameter alloc] initWithName:@"status"
																		 value:[item customValueForKey:@"status"]];
	NSArray *params = @[statusParam];
	[oRequest setParameters:params];
	[statusParam release];
    
    [oRequest prepare];
	
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
	
	NSString *boundary = @"0xKhTmLbOuNdArY";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[oRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
	NSString *dispKey = @"Content-Disposition: form-data; name=\"pic\"; filename=\"upload.jpg\"\r\n";
    
	
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[dispKey dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:imageData];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"status\"\r\n\r\n"dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[item customValueForKey:@"status"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];	
	
	[body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// setting the body of the post to the reqeust
	[oRequest setHTTPBody:body];
	
	// Notify delegate
	[self sendDidStart];
	
	// Start the request
	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
																						  delegate:self
																				 didFinishSelector:@selector(sendImageTicket:didFinishWithData:)
																				   didFailSelector:@selector(sendImageTicket:didFailWithError:)];	
	
	[fetcher start];
	
	
	[oRequest release];    
}


- (void)sendImageTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	// TODO better error handling here
	// NSLog([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	
	if (ticket.didSucceed) {
		[self sendDidFinish];
		// Finished uploading Image, now need to posh the message and url in twitter
		NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
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
    [self sendDidFinish];
}


- (void)sendStatus{
	
	OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.t.sina.com.cn/statuses/update.json"]
																	consumer:consumer
																	   token:accessToken
																	   realm:nil
														   signatureProvider:nil];
	
	[oRequest setHTTPMethod:@"POST"];
	
	OARequestParameter *statusParam = [[OARequestParameter alloc] initWithName:@"status"
																		 value:[item customValueForKey:@"status"]];
	NSArray *params = @[statusParam];
	[oRequest setParameters:params];
	[statusParam release];
	
	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
																						  delegate:self
																				 didFinishSelector:@selector(sendStatusTicket:didFinishWithData:)
																				   didFailSelector:@selector(sendStatusTicket:didFailWithError:)];	
	
	[fetcher start];
	[oRequest release];
    
}

- (void)sendStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {	
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
		//[self sendDidFailWithError:nil];
    }
}

- (void)sendStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error{
    ITTDINFO(@"error when share to sina:%@", error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                    message:@"网络连接或服务器异常！" 
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release]; 
    [self sendDidFinish];
	//[self sendDidFailWithError:error];
}

#pragma mark - ITTShareFormViewController Methods
- (void)onFormSendBtnClicked:(ITTShareFormViewController*)formVC{
    [self send];
}
@end