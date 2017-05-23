//
//  WWQrcodeListItemCell.h
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-17.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWQrcodeListItemModel.h"

@interface WWQrcodeListItemCell : UITableViewCell
+ (WWQrcodeListItemCell *)cellFromNib;
- (void)getDataSourceFromModel:(WWQrcodeListItemModel *)model;
@end
