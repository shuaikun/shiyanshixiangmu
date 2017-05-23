//
//  SHKSina.h
//
//  Created by lian jie on 1/18/11.
//  Copyright 2011 2009-2010 Dow Jones & Company, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SHKOAuthSharer.h"
#import "ITTShareFormViewController.h"

@interface SHKSina : SHKOAuthSharer <ITTShareFormViewControllerDelegate>{	
	BOOL xAuth;
}

@property BOOL xAuth;

#pragma mark -
#pragma mark UI Implementation

- (void)showSinaForm;

#pragma mark -
#pragma mark Share API Methods

- (void)sendForm:(ITTShareFormViewController *)form;
- (void)sendImage;
- (void)sendStatus;
- (void)sendStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)sendStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;
@end