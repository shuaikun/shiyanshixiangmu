//
//  SMRptProjectModel.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-4.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SMRptProjectModel : ITTBaseModelObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *principal;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *budgetsum;
@property (nonatomic, strong) NSString *isnocontract;
@property (nonatomic, strong) NSString *jcompanyname;
@property (nonatomic, strong) NSString *jcontacts;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *predictendtime;
@property (nonatomic, strong) NSString *predictstarttime;
@property (nonatomic, strong) NSString *projectcode;
@property (nonatomic, strong) NSString *projectname;
@property (nonatomic, strong) NSString *projecttype;
@property (nonatomic, strong) NSString *stylistname;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *updateName;
@end
