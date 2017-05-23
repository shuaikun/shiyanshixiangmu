//
//  SHKTencent.h
//  AsiaScene
//
//  Created by Rainbow on 5/4/11.
//  Copyright 2011 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHKOAuthSharer.h"
#import "ITTShareFormViewController.h"

@interface NSURL (QAdditions)
+ (NSDictionary *)parseURLQueryString:(NSString *)queryString;
@end

@interface SHKTencent : SHKOAuthSharer <ITTShareFormViewControllerDelegate> {
    
	BOOL xAuth;
	id delegate;
}

@property BOOL xAuth;
@property(nonatomic, assign) id delegate;

#pragma mark - UI Implementation

- (void)showTencentForm;

#pragma mark - Share API Methods
- (void)sendStatus;
- (void)sendStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)sendStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;

- (void)sendImage;

@end