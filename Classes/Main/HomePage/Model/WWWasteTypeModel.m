//
//  WWWasteTypeModel.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-07-25.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWWasteTypeModel.h"

@implementation WWWasteTypeModel
- (NSDictionary*)attributeMapDictionary
{
    return @{
             @"attribute"  :  @"attribute"
             ,@"containerType"  :  @"containerType"
             ,@"content"  :  @"content"
             ,@"descriptions"  :  @"description"
             ,@"ids"  :  @"id"
             ,@"state"    : @"state"
             ,@"wasteCode"   : @"wasteCode"
             ,@"wasteName"  : @"wasteName"
             ,@"wasteType"   : @"wasteType"
             };
}

@end
