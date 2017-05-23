//
//  SMNewsPreferentialCell.h
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-4.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMNewsModel.h"
#import <QuickLook/QuickLook.h>

@interface SMNewsPreferentialCell : UITableViewCell<QLPreviewControllerDataSource>

@property (assign, nonatomic) int index;
@property (assign, nonatomic) BOOL fromHistory;

+ (SMNewsPreferentialCell *)cellFromNib;
- (void)getDataSourceFromModel:(SMNewsModel *)model;



@end
