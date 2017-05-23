//
//  SKUplodaQDCodeRequest.m
//  com.knowesoft.weifei
//
//  Created by caoshuaikun on 2017/5/1.
//  Copyright © 2017年 Knowesoft. All rights reserved.
//

#import "SKUplodaQDCodeRequest.h"

@implementation SKUplodaQDCodeRequest

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@%@",SMHOST_URL,@"qrcode/callback.action"];
}
    
@end
