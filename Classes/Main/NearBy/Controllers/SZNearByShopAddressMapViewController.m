//
//  SZNearByShopAddressMapViewController.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-30.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByShopAddressMapViewController.h"
#import <MapKit/MapKit.h>
#import "SZNearByUserLocationAnnotationView.h"
#import "SZCurrentLocationAnnotation.h"
#import "SZNearByPinAnnotation.h"
#import "SZNearByCustomAnnotation.h"
#import "SZNearByCustomAnnotationView.h"

@interface SZNearByShopAddressMapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) SZCurrentLocationAnnotation *userAnnotation;
@property (nonatomic, retain) SZNearByPinAnnotation *pinAnnotation;
@property (nonatomic, retain) SZNearByCustomAnnotation *callOutAnnotation;
- (IBAction)handleBackClick:(id)sender;

@end

@implementation SZNearByShopAddressMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startShopMapAddressRequest];
}

- (void)startShopMapAddressRequest
{
    [[UserManager sharedUserManager]getCurrentLocationWithBlock:^(CLLocation *location, INTULocationAccuracy accuracy, BOOL isSuccess){
        if (isSuccess) {
            CLLocationCoordinate2D currentCoordinate = location.coordinate;
            self.userAnnotation = [[SZCurrentLocationAnnotation alloc]init];
            self.userAnnotation.title = @"当前位置";
            self.userAnnotation.coordinate = currentCoordinate;
            [self.mapView addAnnotation:self.userAnnotation];
            
            
            SZNearByPinAnnotation *pinAnnotation = [[SZNearByPinAnnotation alloc]init];
            pinAnnotation.coordinate = CLLocationCoordinate2DMake([self.storeModel.lat doubleValue], [self.storeModel.lng doubleValue]);
            pinAnnotation.storeId = self.storeModel.store_id;
            pinAnnotation.storeName = self.storeModel.store_name;
            pinAnnotation.capita = self.storeModel.capita;
            pinAnnotation.address = self.storeModel.address;
            pinAnnotation.score = self.storeModel.score;
            pinAnnotation.iconsFlag = self.storeModel.supply_card;
            [self.mapView addAnnotation:pinAnnotation];
            MKCoordinateRegion region = MKCoordinateRegionMake(pinAnnotation.coordinate, MKCoordinateSpanMake(0.03, 0.03));
            MKCoordinateRegion fitRegion = [self.mapView regionThatFits:region];
            if (isnan(fitRegion.span.latitudeDelta)) {
                
            }else{
               [self.mapView setRegion:region animated:YES];
            }
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[SZCurrentLocationAnnotation class]]) {
        static NSString *currentAnnotation = @"currentLocationAnnotation";
        SZNearByUserLocationAnnotationView  *annotationView = (SZNearByUserLocationAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:currentAnnotation];
        if (annotationView == nil) {
            annotationView = [[SZNearByUserLocationAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:currentAnnotation];
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
            [self popMasterViewController];
        };
        annotationView.canShowCallout = NO;
        return annotationView;
    }else{
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (IBAction)handleBackClick:(id)sender {
    [self popMasterViewController];
}
@end
