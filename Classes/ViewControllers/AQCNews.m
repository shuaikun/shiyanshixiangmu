//
//  AQCNews.m
//  AiQiChe
//
//  Created by lian jie on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AQCNews.h"


@implementation AQCNews

- (NSDictionary*)attributeMapDictionary
{
	return @{@"newsId": @"newsid"
            ,@"title": @"title"
            ,@"contentUrl": @"url"
            ,@"originalUrl": @"link"
            ,@"imageUrl": @"img"
            ,@"source": @"source"
            ,@"desc": @"desc"};
}


- (NSString*)getContentUrlByNewsId
{
    return [NSString stringWithFormat:@"http://202.108.35.176/interface/get_newpage_bynewsid.php?newsid=%@",_newsId];
}

- (NSString*)getNewidForComment
{
    return [NSString stringWithFormat:@"33-2-%@",_newsId];
}

-(BOOL)hasImage
{
    return (_imageUrl && [_imageUrl length] > 0);
}
@end
