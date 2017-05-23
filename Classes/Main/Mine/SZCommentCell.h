//
//  SZCommentCell.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZCommentModel.h"

@protocol SZCommentCellDelegate <NSObject>
- (void)deleteCommentForCellModel:(SZCommentModel *)model;
@end


@interface SZCommentCell : UITableViewCell

@property (nonatomic, weak) id<SZCommentCellDelegate> delegate;

+ (SZCommentCell *)cellFromNib;
+ (CGFloat)getCellHeightFromModel:(SZCommentModel *)model;
- (void)getDataSourceFromModel:(SZCommentModel *)model;

@end
