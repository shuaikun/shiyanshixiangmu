//
//  SMValueTextModel.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-5.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMValueTextModel.h"

@implementation SMValueTextModel
- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"value",      @"value",
            @"text",      @"text",
            nil];
}
@end
