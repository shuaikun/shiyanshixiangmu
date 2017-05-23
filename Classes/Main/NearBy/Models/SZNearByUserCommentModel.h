//
//  SZUserCommentModel.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-21.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SZNearByUserCommentModel : ITTBaseModelObject
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *uavatar;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *anonymous;
@end
