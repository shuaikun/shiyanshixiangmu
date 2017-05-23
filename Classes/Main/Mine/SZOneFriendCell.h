//
//  SZOneFriendCell.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-16.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZUserFriendsModel.h"

@protocol SZOneFriendCellDelegate <NSObject>
- (void)oneFriendCellFinishDeletePhone:(NSString *)phone ifSearch:(BOOL)ifSearch;
@end

@interface SZOneFriendCell : UITableViewCell

@property (assign, nonatomic) BOOL ifSearch;
@property (assign, nonatomic) id<SZOneFriendCellDelegate>delegate;

+ (SZOneFriendCell *)cellFromNib;
- (void)getDataSourceFromModel:(SZUserFriendsModel *)model;


@end
