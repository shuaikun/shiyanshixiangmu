//
//  SZStoreModel.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SZStoreModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *store_id;
@property (nonatomic, strong) NSString *pic_url;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *store_name;
@property (nonatomic, strong) NSString *supply_card;
@property (nonatomic, strong) NSString *store_score;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *capita;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *enterType;//1是签约的商户，-1是未签约的
@end
