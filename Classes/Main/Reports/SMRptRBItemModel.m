//
//  SMRptRBItemModel.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-2.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptRBItemModel.h"
  
@implementation SMRptRBItemModel
- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"id",          @"id",
            @"workcontent", @"workcontent",
            @"issue",       @"issue",
            
            @"level",       @"level",
            @"status",      @"status",
            @"percentage",  @"percentage",
            @"workhour",    @"workhour",
            
            @"project",   @"project",
            @"SMRptProjectModel", @"projectObj",
            @"projectName", @"projectName",
            @"improveremark",   @"improveremark",
            @"improvestatus",   @"improvestatus",
            @"reason",   @"reason",
            @"remark",   @"remark",
            @"leadspeak",   @"leadspeak",
            @"improvenode",   @"improvenode",
            @"improvemeasures",   @"improvemeasures",
            @"promise",   @"promise",
            nil];
}

-(SMRptProjectModel*) getProjectObj
{
    if (self.project != nil){
        if (self.projectObj == nil){
            SMRptProjectModel *prjmodel = [[SMRptProjectModel alloc] initWithDataDic:self.project];
            self.projectObj = prjmodel;
        }
    }
    return self.projectObj;
}

@end
