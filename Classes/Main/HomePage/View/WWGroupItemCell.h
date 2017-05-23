//
//  WWGroupItemCell.h
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-18.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWGroupItemModel.h"

@interface WWGroupItemCell : UITableViewCell
+ (WWGroupItemCell *)cellFromNib;
//- (void)getDataSourceFromModel:(WWGroupItemModel *)model;
- (void)showGroupCellWithFinishBlock:(void(^)(WWGroupItemModel *model))finishBlock data:(WWGroupItemModel *)model;
@end
