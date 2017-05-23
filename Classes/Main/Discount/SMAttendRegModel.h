//
//  SMAttendRegModel.h
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-7.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SMAttendRegModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *oneperson;
@property (nonatomic, strong) NSString *shenheTime;
@property (nonatomic, strong) NSString *oneopinion;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *submittime;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *staffid;
@property (nonatomic, strong) NSString *deptname;
@property (nonatomic, strong) NSString *onetime;
@property (nonatomic, strong) NSString *staffname;
@property (nonatomic, strong) NSString *updatetime;

-(BOOL)canEdit;
@property (nonatomic, assign) BOOL isSelected;

@end
