//
//  WWPackageInfoCell.h
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-19.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWQrcodeModel.h"

@interface WWPackageInfoCell : UITableViewCell
+ (WWPackageInfoCell *)cellFromNib;
//- (void)getDataSourceFromModel:(WWGroupItemModel *)model;
- (void)showCellWithFinishBlock:(void(^)(WWQrcodeModel *model))finishBlock data:(WWQrcodeModel *)model;
@end
