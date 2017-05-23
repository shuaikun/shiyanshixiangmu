//
//  OAAsynchronousDataFetcherForTencent.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/17/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "OAAsynchronousDataFetcherForTencent.h"
#import "OAServiceTicket.h"
#import "OAMutableURLRequestForTencent.h"

@implementation OAAsynchronousDataFetcherForTencent

+ (id)asynchronousTencentFetcherWithRequest:(OAMutableURLRequest *)aRequest delegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector{
	return [[[OAAsynchronousDataFetcherForTencent alloc] initWithRequest:aRequest delegate:aDelegate didFinishSelector:finishSelector didFailSelector:failSelector] autorelease];
}

- (void)startByUrl:(NSString *)baseUrl{
    if (![request isKindOfClass:[OAMutableURLRequestForTencent class]]) {
        ITTDERROR(@"something is wrong here");
    }
	[(OAMutableURLRequestForTencent*)request prepareByUrl:baseUrl];
    
	if (connection){
		[connection release];
    }
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
	if (connection){
		if (responseData){
			[responseData release];
        }
		responseData = [[NSMutableData data] retain];
	}else{
        OAServiceTicket *ticket= [[OAServiceTicket alloc] initWithRequest:request
                                                                 response:nil
                                                               didSucceed:NO];
        [delegate performSelector:didFailSelector
                       withObject:ticket
                       withObject:nil];
		[ticket release];
	}
}
@end
