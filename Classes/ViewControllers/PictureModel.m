//
//  PictureModel.m
//  NationalGeography
//
//  Created by  on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PictureModel.h"

//{
//    "image_big": "http://content.dili360.com/public/data/pic/201210/800_1350125008.jpg",
//    "image_small": "http://content.dili360.com/public/data/pic/201210/480_1350125008.jpg",
//    "image_wh": "800|567",
//    "id": "179",
//    "title": "山东半岛海域",
//    "dec": "这是山东半岛海域的围网捕捞场景，从空中俯视捕捞现场，像是在湛蓝的海面上随意画出的圆，十分漂亮和写意，在船上看现场捕捞却充满了惊心动魄的动感，渔船上的机械操纵着围网的起和放，每一个过程都让人充满期待。",
//    "author": "侯贺良",
//    "image_type": "1",
//    "fav_count": "0",
//    "source": "中国国家地理"
//}
@implementation PictureModel
@synthesize pic_id;
@synthesize title;
@synthesize dec;
@synthesize author;
@synthesize source;
@synthesize image_small;
@synthesize image_big;
@synthesize image_type;
@synthesize image_wh;
@synthesize fav_count;
@synthesize locationArray;

- (id)init
{
    self = [super init];
    if (self) {
        locationArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSDictionary*)attributeMapDictionary{	
	return [NSDictionary dictionaryWithObjectsAndKeys:
                @"id",@"pic_id",
                @"title",@"title",
                @"dec",@"dec",
                @"author",@"author",
                @"source",@"source",
                @"image_small",@"image_small",
                @"image_big",@"image_big",
                @"image_type",@"image_type",
                @"image_wh",@"image_wh",
                @"fav_count",@"fav_count",
                @"location",@"locationArray",
                @"image_tiny",@"image_tiny",
                @"image_share",@"image_share",
            nil];
}

@end
