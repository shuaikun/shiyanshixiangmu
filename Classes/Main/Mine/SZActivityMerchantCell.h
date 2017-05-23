//
//  SZActivityMerchantCell.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZActivityMerchantModel.h"
@protocol SZActivityMerchantCellDelegate<NSObject>
- (void)merchantCellFinishDeleteIndex:(int)index;
@end
@interface SZActivityMerchantCell : UITableViewCell

@property (assign, nonatomic) int index;
@property (assign, nonatomic) BOOL ifNearby;
@property (assign, nonatomic) BOOL isFromCollect;
@property (weak, nonatomic) id<SZActivityMerchantCellDelegate> delegate;

+ (SZActivityMerchantCell *)cellFromNib;
- (void)getDataSourceFromModel:(SZActivityMerchantModel *)model;

@end

