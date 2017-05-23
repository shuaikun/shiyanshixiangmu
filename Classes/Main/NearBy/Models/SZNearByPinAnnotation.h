//
//  SZNearByPinAnnotation.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-22.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface SZNearByPinAnnotation : NSObject<MKAnnotation>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *capita;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *iconsFlag;
@property (nonatomic, copy) NSString *storeId;

@end
