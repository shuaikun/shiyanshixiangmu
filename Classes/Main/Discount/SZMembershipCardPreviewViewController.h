//
//  SZMembershipCardPreviewViewController.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZBaseViewController.h"
@class SZGoodsNameModel;
@interface SZMembershipCardPreviewViewController : SZBaseViewController

@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *picurl;
@property (strong, nonatomic) SZGoodsNameModel *discount;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;

@end
