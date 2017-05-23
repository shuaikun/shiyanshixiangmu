//
//  HHRequestResult
//
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ITTRequestResult.h"


@implementation ITTRequestResult
///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

-(id)initWithCode:(NSString*)code withMessage:(NSString*)message
{
    self = [super init];
    if (self) {
        code = [NSString stringWithFormat:@"%@",code];
            if ([code isEqualToString:@"0"]) {
                _code = @1;
            }else{
                _code = @0;
            }
        if ([message isKindOfClass:[NSString class]]) {
            _message = message;
        }else
        {
            _message = [NSString stringWithFormat:@"%@",message];
        }

    }
    return self;
}

-(BOOL)isSuccess
{
    return (_code && [_code intValue] == 1);
}

-(void)showErrorMessage
{
    if (_message && _message.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:_message
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

@end