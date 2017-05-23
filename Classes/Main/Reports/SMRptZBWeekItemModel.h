//
//  SMRptZBItemModel.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SMRptZBWeekItemModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *status;  //未完成
@property (nonatomic, strong) NSString *issue; //存在问题",
@property (nonatomic, strong) NSString *measures; //方法措施",
@property (nonatomic, strong) NSString *timenode;  //2014-09-11",
@property (nonatomic, strong) NSString *punishment; //本周惩罚",
@property (nonatomic, strong) NSString *improveremark; //null,
@property (nonatomic, strong) NSString *improvestatus; //null,
@property (nonatomic, strong) NSString *solvemeasure; //解决措施",
@property (nonatomic, strong) NSString *id; //f18a6fc84845b4b401485934a2370005",
@property (nonatomic, strong) NSString *level; // null,
@property (nonatomic, strong) NSString *reason; //: null,
@property (nonatomic, strong) NSString *remark; //: null,
@property (nonatomic, strong) NSString *workcontent; //: "工作安排",
@property (nonatomic, strong) NSString *leadspeak; //: null,
@property (nonatomic, strong) NSString *improvenode; //: null,
@property (nonatomic, strong) NSString *improvemeasures; //: null,
@property (nonatomic, strong) NSString *promise; //: null


@property (nonatomic) bool isAudited;

@end
