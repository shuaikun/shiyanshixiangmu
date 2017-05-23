//
//  SZSwitchTabelViewCell.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "CYBasicTableViewCell.h"
typedef void(^SZSwichCellCallBack)(BOOL open);
@interface SZSwitchTabelViewCell : CYBasicTableViewCell
@property (nonatomic, copy) SZSwichCellCallBack switchCallBack;
@end
