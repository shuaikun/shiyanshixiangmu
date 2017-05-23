//
//  SMNewsModel.h
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-5.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface SMNewsModel : ITTBaseModelObject
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content_id;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *release_date;
@end
