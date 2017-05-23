//
//  SZNearByProductListCell.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-24.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "CYBasicTableViewCell.h"
#import "SZNearByProductPicModel.h"
typedef void (^SZNearByProductListCellClick)(SZNearByProductPicModel *pic);
@interface SZNearByProductListCell : CYBasicTableViewCell
@property (nonatomic, copy) SZNearByProductListCellClick click;
@end
