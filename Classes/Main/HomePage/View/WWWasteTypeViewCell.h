//
//  WWWasteTypeViewCell.h
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-07-25.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWWasteTypeModel.h"

@interface WWWasteTypeViewCell : UITableViewCell

+ (WWWasteTypeViewCell *)cellFromNib;
- (void)showWasteTypeCellWithFinishBlock:(void(^)(WWWasteTypeModel *backModel))finishBlock data:(WWWasteTypeModel *)model;

@end
