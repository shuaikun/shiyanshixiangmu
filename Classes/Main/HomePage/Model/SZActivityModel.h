//
//  SZActivityModel.h
//  iTotemFramework
//
//  Created by Grant on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//
#import "ITTBaseModelObject.h"
//aac_id	int     活动id
//type      int     1普惠,2 抢,3抽,4限商家
//title     string	活动名称
//pic_url	string	图片地址
@interface SZActivityModel : ITTBaseModelObject
@property (nonatomic, strong) NSString *aac_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *pic_url;
@end
