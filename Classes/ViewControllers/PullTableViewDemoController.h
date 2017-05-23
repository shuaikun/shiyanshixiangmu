//
//  TableDomeViewController.h
//  iTotemFramework
//
//  Created by admin on 13-1-27.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTPullTableView.h"
#import "BaseDemoViewController.h"

@interface PullTableViewDemoController : BaseDemoViewController<ITTPullTableViewDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet ITTPullTableView *tableView;

@end
