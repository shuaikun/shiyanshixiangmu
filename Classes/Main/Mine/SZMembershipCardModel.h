//
//  SZMembershipCardModel.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"
#import "SZGoodsNameModel.h"

@interface SZMembershipCardModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *store_name;
@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *pic_url;
@property (nonatomic, strong) SZGoodsNameModel *goods_name;
@property (nonatomic, strong) NSString *is_pic;
@property (nonatomic, strong) NSString *show_url;
@property (nonatomic, strong) NSString *code;
@end
