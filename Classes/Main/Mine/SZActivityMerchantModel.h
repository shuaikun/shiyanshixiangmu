//
//  SZActivityMerchantModel.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SZActivityMerchantModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *store_id;
@property (nonatomic, strong) NSString *pic_url;
@property (nonatomic, strong) NSString *store_name;
@property (nonatomic, strong) NSString *supply_card;
@property (nonatomic, strong) NSString *store_score;
@property (nonatomic, strong) NSString *capita;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *is_pic;
@property (nonatomic, strong) NSString *show_url;
@end
