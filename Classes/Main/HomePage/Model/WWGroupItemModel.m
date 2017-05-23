//
//  WWGroupItemModel.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-18.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWGroupItemModel.h"

@implementation WWGroupItemModel
- (NSDictionary*)attributeMapDictionary
{
    return @{@"orgCode"    : @"orgCode"
             ,@"orgName"    : @"orgName"
             ,@"groupType"   : @"groupType"
             ,@"depCode" : @"depCode"
             ,@"depName" : @"depName"
             ,@"contact" : @"contact"
             ,@"createdAt" : @"createdAt"
             ,@"mobile" : @"mobile"
             ,@"remark" : @"remark"
             ,@"id" : @"id"
            };
}
@end
