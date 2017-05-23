//
//  WWGroupItemModel.h
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-18.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface WWGroupItemModel : ITTBaseModelObject
@property (nonatomic, strong) NSString *orgCode;
@property (nonatomic, strong) NSString *orgName;
@property (nonatomic, strong) NSString *depCode;
@property (nonatomic, strong) NSString *depName;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *groupType;

@property (nonatomic, strong) NSString *pinyin;

@end
