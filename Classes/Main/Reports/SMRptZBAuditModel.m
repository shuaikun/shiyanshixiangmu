//
//  SMRptZBAuditModel.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-13.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptZBAuditModel.h"
#import "SMRptZBAuditPlanListRequest.h"
#import "SMRptZBWeekItemModel.h"
#import "SMRptZBNextweekItemModel.h"

@interface SMRptZBAuditModel()

@property (nonatomic, copy) void(^finishPickBlock)(BOOL finished, NSString *msg);

@end

@implementation SMRptZBAuditModel
- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"id", @"id",
            @"username", @"username",
            @"condition", @"condition",
            @"submitdate", @"submitdate",
            @"date", @"date",
            @"deptname", @"deptname",
            nil];     
}


-(void)fireFinished
{
    if (_finishPickBlock) {
        _finishPickBlock(TRUE, @"初始化数据成功");
    }
}
-(void)fireFailed
{
    if (_finishPickBlock) {
        _finishPickBlock(FALSE, @"初始化数据未成功");
    }
}


-(void)fillDataWithFinishBlock:(void(^)(BOOL finished, NSString *msg))finishBlock{
    
    self.finishPickBlock = finishBlock;
    
    [self fillWeeklist];
}

-(void)fillWeeklist
{
    if (self.weeklist == nil){
        self.weeklist = [[NSMutableArray alloc] init];
    }
    
    if (IS_STRING_NOT_EMPTY(self.id)){
        [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
            
            
            NSString *userid = [[UserManager sharedUserManager] userId];
            NSDictionary *params = @{
                                     @"userid":userid,
                                     @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                     @"worklog_id": self.id,
                                     @"pojoname":@"Weekly"
                                     };
            ITTDINFO(@"request params :[%@]" ,params);
            
            
            [SMRptZBAuditPlanListRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                NSLog(@"start loading");
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
                
            } onRequestFinished:^(ITTBaseDataRequest *request) {
                if (request.isSuccess) {
                    NSArray *itemlist = [request.handleredResult objectForKey:@"data"];
                    
                    if(itemlist && [itemlist isKindOfClass:[NSArray class]]){
                        for (int i=0; i<[itemlist count]; i++) {
                            SMRptZBWeekItemModel *zbmodel = [[SMRptZBWeekItemModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
                            [self.weeklist addObject:zbmodel];
                        }
                    }
                    
                    [self fillNextWeeklist];
                }
                else{
                    [PROMPT_VIEW showMessage:@"无法获取待审核的本周工作概要信息"];
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
                [self fireFailed];
            }];
        }];
    }
    
}

-(void)fillNextWeeklist
{
    if (self.nextWeeklist == nil){
        self.nextWeeklist = [[NSMutableArray alloc] init];
    }
    
    if (IS_STRING_NOT_EMPTY(self.id)){
        [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
            
            
            NSString *userid = [[UserManager sharedUserManager] userId];
            NSDictionary *params = @{
                                     @"userid":userid,
                                     @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                     @"worklog_id": self.id,
                                     @"pojoname":@"NextWeekly"
                                     };
            ITTDINFO(@"request params :[%@]" ,params);
            
            
            [SMRptZBAuditPlanListRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                NSLog(@"start loading");
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
                
            } onRequestFinished:^(ITTBaseDataRequest *request) {
                if (request.isSuccess) {
                    NSArray *itemlist = [request.handleredResult objectForKey:@"data"];
                    
                    if(itemlist && [itemlist isKindOfClass:[NSArray class]]){
                        for (int i=0; i<[itemlist count]; i++) {
                            SMRptZBNextweekItemModel *zbmodel = [[SMRptZBNextweekItemModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
                            [self.nextWeeklist addObject:zbmodel];
                        }
                    }
                    [self fireFinished];
                }
                else{
                    [PROMPT_VIEW showMessage:@"无法获取待审核的下周周工作计划信息"];
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
                [self fireFailed];
            }];
        }];
    }
}



@end
