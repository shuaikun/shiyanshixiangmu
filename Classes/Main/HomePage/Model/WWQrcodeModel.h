//
//  WWQrcodeModel.h
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-16.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "ITTBaseModelObject.h"
#import "WWQrcodeListItemModel.h"

@interface WWQrcodeModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *containerType;
@property (nonatomic, strong) NSString *containerSize;
@property (nonatomic, strong) NSString *containerName;
@property (nonatomic, strong) NSString *containerIdentifier;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *contact;

@property (nonatomic, strong) NSString *qrCode;

@property (nonatomic, strong) NSString *orgCode;
@property (nonatomic, strong) NSString *orgName;
@property (nonatomic, strong) NSString *depCode;
@property (nonatomic, strong) NSString *depName;
@property (nonatomic, strong) NSString *groupType;

@property (nonatomic, strong) NSString *gw;
@property (nonatomic, strong) NSString *selfWeight;
@property (nonatomic, strong) NSString *shiyongdanwei;
@property (nonatomic, strong) NSString *suoshudanwei;

@property (nonatomic, strong) NSString *useCount;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *remark;

@property (nonatomic, strong) NSMutableArray *list;

-(WWPackageBoxStatus) packageBoxStatus;

@end
