//
//  SMReportViewController.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SZBaseViewController.h"

@interface SMReportViewController : UIViewController
@property (assign, nonatomic) BOOL isFromHomePage;
-(void)setChoice:(ReportChoiceTag)tag;
@end
