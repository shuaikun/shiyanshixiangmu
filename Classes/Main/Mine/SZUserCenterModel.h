//
//  SZUserCenterModel.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SZUserCenterModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *goods_sum;
@property (nonatomic, strong) NSString *cards_sum;
@property (nonatomic, strong) NSString *collects_sum;
@property (nonatomic, strong) NSString *friends_sum;
@property (nonatomic, strong) NSString *comments_sum;
@property (nonatomic, strong) NSString *friends_dyn_sum;
@property (nonatomic, strong) NSString *newrecord;      //1为有新动态 0没有

@end
