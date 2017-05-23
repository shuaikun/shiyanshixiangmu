//
//  SHKTwitter.m
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



#import "SHKTwitter.h"

@implementation SHKTwitter

@synthesize xAuth;

- (id)init
{
	if (self = [super init])
	{	
		// OAUTH		
		self.consumerKey = SHKTwitterConsumerKey;		
		self.secretKey = SHKTwitterSecret;
 		self.authorizeCallbackURL = [NSURL URLWithString:SHKTwitterCallbackUrl];// HOW-TO: In your Twitter application settings, use the "Callback URL" field.  If you do not have this field in the settings, set your application type to 'Browser'.
		
		// XAUTH
		self.xAuth = SHKTwitterUseXAuth?YES:NO;
		
		
		// -- //
		
		
		// You do not need to edit these, they are the same for everyone
	    self.authorizeURL = [NSURL URLWithString:@"https://twitter.com/oauth/authorize"];
	    self.requestURL = [NSURL URLWithString:@"https://twitter.com/oauth/request_token"];
	    self.accessURL = [NSURL URLWithString:@"https://twitter.com/oauth/access_token"]; 
	}	
	return self;
}


#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return @"Twitter";
}

#pragma mark -
#pragma mark Configuration : Dynamic Enable

- (BOOL)shouldAutoShare
{
	return NO;
}


#pragma mark -
#pragma mark Authorization

- (BOOL)isAuthorized
{		
	return [self restoreAccessToken];
}

- (void)promptAuthorization
{		
	if (xAuth)
		[super authorizationFormShow]; // xAuth process
	
	else
		[super promptAuthorization]; // OAuth process		
}


#pragma mark xAuth

+ (NSString *)authorizationFormCaption
{
	return SHKLocalizedString(@"Create a free account at %@", @"Twitter.com");
}

+ (NSArray *)authorizationFormFields
{
	if ([SHKTwitterUsername isEqualToString:@""])
		return [super authorizationFormFields];
	
	return @[[SHKFormFieldSettings label:SHKLocalizedString(@"Username") key:@"username" type:SHKFormFieldTypeText start:nil],
			[SHKFormFieldSettings label:SHKLocalizedString(@"Password") key:@"password" type:SHKFormFieldTypePassword start:nil],
			[SHKFormFieldSettings label:SHKLocalizedString(@"Follow %@", SHKTwitterUsername) key:@"followMe" type:SHKFormFieldTypeSwitch start:SHKFormFieldSwitchOn]];
}

- (void)authorizationFormValidate:(SHKFormController *)form
{
	self.pendingForm = form;
	[self tokenAccess];
}

- (void)tokenAccessModifyRequest:(OAMutableURLRequest *)oRequest
{	
	if (xAuth)
	{
		NSDictionary *formValues = [pendingForm formValues];
		
		OARequestParameter *username = [[[OARequestParameter alloc] initWithName:@"x_auth_username"
																			 value:SHKEncode(formValues[@"username"])] autorelease];
		
		OARequestParameter *password = [[[OARequestParameter alloc] initWithName:@"x_auth_password"
																			 value:SHKEncode(formValues[@"password"])] autorelease];
		
		OARequestParameter *mode = [[[OARequestParameter alloc] initWithName:@"x_auth_mode"
																			 value:@"client_auth"] autorelease];
		
		[oRequest setParameters:@[username, password, mode]];
	}
}

- (void)tokenAccessTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
	if (xAuth) 
	{
		if (ticket.didSucceed)
		{
			[item setCustomValue:[pendingForm formValues][@"followMe"] forKey:@"followMe"];
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
		if (ticket.didSucceed){
            //do something if needed
		}
	}
	
	[super tokenAccessTicket:ticket didFinishWithData:data];		
}


#pragma mark -
#pragma mark UI Implementation

- (void)show{
	if (item.image){
		[item setCustomValue:item.title forKey:@"status"];
		[self showTwitterForm];
	}else{
		[item setCustomValue:item.text forKey:@"status"];
		[self showTwitterForm];
	}
}

- (void)showTwitterForm
{
	SHKTwitterForm *rootView = [[SHKTwitterForm alloc] initWithNibName:nil bundle:nil];	
	rootView.delegate = self;
	
	// force view to load so we can set textView text
	[rootView view];
	
	rootView.textView.text = [item customValueForKey:@"status"];
	rootView.hasAttachment = item.image != nil;
	
	[self pushViewController:rootView animated:NO];
	
	[[SHK currentHelper] showViewController:self];	
}

- (void)sendForm:(SHKTwitterForm *)form
{	
	[item setCustomValue:form.textView.text forKey:@"status"];
	[self tryToSend];
}

#pragma mark － Share API Methods

- (BOOL)validate
{
	NSString *status = [item customValueForKey:@"status"];
	return status != nil && status.length <= 140;
}

- (BOOL)send
{	
	// Check if we should send follow request too
	if (xAuth && [item customBoolForSwitchKey:@"followMe"])
		[self followMe];	
	
	if (![self validate])
		[self show];
	
	else
	{	
		[self sendStatus];
		
		
		// Notify delegate
		[self sendDidStart];	
		
		return YES;
	}
	
	return NO;
}

- (void)sendStatus
{
	OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"]
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

- (void)sendStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{	
	// TODO better error handling here
	
	
	if (ticket.didSucceed) 
		[self sendDidFinish];
	
	else
		[self sendDidFailWithError:nil];
}

- (void)sendStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
	[self sendDidFailWithError:error];
}


- (void)followMe
{
	// remove it so in case of other failures this doesn't get hit again
	[item setCustomValue:nil forKey:@"followMe"];
	
	OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/friendships/create/%@.json", SHKTwitterUsername]]
																	consumer:consumer
																	   token:accessToken
																	   realm:nil
														   signatureProvider:nil];
	
	[oRequest setHTTPMethod:@"POST"];
	
	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
						 delegate:nil // Currently not doing any error handling here.  If it fails, it's probably best not to bug the user to follow you again.
				didFinishSelector:nil
				  didFailSelector:nil];	
	
	[fetcher start];
	[oRequest release];
}

@end
