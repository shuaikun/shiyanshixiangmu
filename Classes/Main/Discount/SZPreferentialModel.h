//
//  SZPreferentialModel.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"
#import "SZGoodsNameModel.h"

@interface SZPreferentialModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *pic_url;
@property (nonatomic, strong) NSString *descrip;
@property (nonatomic, strong) NSString *time_limit;
@property (nonatomic, strong) NSString *stock;
@property (nonatomic, strong) NSString *sales;
@property (nonatomic, strong) NSString *button;
@property (nonatomic, strong) NSString *expire_start;
@property (nonatomic, strong) NSString *expire_end;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *is_pic;
@property (nonatomic, strong) NSString *show_url;
@property (nonatomic, strong) SZGoodsNameModel *goods_name;

@end
