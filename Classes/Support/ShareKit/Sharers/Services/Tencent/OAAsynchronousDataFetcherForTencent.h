//
//  OAAsynchronousDataFetcherForTencent.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/17/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "OAAsynchronousDataFetcher.h"

@interface OAAsynchronousDataFetcherForTencent : OAAsynchronousDataFetcher

+ (id)asynchronousTencentFetcherWithRequest:(OAMutableURLRequest *)aRequest delegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector;
- (void)startByUrl:(NSString *)baseUrl;
@end
