//
//  SMAttendTxModel.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-22.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SMAttendTxModel : ITTBaseModelObject
@property (nonatomic, strong) NSString *restDate;
@property (nonatomic, strong) NSString *applydate;
@property (nonatomic, strong) NSString *extraworkDate;
@property (nonatomic, strong) NSString *extraworkTime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *peroson;
@property (nonatomic, strong) NSString *auditingdate;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *extrawork;
@property (nonatomic, strong) NSString *staffName;
@property (nonatomic, strong) NSString *opinion;
@property (nonatomic, strong) NSString *restTime;
@property (nonatomic, strong) NSString *rest;
@property (nonatomic, strong) NSString *updatetime;

-(BOOL)canEdit;
@property (nonatomic, assign) BOOL isSelected;

@end
