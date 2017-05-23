//
//  ASIBaseDataRequest.m
//  hupan
//
//  Created by lian jie on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ITTASIBaseDataRequest.h"
#import "ASIFormDataRequest.h"
#import "CommonUtils.h"
#import "ITTNetworkTrafficManager.h"
#import "ITTFileModel.h"

@class AllBrandDataRequest;

@interface ITTASIBaseDataRequest()
{
    ASIFormDataRequest* _request;    
}
@end

@implementation ITTASIBaseDataRequest

#pragma mark - private method
- (NSString*)getRequestUrl
{
    return SMHOST_URL; //SZHOST_URL;
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

- (NSDictionary*)getStaticParams
{
	return @{@"site": [[UserManager sharedUserManager] cityCode]};
}

- (void)cancelRequest
{
    _request.delegate = nil;
    [_request cancel];
    if (_onRequestCanceled) {
        _onRequestCanceled(self);
    }
    ITTDINFO(@"%@ request is cancled!", [self class]);
    [self showIndicator:FALSE];
}

- (NSString *)generateURLWithParameters:(NSMutableDictionary *)allParams url:(NSString *)url
{
    NSString *paramString = @"";
    if (allParams) {
        NSArray *allKeys = [allParams allKeys];
        NSInteger count = [allKeys count];
        NSString *value = nil;
        for (NSUInteger i=0; i<count; i++) {
            id key = allKeys[i];
            value = (NSString *)allParams[key];
            value = [self encodeURL:value];
            paramString = [paramString stringByAppendingString:(i == 0)?@"":@"&"];
            paramString = [paramString stringByAppendingFormat:@"%@=%@",key,value];
        }
    }
    NSString *urlString = nil;
    //check ? character
    NSUInteger found = [url rangeOfString:@"?"].location;
    if (NSNotFound == found) {
        urlString = [NSString stringWithFormat:@"%@?%@", url, paramString];
    }
    else {
        urlString = [NSString stringWithFormat:@"%@%@", url, paramString];
    }
    return urlString;
}

- (void)generateRequestWithUrl:(NSString*)url
                withParameters:(NSDictionary*)params{
    
	NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithCapacity:10];
    NSDictionary *staticParameters = [self getStaticParams];
	if (staticParameters != nil) {
		[allParams addEntriesFromDictionary:staticParameters];
	}
    if (params) {
        [allParams addEntriesFromDictionary:params];
    }
    NSArray *allKeys;
    NSInteger count = 0;
    if (allParams && [allParams count])
    {
        allKeys = [allParams allKeys];
        count = [allKeys count];
        allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            return [obj1 compare:obj2];
        }];
    }
    NSMutableString *unsignedValue = [[NSMutableString alloc] init];
    // used to monitor network traffic , this is not accurate number.
    long long postBodySize = 0;
	if ([self getRequestMethod] == ITTRequestMethodGet){
        NSString *paramString = @"";
		if (allParams) {
			NSString *value = nil;
			for (NSUInteger i=0; i<count; i++) {
				id key = [allKeys objectAtIndex:i];
				NSString *unEncodeValue = (NSString *)[allParams objectForKey:key];
				value = [self encodeURL:unEncodeValue];
				paramString = [paramString stringByAppendingString:(i == 0)?@"":@"&"];
				paramString = [paramString stringByAppendingFormat:@"%@=%@",key,value];
                if (![key isEqualToString:@"keyid"] && ![key isEqualToString:@"is_print"]&& ![key isEqualToString:@"app_ver"]&& ![key isEqualToString:@"device"]) {
                    [unsignedValue appendString:key];
                    [unsignedValue appendString:unEncodeValue];
                }
                
			}
		}
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@?%@",url,paramString];
        if ([unsignedValue length]) {
            NSString *token = [[NSString alloc] initWithFormat:@"%@%@%@",APP_SECRET,unsignedValue,APP_SECRET];
            token = [[token md5] uppercaseString];
            [urlStr appendFormat:@"&%@=%@", TOKEN_KEY, token];
            [urlStr appendFormat:@"&%@=%@", APP_SECRET_KEY, APP_KEY];
            ITTDINFO(@"%@", token);
        }
        ITTDINFO(@"className : %@ Request URL is :%@",NSStringFromClass([self class]),urlStr);
        NSURL *nsUrl = [[NSURL alloc] initWithString:urlStr];
        _request = [[ASIFormDataRequest alloc] initWithURL:nsUrl];
        
        postBodySize += [urlStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        [_request setRequestMethod:@"GET"];
    }
    else {
        postBodySize += [url lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *nsUrl = [[NSURL alloc] initWithString:url];
        _request = [[ASIFormDataRequest alloc] initWithURL:nsUrl];
        [_request setRequestMethod:@"POST"];
        ASIPostFormat postFormat = ASIURLEncodedPostFormat;
        for (NSUInteger i = 0; i < count; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            
            if ([[allParams objectForKey:key] isKindOfClass:[NSData class]]) {
                postFormat = ASIMultipartFormDataPostFormat;
                NSData* data = (NSData*)[allParams objectForKey:key];
                [_request addData:data withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:key];
                postBodySize += [data length];
            }else if ([[allParams objectForKey:key] isKindOfClass:[UIImage class]]) {
                postFormat = ASIMultipartFormDataPostFormat;
                UIImage* image = [allParams objectForKey:key];
                NSData* data = UIImageJPEGRepresentation(image, 0.8);
                [_request addData:data withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:key];
                postBodySize += [data length];
            }
            else{
                [_request addPostValue:[allParams objectForKey:key] forKey:key];
                postBodySize += [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
                postBodySize += [[allParams objectForKey:key] lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
                [unsignedValue appendString:key];
                [unsignedValue appendString:[allParams objectForKey:key]];
            }
        }
        if ([unsignedValue length]) {
            NSString *token = [[NSString alloc] initWithFormat:@"%@%@%@",APP_SECRET,unsignedValue,APP_SECRET];
            token = [[token md5] uppercaseString];
            [_request addPostValue:token forKey:TOKEN_KEY];
            [_request addPostValue:APP_KEY forKey:APP_SECRET_KEY];
        }
        _request.postFormat = postFormat;
    }
    
    _request.delegate = self;
    _request.defaultResponseEncoding = [self getResponseEncoding];
    _request.timeOutSeconds = REQUEST_TIMEOUT_SECONDS;
    _request.allowCompressedResponse = YES;
    _request.shouldCompressRequestBody = NO;
    
    if (_filePath && [_filePath length] > 0) {
        //create folder
        int pathLength = [_filePath length];
        int fileLength = [[_filePath lastPathComponent] length];
        NSString *directoryPath = [_filePath substringToIndex:(pathLength - fileLength - 1)];
        [CommonUtils createDirectorysAtPath:directoryPath];
        
        _request.downloadProgressDelegate = self;
        _request.downloadDestinationPath = _filePath;
        _request.didReceiveResponseHeadersSelector = @selector(requestDidReceiveReponseHeaders:);
        _request.showAccurateProgress = YES;
    }
    
    [[ITTNetworkTrafficManager sharedManager] logTrafficOut:postBodySize];
}


- (void)doRequestWithParams:(NSDictionary*)params
{
    [self generateRequestWithUrl:self.requestUrl withParameters:params];
    
    [_request startAsynchronous];
    ITTDINFO(@"request %@ is created, URL is: %@", [self class], [_request url]);
}


- (BOOL)onReceivedCacheData:(NSObject*)cacheData
{
    // return yes to finish this request, return no to continue request from server
    ITTDINFO(@"using cache data for request:%@", [self class]);
    if (!cacheData) {
        return NO;
    }
    if ([cacheData isKindOfClass:[NSDictionary class]]) {
        self.handleredResult = (NSMutableDictionary *)cacheData;
        self.result = [[ITTRequestResult alloc] initWithCode:(self.handleredResult)[@"result"] withMessage:@""];
        if (_onRequestFinishBlock) {
            _onRequestFinishBlock(self);
        }
        return YES;
    }else{
        ITTDINFO(@"request:[%@],cache data should be handled by subclass", [self class]);
        return NO;
    }
}

#pragma mark - request delegate methods

- (void)requestDidReceiveReponseHeaders:(ASIFormDataRequest*)request
{
    //do something
    if ([request responseHeaders][@"Content-Length"]) {
        _totalData = [(NSString*)[request responseHeaders][@"Content-Length"] longLongValue];
        ITTDINFO(@"total size of zip file:%lld", _totalData);
    }
    
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)newLength
{
    if (newLength < 0) {
        newLength = 0;
    }
    _downloadedData += newLength;
    float newProgress = 1.0*_downloadedData/_totalData;
    if (_currentProgress < newProgress) {
        _currentProgress = newProgress;
        //using block
        if (_onRequestProgressChangedBlock) {
            _onRequestProgressChangedBlock(self, _currentProgress);
        }
    }
}

- (void)requestStarted:(ASIFormDataRequest*)request
{
	[self showIndicator:YES];
    if (_onRequestStartBlock) {
        _onRequestStartBlock(self);
    }
}

- (void)requestFinished:(ASIFormDataRequest*)request
{
    [[ITTNetworkTrafficManager sharedManager] logTrafficIn:request.totalBytesRead];
    [self showIndicator:NO];
	NSString *responseString;
    if (request.allowCompressedResponse) {
        responseString = [[NSString alloc] initWithData:[request responseData] encoding:[self getResponseEncoding]];
    }else{
        responseString = [[NSString alloc] initWithData:[request rawResponseData] encoding:[self getResponseEncoding]];
    }
    
	[self handleResultString:responseString];
    [self doRelease];
}

- (void)requestFailed:(ASIFormDataRequest*)request
{
	[self showIndicator:NO];
	ITTDERROR(@"http request error:\n request:%@\n error:%@",[request.url absoluteString],request.error);
    [self notifyDelegateRequestDidErrorWithError:request.error];
    
	if (request.error.domain == NetworkRequestErrorDomain) {
		NSString *errorMsg = nil;
		switch ([request.error code]) {
			case ASIConnectionFailureErrorType:
				errorMsg = @"无法连接到网络";
                [[UserManager sharedUserManager] showWifiAlert];
                return;
				break;
			case ASIRequestTimedOutErrorType:
				errorMsg = @"访问超时";
				break;
			case ASIAuthenticationErrorType:
				errorMsg = @"服务器身份验证失败";
				break;
			case ASIRequestCancelledErrorType:
				//errorMsg = @"request is cancelled";
				errorMsg = @"服务器请求已取消";
				break;
			case ASIUnableToCreateRequestErrorType:
				//errorMsg = @"ASIUnableToCreateRequestErrorType";
				errorMsg = @"无法创建服务器请求";
				break;
			case ASIInternalErrorWhileBuildingRequestType:
				//errorMsg = @"ASIInternalErrorWhileBuildingRequestType";
				errorMsg = @"服务器请求创建异常";
				break;
			case ASIInternalErrorWhileApplyingCredentialsType:
				//errorMsg = @"ASIInternalErrorWhileApplyingCredentialsType";
				errorMsg = @"服务器请求异常";
				break;
			case ASIFileManagementError:
				//errorMsg = @"ASIFileManagementError";
				errorMsg = @"服务器请求异常";
				break;
			case ASIUnhandledExceptionError:
				//errorMsg = @"ASIUnhandledExceptionError";
				errorMsg = @"未知请求异常异常";
				break;
			default:
				errorMsg = @"服务器故障或网络链接失败！";
				break;
		}
        if ([request.error code] != ASIRequestCancelledErrorType) {
            ITTDERROR(@"error detail:%@\n",request.error.userInfo);
            ITTDERROR(@"error code:%d",[request.error code]);
//            if (!_useSilentAlert) {
//                [self showNetowrkUnavailableAlertView:errorMsg];
            [PROMPT_VIEW showMessage:errorMsg];
//            }
        }
	}
    [self doRelease];
}

@end
