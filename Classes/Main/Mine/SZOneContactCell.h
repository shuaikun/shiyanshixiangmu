//
//  SZOneContactCell.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZUserPhoneBookModel.h"

@protocol SZOneContactCellDelegate <NSObject>

- (void)oneContactCellDidChooseAddOnUserPhone:(NSString *)phoneNumber;
- (void)oneContactCellDidChooseInviteOnUserPhone:(NSString *)phoneNumber;

@end

@interface SZOneContactCell : UITableViewCell

@property (assign, nonatomic) id<SZOneContactCellDelegate>delegate;
+ (SZOneContactCell *)cellFromNib;
- (void)getDataSourceFromModel:(SZUserPhoneBookModel *)model;

@end
