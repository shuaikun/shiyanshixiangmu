//
//  SMRptRBItemModel.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-2.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "ITTBaseModelObject.h"
#import "SMRptProjectModel.h"

@interface SMRptRBItemModel : ITTBaseModelObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *workcontent;
@property (nonatomic, strong) NSString *issue;

@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *workhour;
@property (nonatomic, strong) NSString *percentage;
@property (nonatomic, strong) NSString *improveremark;
@property (nonatomic, strong) NSString *improvestatus;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *leadspeak;

@property (nonatomic, strong) NSString *improvenode;
@property (nonatomic, strong) NSString *improvemeasures;
@property (nonatomic, strong) NSString *promise;

@property (nonatomic, strong) NSString *projectName;

@property (nonatomic, strong) NSString *project;

@property SMRptProjectModel *projectObj;

-(SMRptProjectModel*) getProjectObj;

@property (nonatomic) bool isAudited;

@end
