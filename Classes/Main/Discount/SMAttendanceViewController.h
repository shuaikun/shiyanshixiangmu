//
//  SMAttendanceViewController.h
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-6.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SZBaseViewController.h"
#import "SZFilterView.h"
#import "SMAttendAuditButtonView.h"
#import "SMAttendRegCell.h"
#import "SMAttendLeaveCell.h"
#import "SMAttendTxCell.h"

//SMAttendAuditButtonViewDelegate

@interface SMAttendanceViewController : UIViewController<SZFilterViewDelegate, SMAttendAuditRegCellDelegate, SMAttendAuditLeaveCellDelegate, SMAttendTxCellDelegate>

@property (strong, nonatomic) IBOutlet SZFilterView * filterView;
@property (assign, nonatomic) BOOL isFromHomePage;
@property (assign, nonatomic) KaoQinOneChoiceTag selectChoice;

@property (strong, nonatomic) IBOutlet SMAttendAuditButtonView *attendButtonView;

-(void) setChoiceType:(KaoQinOneChoiceTag)choiceTag;

@end
