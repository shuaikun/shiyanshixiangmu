//
//  SZCommentModel.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SZCommentModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *aa_id;
@property (nonatomic, strong) NSString *store_id;
@property (nonatomic, strong) NSString *store_name;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *add_time;

- (id)initWithComment:(NSString *)comment;

@end
