//
//  SZNeayByMapView.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByMapView.h"
#import "SZNearByMerchantListRequest.h"
#import "SZUserCommentViewController.h"
#import "SZCurrentLocationAnnotation.h"
#import "SZNearByCustomAnnotation.h"
#import "SZNearByUserLocationAnnotationView.h"
#import "SZNearByCustomAnnotationView.h"
#import "SZNearByPinAnnotation.h"
@interface SZNearByMapView()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *merchantLabel;


@property (nonatomic,   strong) SZCurrentLocationAnnotation *userAnnotation;
@property (nonatomic,   strong) SZNearByCustomAnnotation *callOutAnnotation;

- (IBAction)handleBackOrListClick:(id)sender;
- (IBAction)handleCurrentLocationClick:(id)sender;
- (IBAction)handleFrontMerchantClick:(id)sender;
- (IBAction)handleNextMerchantClick:(id)sender;

@end

@implementation SZNearByMapView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.dataSource = [[NSMutableArray alloc]init];
        self.startIndex = 1;
        self.endIndex = 1;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = [[NSMutableArray alloc]init];
        self.startIndex = 1;
        self.endIndex = 1;
    }
    return self;
}

- (void)setStartIndex:(NSInteger)startIndex
{
    _startIndex = startIndex;
    self.merchantLabel.text = [NSString stringWithFormat:@"第%d-%d家",startIndex,self.endIndex];
}

- (void)setEndIndex:(NSInteger)endIndex
{
    _endIndex = endIndex;
    if (endIndex==0) {
        self.merchantLabel.text = @"第0家-0家";
    }else {
        self.merchantLabel.text = [NSString stringWithFormat:@"第%d-%d家",self.startIndex,endIndex];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        self.mapView.delegate = self;
        self.frontBtn.enabled = NO;
        self.merchantLabel.adjustsFontSizeToFitWidth = YES;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[SZCurrentLocationAnnotation class]]) {
        static NSString *identifier1 = @"currentLocationAnnotation";
        SZNearByUserLocationAnnotationView *annotationView = (SZNearByUserLocationAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier1];
        if (annotationView==nil) {
            annotationView = [[SZNearByUserLocationAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier1];
            annotationView.annotationColor = RGBCOLOR(24, 107, 254);
        }
        annotationView.canShowCallout = YES;
        return annotationView;
    }else if([annotation isKindOfClass:[SZNearByCustomAnnotation class]]){
        static NSString *identifier2 = @"customAnnotation";
        SZNearByCustomAnnotationView *annotationView = (SZNearByCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier2];
        if (annotationView==nil) {
            annotationView = [[SZNearByCustomAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier2];
        }
        [annotationView configWithModel:annotation];
        annotationView.click = ^(NSString *storeId){
            if (self.callOutClick!=nil) {
                self.callOutClick(storeId);
            }
        };
        annotationView.canShowCallout = NO;
        return annotationView;
    }else {
        static NSString *identifier3 = @"pinAnnotation";
        MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier3];
        if (pin==nil) {
            pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier3];
            pin.pinColor = MKPinAnnotationColorRed;
        }
        return pin;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[SZNearByCustomAnnotation class]]) {
        return;
    }else if ([view isKindOfClass:[MKPinAnnotationView class]]){
        SZNearByPinAnnotation *annotaion = (SZNearByPinAnnotation *)view.annotation;
        self.callOutAnnotation = [[SZNearByCustomAnnotation alloc]init];
        self.callOutAnnotation.coordinate = annotaion.coordinate;
        self.callOutAnnotation.title = annotaion.title;
        self.callOutAnnotation.subtitle = annotaion.subtitle;
        self.callOutAnnotation.storeName = annotaion.storeName;
        self.callOutAnnotation.score = annotaion.score;
        self.callOutAnnotation.capita = annotaion.capita;
        self.callOutAnnotation.address = annotaion.address;
        self.callOutAnnotation.iconFlag = annotaion.iconsFlag;
        self.callOutAnnotation.storeId = annotaion.storeId;
        [self.mapView addAnnotation:self.callOutAnnotation];
        [self.mapView setCenterCoordinate:self.callOutAnnotation.coordinate animated:YES];
    }else{
        NSLog(@"goo");
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[MKPinAnnotationView class]]) {
        if (self.callOutAnnotation!=nil) {
            [self.mapView removeAnnotation:self.callOutAnnotation];
        }
    }
}

- (IBAction)handleBackOrListClick:(id)sender
{
    if (self.backClickCallBack!=nil) {
        self.backClickCallBack();
    }
}

- (IBAction)handleCurrentLocationClick:(id)sender
{
    [[UserManager sharedUserManager]getCurrentLocationWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, BOOL isSuccess){
        if (isSuccess) {
            CLLocationCoordinate2D coordinate = currentLocation.coordinate;
            [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, [self.distanceFilter floatValue], [self.distanceFilter floatValue]) animated:YES];
            if (self.userAnnotation!=nil) {
                [self.mapView removeAnnotation:self.userAnnotation];
            }
            self.userAnnotation = [[SZCurrentLocationAnnotation alloc]init];
            self.userAnnotation.title = @"当前位置";
            self.userAnnotation.coordinate = coordinate;
            [self.mapView addAnnotation:self.userAnnotation];
        }
    }];
}

- (IBAction)handleFrontMerchantClick:(id)sender
{
    if (self.frontMerchantCallBack!=nil) {
        self.frontMerchantCallBack();
    }
}

- (IBAction)handleNextMerchantClick:(id)sender
{
    if (self.nextMerchantCallBack!=nil) {
        self.nextMerchantCallBack();
    }
}
@end
