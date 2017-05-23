//
//  GetDemoImageDataRequest.m
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/20/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "GetDemoImageDataRequest.h"
#import "ITTImageInfo.h"

@implementation GetDemoImageDataRequest

- (NSString*)getRequestUrl
{
    return @"http://photo.auto.sina.com.cn/interface/general/get_photo_by_subid_type.php?subid=838&";
}

- (NSDictionary*)getStaticParams
{
	return @{@"encode": @"utf-8",@"limit": @"9999"};
}

- (NSString*)dumpyResponseString
{
	return [NSString stringWithFileInMainBundle:@"imagelist" ofType:@"txt"];
}

- (void)processResult
{    
    NSString *resultCode = (self.handleredResult)[@"result"];
    if ([resultCode isEqualToString:@"succ"]) {
        self.result = [[ITTRequestResult alloc] initWithCode:@"0"
                                                  withMessage:@""];
        NSArray *dataArray = (self.handleredResult)[@"data"];
        if (dataArray && [dataArray count] > 0) {
            NSMutableArray *imageList = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
                ITTImageInfo *image = [[ITTImageInfo alloc] initWithDataDic:dataDic];
                [imageList addObject:image];
            }
            (self.handleredResult)[@"imageList"] = imageList;
            [self.handleredResult removeObjectForKey:@"data"];
        }

    }    /*
    [super processResult];
    if ([self isSuccess]) {        
        NSArray *dataArray = [self.handleredResult objectForKey:@"data"];
        if (dataArray && [dataArray count] > 0) {
            NSMutableArray *imageList = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
                DemoImage *image = [[DemoImage alloc] initWithDataDic:dataDic];
                [imageList addObject:image];
                RELEASE_SAFELY(image);
            }
            [self.handleredResult setObject:imageList forKey:@"imageList"];
            [self.handleredResult removeObjectForKey:@"data"];
        }
        
    }*/
}
@end
