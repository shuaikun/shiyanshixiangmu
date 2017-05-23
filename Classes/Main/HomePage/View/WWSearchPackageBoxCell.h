//
//  WWSearchPackageBoxCell.h
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-20.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWSearchPackageInfoModel.h"

@interface WWSearchPackageBoxCell : UITableViewCell
+ (WWSearchPackageBoxCell *)cellFromNib;
- (void)showCellWithFinishBlock:(void(^)(WWSearchPackageInfoModel *model))finishBlock data:(WWSearchPackageInfoModel *)model;
@end
