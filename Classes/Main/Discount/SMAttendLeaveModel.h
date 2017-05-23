//
//  SMAttendLeaveModel.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SMAttendLeaveModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *oneperson;
@property (nonatomic, strong) NSString *shenheTime;
@property (nonatomic, strong) NSString *oneopinion;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *endtime;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *starttime;
@property (nonatomic, strong) NSString *sumTime;
@property (nonatomic, strong) NSString *sumtime;
@property (nonatomic, strong) NSString *submittime;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *staffid;
@property (nonatomic, strong) NSString *onetime;
@property (nonatomic, strong) NSString *deptname;
@property (nonatomic, strong) NSString *staffname;
@property (nonatomic, strong) NSString *updatetime;
@property (nonatomic, strong) NSString *twoperson;
@property (nonatomic, strong) NSString *twoopinion;
@property (nonatomic, strong) NSString *twotime;


-(BOOL)canEdit;
@property (nonatomic, assign) BOOL isSelected;


@end
