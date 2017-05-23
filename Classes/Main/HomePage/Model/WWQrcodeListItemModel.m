//
//  WWQrcodeListItemRequest.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-17.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWQrcodeListItemModel.h"

@implementation WWQrcodeListItemModel
- (NSDictionary*)attributeMapDictionary
{
    return @{
             @"dangesFeatures" : @""
             ,@"Id" : @"Id"
             ,@"packId" : @"packId"
             ,@"ph" : @"ph"
             ,@"productionDate" : @"productionDate"
             ,@"qrCode" : @"qrCode"
             ,@"remark" : @"remark"
             ,@"wasteForm" : @"wasteForm"
             ,@"wasteName" : @"wasteName"
             ,@"wastePatchId" : @"wastePatchId"
             ,@"wasteType" : @"wasteType"
             ,@"wasteWeight" : @"wasteWeight"
             ,@"wasteImage" : @"wasteImage"
             
             ,@"contact" : @"contact"
             ,@"mobile" : @"mobile"
             };
}
@end
