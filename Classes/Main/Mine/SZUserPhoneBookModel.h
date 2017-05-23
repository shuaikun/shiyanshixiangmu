//
//  SZUserPhoneBookModel.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SZUserPhoneBookModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *friend_name;
@property (nonatomic, strong) NSString *friend_mobile;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *portrait;

@end
