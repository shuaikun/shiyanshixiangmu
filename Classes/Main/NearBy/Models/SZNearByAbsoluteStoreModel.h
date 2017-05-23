//
//  SZAbsoluteStoreModel.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-21.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"
/*!
 *  @brife  商铺详情的model
 *  @param  storeid 店铺id
 *  @param  store_name 名称
 *  @param  address 地址
 *  @param  tel 电话
 *  @param  score   星星（评分），是商铺表中sum_score字段和sum_num字段的商
 *  @param  supply_card 是否提供卡/券，1 仅提供卡，2 仅提供券，需结合有效期，3 都提供
 *  @param  is_collected 是否收藏了该店铺，1收藏了，0没有收藏，
 *  @param  open_time 营业时间
 *  @param  description 描述description
 *  @param  capita  人均消费
 *  @param  distance    距离
 *  @param  lng     经度
 *  @param  lat     纬度
 */
@interface SZNearByAbsoluteStoreModel : ITTBaseModelObject
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *supply_card;
@property (nonatomic, copy) NSString *is_collected;
@property (nonatomic, copy) NSString *open_time;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *capita;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *enterType;//1是签约的商户，-1是未签约的
@end
