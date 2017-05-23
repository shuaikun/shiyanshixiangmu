//
//  SZNearByAroundStoreModel.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-21.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SZNearByAroundStoreModel : ITTBaseModelObject
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@end
