//
//  AQCNews.h
//  AiQiChe
//
//  Created by lian jie on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITTBaseModelObject.h"

@interface AQCNews : ITTBaseModelObject {
    NSString *_newsId;
    NSString *_title;
    NSString *_contentUrl;
    NSString *_originalUrl;
    NSString *_imageUrl;
    NSString *_source;
    NSString *_desc;
}

@property (nonatomic,strong) NSString *newsId;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *contentUrl;
@property (nonatomic,strong) NSString *originalUrl;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *source;
@property (nonatomic,strong) NSString *desc;

- (NSString*)getContentUrlByNewsId;
- (NSString*)getNewidForComment;
-(BOOL)hasImage;
@end
