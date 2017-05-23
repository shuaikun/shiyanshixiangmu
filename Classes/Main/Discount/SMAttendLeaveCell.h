//
//  SMAttendLeaveCell.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAttendLeaveModel.h"

@protocol SMAttendAuditLeaveCellDelegate <NSObject>

- (void)SMAttendAuditLeaveCellButtonTapped:(SMAttendLeaveModel *)model index:(int)idx;

@end

@interface SMAttendLeaveCell : UITableViewCell

@property (assign, nonatomic) int index;
@property (assign, nonatomic) BOOL fromHistory;
@property (assign, nonatomic) id<SMAttendAuditLeaveCellDelegate>cellDelegate;

+ (SMAttendLeaveCell *)cellFromNib;
- (void)getDataSourceFromModel:(SMAttendLeaveModel *)model from:(id)target;
- (void)setBatchMode:(BOOL)batchMode;

@end
