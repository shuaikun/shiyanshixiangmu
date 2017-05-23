//
//  SMRptZBAuditModel.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-13.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SMRptZBAuditModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic, strong) NSString *submitdate;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *deptname;

@property (nonatomic, strong) NSMutableArray *weeklist;
@property (nonatomic, strong) NSMutableArray *nextWeeklist;

-(void)fillDataWithFinishBlock:(void(^)(BOOL finished, NSString *msg))finishBlock;

@end
