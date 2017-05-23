//
//  OAMutableURLRequestForTencent.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/17/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "OAMutableURLRequestForTencent.h"
#import "SHKConfig.h"

@implementation OAMutableURLRequestForTencent
@synthesize queryString;
- (void)dealloc
{
    [queryString release];
	[super dealloc];
}

//Add by Rainbow, special for Tencent Weibo
- (void)prepareByUrl:(NSString*)baseUrl{
    if (didPrepare) {
		return;
	}
	didPrepare = YES;
    // sign
	// Secrets must be urlencoded before concatenated with '&'
	// TODO: if later RSA-SHA1 support is added then a little code redesign is needed
    
    signature = [signatureProvider signClearText:[self signatureBaseString]
                                      withSecret:[NSString stringWithFormat:@"%@&%@",
												  [consumer.secret URLEncodedString],
                                                  [token.secret URLEncodedString]]];
    
    NSString *oauthBody = [NSString stringWithFormat:@"oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_version=1.0",
                           [consumer.key URLEncodedString],
                           nonce,
                           [signature URLEncodedString],
                           [[signatureProvider name] URLEncodedString],
                           timestamp];
    
	// Adding the optional parameters in sorted order isn't required by the OAuth spec, but it makes it possible to hard-code expected values in the unit tests.
	for(NSString *parameterName in [[extraOAuthParameters allKeys] sortedArrayUsingSelector:@selector(compare:)])
	{
        oauthBody = [oauthBody stringByAppendingFormat:@"&%@=%@",[parameterName URLEncodedString],
                     [extraOAuthParameters[parameterName] URLEncodedString]];
	}
    
    if (token.key != nil && ![token.key isEqualToString:@""])
    {
        oauthBody = [oauthBody stringByAppendingFormat:@"&oauth_token=%@", [token.key URLEncodedString]];
    }
    
    else
    {
        oauthBody = [oauthBody stringByAppendingFormat:@"&oauth_callback=%@", [SHKTencentCallbackUrl URLEncodedString]];
    }
    
    queryString = [oauthBody retain];
    NSString *url = [NSString stringWithFormat:@"%@?%@", baseUrl, oauthBody];
    NSLog(@"requestUrl: %@", url);
    
    [self setURL:[NSURL URLWithString:baseUrl]];
	[self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[self setHTTPBody:[oauthBody dataUsingEncoding:NSUTF8StringEncoding]];
}
@end
