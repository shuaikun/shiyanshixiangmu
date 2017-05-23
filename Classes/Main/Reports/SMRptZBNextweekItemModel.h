//
//  SMRptZBNextweekItemModel.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SMRptZBNextweekItemModel : ITTBaseModelObject
@property (nonatomic, strong) NSString *person;  //涉及人员",
@property (nonatomic, strong) NSString *measures;  //方法措施",
@property (nonatomic, strong) NSString *timenode;  //2014-09-15",
@property (nonatomic, strong) NSString *punishment;  //自罚承诺",
@property (nonatomic, strong) NSString *id;  //f18a6fc84845b4b401485934a2370006",
@property (nonatomic, strong) NSString *level;  //很重要不紧急",
@property (nonatomic, strong) NSString *reason;  //null,
@property (nonatomic, strong) NSString *remark;  //备  注备  注备  注",
@property (nonatomic, strong) NSString *workcontent;  //工作安排",
@property (nonatomic, strong) NSString *leadspeak;  //null,
@property (nonatomic, strong) NSString *improvenode;  //null,
@property (nonatomic, strong) NSString *improvemeasures;  //null,
@property (nonatomic, strong) NSString *promise;  //null

@property (nonatomic) bool isAudited;

@end
