//
//  WWQrcodeModel.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-16.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWQrcodeModel.h"

@implementation WWQrcodeModel
- (NSDictionary*)attributeMapDictionary
{
    return @{@"containerType"    : @"containerType"
             ,@"containerSize"    : @"containerSize"
             ,@"containerName"    : @"containerName"
             ,@"containerIdentifier"   : @"containerIdentifier"
             ,@"createdAt"  : @"createdAt"
             ,@"status"   : @"status"
             ,@"contact"  : @"contact"

             ,@"qrCode"  : @"qrCode"
             
             ,@"orgCode"  : @"orgCode"
             ,@"orgName"  : @"orgName"
             ,@"depCode"  : @"depCode"
             ,@"depName"  : @"depName"
             ,@"groupType"  : @"groupType"
             
             ,@"gw"  : @"gw"
             ,@"selfWeight"  : @"selfWeight"
             ,@"shiyongdanwei"  : @"shiyongdanwei"
             ,@"suoshudanwei"  : @"suoshudanwei"
             
             ,@"useCount"  : @"useCount"
             ,@"startTime"  : @"startTime"
             ,@"remark"  : @"remark"
             
             ,@"waste_data" : @"waste_data"
             };
}

-(WWPackageBoxStatus) packageBoxStatus
{
    if ([[self status] isEqualToString:@"-1"]){
        return kPackageBoxNone;
    }
    else if ([[self status] isEqualToString:@"0"]){
        return kPackageBoxActive;
    }
    else if ([[self status] isEqualToString:@"2"]){
        return kPackageBoxBinded;
    }
    else if ([[self status] isEqualToString:@"3"]){
        return kPackageBoxFreeze;
    }
    else if ([[self status] isEqualToString:@"99"]){
        return kPackageBoxDestory;
    }
    else{
        return kPackageBoxNone;
    }
}
@end
