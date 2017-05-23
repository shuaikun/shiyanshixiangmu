//
//  SZHNearByCustomAnnotationView.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-22.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SZStarView.h"
typedef void (^SZNearByCustomAnnotationCallBack)(NSString *storeId);
@interface SZNearByCustomAnnotationView : MKAnnotationView
@property (nonatomic, copy) SZNearByCustomAnnotationCallBack click;
- (void)configWithModel:(id)model;
@end
