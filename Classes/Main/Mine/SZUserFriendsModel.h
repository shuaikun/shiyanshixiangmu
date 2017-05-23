//
//  SZUserFriendsModel.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-17.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SZUserFriendsModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *real_name;
@property (nonatomic, strong) NSString *portrait;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *first_letter;

- (id)initWithRealName:(NSString *)realName FirstLetter:(NSString *)firstLetter;

@end
