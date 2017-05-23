//
//  SMAttendTxCell.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-22.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAttendTxModel.h"

@protocol SMAttendTxCellDelegate <NSObject>

- (void)SMAttendTxCellButtonTapped:(SMAttendTxModel *)model index:(int)idx;

@end

@interface SMAttendTxCell : UITableViewCell
@property (assign, nonatomic) int index;
@property (assign, nonatomic) BOOL fromHistory;
@property (assign, nonatomic) id<SMAttendTxCellDelegate>delegate;

+ (SMAttendTxCell *)cellFromNib;
- (void)getDataSourceFromModel:(SMAttendTxModel *)model from:(id)target;
- (void)setBatchMode:(BOOL)batchMode;
@end
