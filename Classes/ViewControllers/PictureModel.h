//
//  PictureModel.h
//  NationalGeography
//
//  Created by  on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITTBaseModelObject.h"

@interface PictureModel : ITTBaseModelObject
//
//{
//    "id": "xxxx",
//    "title": "金秋十月魅力伊利草原",
//    "dec": "中国廊桥是桥梁与房屋的珠联合璧之作。回溯两千多年历史长河...",
//    "author": "绝版青春",
//    "source": "来源",
//    "image_small": "http://www.fjldf.jmm/image/0001.jpg",
//    "image_big": "http://www.fjldf.jmm/image/0001.jpg",
//    "image_type": "1",
//    "image_wh": "640|480",//前为宽，后为高
//    
//    "fav_count": 0	//每个图片的被赞次数          
//}
@property (nonatomic, retain)NSString *pic_id;
@property (nonatomic, retain)NSString *title;
@property (nonatomic, retain)NSString *dec;
@property (nonatomic, retain)NSString *author;
@property (nonatomic, retain)NSString *source;
@property (nonatomic, retain)NSString *image_small;
@property (nonatomic, retain)NSString *image_big;
@property (nonatomic, retain)NSString *image_type;
@property (nonatomic, retain)NSString *image_wh;
@property (nonatomic, retain)NSString *fav_count;
@property (nonatomic, retain)NSMutableArray *locationArray;
@property (nonatomic, retain)NSString *image_tiny;
@property (nonatomic, retain)NSString *image_share;

@end
