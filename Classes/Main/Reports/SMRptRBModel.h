//
//  SMRptRBModel.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-2.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "ITTBaseModelObject.h"
#import "SMRptRBItemModel.h"

@interface SMRptRBModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *tommemo;
@property (nonatomic, strong) NSString *ywc;
@property (nonatomic, strong) NSArray *dailys;
@property (nonatomic, strong) NSString *submitstatus;
@property (nonatomic, strong) NSString *submitdate;
@property (nonatomic, strong) NSString *zt;
@property (nonatomic, strong) NSString *summarize;
@property (nonatomic, strong) NSString *ldpf;
@property (nonatomic, strong) NSString *jxgj;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *wwc;
@end
