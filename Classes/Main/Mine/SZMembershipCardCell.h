//
//  SZMembershipCardCell.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZMembershipCardModel.h"

@protocol SZMembershipCardCellDelegate <NSObject>
- (void)membershipCardCellFinishDeleteIndex:(int)index;
@end

@interface SZMembershipCardCell : UITableViewCell

@property (assign, nonatomic) int index;
@property (assign, nonatomic) id<SZMembershipCardCellDelegate>delegate;

+ (SZMembershipCardCell *)cellFromNib;
- (void)getDataSourceFromModel:(SZMembershipCardModel *)model;


@end
