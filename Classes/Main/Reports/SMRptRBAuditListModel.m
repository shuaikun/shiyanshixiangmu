//
//  SMRptRBAuditListModel.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-12.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptRBAuditListModel.h"
#import "SMRptRBItemModel.h"

@implementation SMRptRBAuditListModel
- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"id", @"id",
            @"tommemo", @"tommemo",
            @"username", @"username",
            @"condition", @"condition",
            @"submitdate", @"submitdate",
            @"summarize", @"summarize",
            @"listdaily", @"listdaily",
            @"date", @"date",
            @"deptname", @"deptname",
            nil];
    
}

-(NSMutableArray*) getListdaily
{
    if (self.listdailyObj == nil){
        self.listdailyObj = [[NSMutableArray alloc] init];
        NSArray *itemlist = self.listdaily;
        if(itemlist && [itemlist isKindOfClass:[NSArray class]])
        {
            for (int i=0; i<[itemlist count]; i++) {
                SMRptRBItemModel *item = [[SMRptRBItemModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
                [self.listdailyObj addObject:item];
            }
        }
    }
    
    return self.listdailyObj;
}
@end
