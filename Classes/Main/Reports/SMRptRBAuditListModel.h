//
//  SMRptRBAuditListModel.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-12.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SMRptRBAuditListModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *tommemo;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic, strong) NSString *submitdate;
@property (nonatomic, strong) NSString *summarize;
@property (nonatomic, strong) NSArray *listdaily;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *deptname;

@property (nonatomic, strong) NSMutableArray *listdailyObj;

-(NSMutableArray*) getListdaily;

@end
