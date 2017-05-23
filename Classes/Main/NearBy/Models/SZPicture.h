//
//  SZPicture.h
//  iTotemFramework
//
//  Created by 成焱 on 14-5-9.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SZPicture <NSObject>
@property (nonatomic, copy) NSString *pic_url;
@optional
@property (nonatomic, copy) NSString *img_id;
@property (nonatomic, copy) NSString *title;
@end
