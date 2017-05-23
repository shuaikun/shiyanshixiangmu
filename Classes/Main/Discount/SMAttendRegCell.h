//
//  SMAttendRegCell.h
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-7.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAttendRegModel.h"

@protocol SMAttendAuditRegCellDelegate <NSObject>

- (void)SMAttendAuditRegCellButtonTapped:(SMAttendRegModel *)model index:(int)idx;


@end

@interface SMAttendRegCell : UITableViewCell
@property (assign, nonatomic) int index;
@property (assign, nonatomic) BOOL fromHistory;
@property (assign, nonatomic) id<SMAttendAuditRegCellDelegate>cellDelegate;

+ (SMAttendRegCell *)cellFromNib;
- (void)getDataSourceFromModel:(SMAttendRegModel *)model from:(id)target;
- (void)setBatchMode:(BOOL)batchMode;
@end
