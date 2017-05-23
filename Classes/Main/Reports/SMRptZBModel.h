//
//  SMRptZBModel.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "VersionCheckDataRequest.h"

@interface SMRptZBModel : ITTBaseModelObject
@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *ywc;
@property (nonatomic, strong) NSArray *nextWeeklys;
@property (nonatomic, strong) NSArray *weeklys;
@property (nonatomic, strong) NSString *submitstatus;
@property (nonatomic, strong) NSString *submitdate;
@property (nonatomic, strong) NSString *zt;
 
@property (nonatomic, strong) NSString *ldpf;
@property (nonatomic, strong) NSString *jxgj;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *wwc;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *week;
@end
