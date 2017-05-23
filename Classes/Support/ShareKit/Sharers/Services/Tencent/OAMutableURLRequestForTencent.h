//
//  OAMutableURLRequestForTencent.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/17/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "OAMutableURLRequest.h"

@interface OAMutableURLRequestForTencent : OAMutableURLRequest{
    //Add by Rainbow
    NSString *queryString;
}
@property(readonly) NSString *queryString;

- (void)prepareByUrl:(NSString*)baseUrl;
@end
