//
//  SHKFacebook.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/18/10.

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

#import "SHKFacebook.h"
#import "SHKFBStreamDialog.h"


static FBSession *session;

@implementation SHKFacebook

@synthesize session;
@synthesize pendingFacebookAction;
@synthesize login;

- (void)dealloc
{
	[session.delegates removeObject:self];
	[session release];
	[login release];
	[super dealloc];
}


#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return @"Facebook";
}


#pragma mark -
#pragma mark Configuration : Dynamic Enable

- (BOOL)shouldAutoShare
{
	return YES; // FBConnect presents its own dialog
}



#pragma mark -
#pragma mark Authentication

- (BOOL)isAuthorized
{	
	if (session == nil)
	{
		self.session = [FBSession sessionForApplication:SHKFacebookKey
											 secret:SHKFacebookSecret
										   delegate:self];
		return [session resume];
	}
	
	return [session isConnected];
}

- (void)promptAuthorization
{
	self.pendingFacebookAction = SHKFacebookPendingLogin;
	self.login = [[[FBLoginDialog alloc] init] autorelease];
	[login show];
	login.delegate = self;
}

- (void)authFinished:(SHKRequest *)request
{
    //do something if needed
}

+ (void)logout
{
	FBSession *fbSession = [FBSession sessionForApplication:SHKFacebookKey
													 secret:SHKFacebookSecret
												   delegate:[[[self alloc] init] autorelease]];
	[fbSession logout];
	RELEASE_SAFELY(session);
}

#pragma mark -
#pragma mark Share API Methods

- (BOOL)send
{			
    if (self.item.image) {
		self.pendingFacebookAction = SHKFacebookPendingImage;
		
		FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] init] autorelease];
		dialog.delegate = self;
		dialog.permission = @"photo_upload";
		[dialog show];	
    }else {
		self.pendingFacebookAction = SHKFacebookPendingStatus;
		
		SHKFBStreamDialog* dialog = [[[SHKFBStreamDialog alloc] init] autorelease];
		dialog.delegate = self;
		dialog.userMessagePrompt = @"Enter your message:";
		dialog.defaultStatus = self.item.text;
		dialog.actionLinks = [NSString stringWithFormat:@"[{\"text\":\"Get %@\",\"href\":\"%@\"}]",
							  SHKEncode(SHKMyAppName),
							  SHKEncode(SHKMyAppURL)];
		[dialog show];
    }
	
	return YES;
}

- (void)sendImage
{
	[self sendDidStart];

	[[FBRequest requestWithDelegate:self] call:@"facebook.photos.upload"
	params:@{@"caption": self.item.title}
	dataParam:UIImageJPEGRepresentation(self.item.image,100)];
}

- (void)dialogDidSucceed:(FBDialog*)dialog
{
	if (pendingFacebookAction == SHKFacebookPendingLogin)
	{
		[self send];
	}
	else if (pendingFacebookAction == SHKFacebookPendingImage)
		[self sendImage];
	
	// TODO - the dialog has a SKIP button.  Skipping still calls this even though it doesn't appear to post.
	//		- need to intercept the skip and handle it as a cancel?
	else if (pendingFacebookAction == SHKFacebookPendingStatus)
		[self sendDidFinish];
}

- (void)dialogDidCancel:(FBDialog*)dialog
{
	if (pendingFacebookAction == SHKFacebookPendingStatus)
		[self sendDidCancel];
}

- (BOOL)dialog:(FBDialog*)dialog shouldOpenURLInExternalBrowser:(NSURL*)url
{
	return YES;
}


#pragma mark FBSessionDelegate methods

- (void)session:(FBSession*)session didLogin:(FBUID)uid 
{
	// Try to share again
	if (pendingFacebookAction == SHKFacebookPendingLogin)
	{
		self.pendingFacebookAction = SHKFacebookPendingNone;
		[self share];
	}
}

- (void)session:(FBSession*)session willLogout:(FBUID)uid 
{
	// Not handling this
}


#pragma mark FBRequestDelegate methods

- (void)request:(FBRequest*)aRequest didLoad:(id)result 
{
	if ([aRequest.method isEqualToString:@"facebook.photos.upload"]) 
	{
		// PID is in [result objectForKey:@"pid"];
		[self sendDidFinish];
	}
}

- (void)request:(FBRequest*)aRequest didFailWithError:(NSError*)error 
{
	[self sendDidFailWithError:error];
}



@end
