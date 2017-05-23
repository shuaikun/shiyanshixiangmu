//
//  WWSearchPackageInfoModel.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-20.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWSearchPackageInfoModel.h"

@implementation WWSearchPackageInfoModel
- (NSDictionary*)attributeMapDictionary
{
    return @{@"date"    : @"date"
             ,@"mmv"    : @"mmv"
             ,@"group_code"   : @"group_code"
             ,@"group_name"  : @"group_name"
             ,@"package_box_code"   : @"package_box_code"
             };
}

@end
