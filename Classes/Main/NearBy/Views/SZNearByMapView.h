//
//  SZNeayByMapView.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"
#import <MapKit/MapKit.h>
typedef void(^NearByMapCallBacks) (void);
typedef void(^NearByMapCalloutClick)(NSString *storeId);
@interface SZNearByMapView : ITTXibView<CLLocationManagerDelegate>
@property (nonatomic, assign) NSUInteger min;
@property (nonatomic, assign) NSUInteger max;
@property (nonatomic, copy) NSString *distanceFilter;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, copy) NearByMapCallBacks backClickCallBack;
@property (nonatomic, copy) NearByMapCallBacks frontMerchantCallBack;
@property (nonatomic, copy) NearByMapCallBacks nextMerchantCallBack;
@property (nonatomic, copy) NearByMapCallBacks merchantDetailCallBack;
@property (nonatomic, copy) NearByMapCallBacks fetchAnnotationsCallBack;
@property (nonatomic, copy) NearByMapCalloutClick callOutClick;
@property (weak, nonatomic) IBOutlet UIButton *frontBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger endIndex;
@end
