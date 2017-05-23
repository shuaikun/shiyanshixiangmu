//
//  User.h
//  ConvertObjectToJson
//
//  Created by Sword on 13-11-12.
//  Copyright (c) 2013年 Sword. All rights reserved.
//

#import "ITTBaseModelObject.h"

@class Credit;

@interface User : ITTBaseModelObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) Credit *credit;

@end
