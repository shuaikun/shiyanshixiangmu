//
//  SMAttendAuditButtonView.h
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-7.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "ITTXibView.h"

@protocol SMAttendAuditButtonViewDelegate <NSObject>

- (void)SMAttendAuditButtonViewButtonTapped:(int)idx;

@end

@interface SMAttendAuditButtonView : ITTXibView

@property (assign, nonatomic) id<SMAttendAuditButtonViewDelegate>delegate;
@property (assign, nonatomic) int idx;

- (void)setSelected:(int)idx;

@end
