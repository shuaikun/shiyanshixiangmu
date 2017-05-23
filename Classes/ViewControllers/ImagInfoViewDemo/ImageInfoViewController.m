//
//  ViewController.m
//  PhotoGPSdemo
//
//  Created by Alex on 12-12-20.
//  Copyright (c) 2012年 Alex. All rights reserved.
//

#import "ImageInfoViewController.h"
#import "AppDelegate.h"
#import "HomeTabBarController.h"


@interface ImageInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,CLLocationManagerDelegate>

@property (nonatomic, unsafe_unretained) IBOutlet UIImageView* imgView;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *latitudeLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *longtitudeLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong)            CLLocationManager* locationManager;
@property (nonatomic, strong)            NSMutableDictionary* mediaInfo;//当前照片的mediaInfo
@property (nonatomic, strong)            UIImage* image;//当前照片

- (IBAction)takePhoto:(id)sender;
- (IBAction)showAlbum;

@end

@implementation ImageInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [AppDelegate GetAppDelegate].tabBarController.tabBarHidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.imgView=nil;
    self.locationManager=nil;
}

#pragma mark custom
- (IBAction)takePhoto:(id)sender
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.showsCameraControls = YES;
        imagePickerController.allowsEditing = NO;
        imagePickerController.delegate = self;
        self.wantsFullScreenLayout =YES;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }else{
        NSLog(@"无法拍照！");
    }
}

- (IBAction)showAlbum
{
	UIImagePickerController *albumPicker = [[UIImagePickerController alloc] init];
	albumPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	albumPicker.delegate = self;
    [self presentViewController:albumPicker animated:YES completion:^{}];
}

- (void)getImageInfo:(UIImage *)myUIImage
{
    NSData *jpeg = UIImageJPEGRepresentation(myUIImage,1.0);
    CGImageSourceRef  source = CGImageSourceCreateWithData((__bridge  CFDataRef)jpeg, NULL);
    NSDictionary *metadata = (NSDictionary *) CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source,0,NULL));
    CFRelease(source);
    NSMutableDictionary *info = [metadata mutableCopy];
    NSLog(@"%@", info);
}

/*
 保存图片到相册
 */
- (void)writeCGImage:(UIImage*)image metadata:(NSDictionary *)metadata
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    ALAssetsLibraryWriteImageCompletionBlock imageWriteCompletionBlock =
    ^(NSURL *newURL, NSError *error) {
        if (error) {
            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
        } else {
            NSLog( @"Wrote image with metadata to Photo Library");
        }
    };
    
    //保存相片到相册 注意:必须使用[image CGImage]不能使用强制转换: (__bridge CGImageRef)image,否则保存照片将会报错
    [library writeImageToSavedPhotosAlbum:[image CGImage]
                                 metadata:metadata
                          completionBlock:imageWriteCompletionBlock];
}

#pragma mark UIImagePickerControlleDelegates
- (void) imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (info && [info count] > 0) {
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            //图片
            UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
            self.image=image;
            self.imgView.image=image;
            
            //照片mediaInfo
            self.mediaInfo=[NSMutableDictionary dictionaryWithDictionary:info];
            
            if (!_locationManager) {
                _locationManager = [[CLLocationManager alloc]init];
                [_locationManager setDelegate:self];
                [_locationManager setDistanceFilter:kCLDistanceFilterNone];
                [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            }
            [_locationManager startUpdatingLocation];
        } else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
            __block UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
            if (image){
                self.imgView.image=image;
                self.image=image;
                
                __block NSMutableDictionary *imageMetadata = nil;
                NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library assetForURL:assetURL
                         resultBlock:^(ALAsset *asset){
                             imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:asset.defaultRepresentation.metadata];
                             NSLog(@"MetaData:%@", imageMetadata);
                             if (imageMetadata && [imageMetadata count] > 0){
                                 //GPS数据
                                 NSDictionary *GPSDict=[imageMetadata objectForKey:(NSString*)kCGImagePropertyGPSDictionary];
                                 NSLog(@"GPS info:%@", GPSDict);
                                 if (GPSDict && [GPSDict count] > 0){
                                     CLLocation *loc=[GPSDict locationFromGPSDictionary];
                                     self.latitudeLabel.text = [NSString stringWithFormat:@"经度:%f", loc.coordinate.latitude];
                                     self.longtitudeLabel.text = [NSString stringWithFormat:@"纬度:%f", loc.coordinate.longitude];
                                 }
                                 else{
                                     self.latitudeLabel.text = @"经度信息:无";
                                     self.longtitudeLabel.text = @"纬度信息:无";
                                 }
                                 
                                 //EXIF数据
                                 NSMutableDictionary *EXIFDictionary =[[imageMetadata objectForKey:(NSString *)kCGImagePropertyExifDictionary]mutableCopy];

                                 if (EXIFDictionary && [EXIFDictionary count] > 0) {
                                     NSString * dateTimeOriginal=[[EXIFDictionary objectForKey:(NSString*)kCGImagePropertyExifDateTimeOriginal] mutableCopy];
                                     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                     [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];//yyyy-MM-dd HH:mm:ss
                                     NSDate *date = [dateFormatter dateFromString:dateTimeOriginal];
                                     self.dateLabel.text = [NSString stringWithFormat:@"拍摄日期:%@", [date description]];
                                 }else{
                                     self.dateLabel.text = @"拍摄日期:无";
                                 }
                             }
                         }
                        failureBlock:^(NSError *error) {
                        }];
            }
        }
    }
    [picker dismissViewControllerAnimated:NO completion:^{}];
}

/*
 kCGImagePropertyExifDateTimeOriginal
 以下表列几项EXIF会提供的讯息：
 制造厂商
 相机型号
 影像方向
 影像分辨率 X
 影像分辨率 Y
 分辨率单位
 Software
 最后异动时间
 YCbCrPositioning
 曝光时间
 光圈值
 拍摄模式
 ISO 感光值
 EXIF 资讯版本
 影像拍摄时间
 影像存入时间
 曝光补偿（EV+-）
 测光模式
 闪光灯
 镜头实体焦长
 Flashpix 版本
 影像色域空间
 影像尺寸 X
 影像尺寸 Y
 */

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:^{}];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"定位成功！");
    [manager stopUpdatingLocation];
    self.latitudeLabel.text = [NSString stringWithFormat:@"经度:%f", newLocation.coordinate.latitude];
    self.longtitudeLabel.text = [NSString stringWithFormat:@"纬度:%f", newLocation.coordinate.longitude];
    

    //获取照片元数据
    NSDictionary *dict = [_mediaInfo objectForKey:UIImagePickerControllerMediaMetadata];
    NSMutableDictionary *metadata = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    //将GPS数据写入图片并保存到相册
    NSDictionary * gpsDict=[newLocation GPSDictionary];//CLLocation对象转换为NSDictionary
    if (metadata&& gpsDict) {
        [metadata setValue:gpsDict forKey:(NSString*)kCGImagePropertyGPSDictionary];
    }    
    [self writeCGImage:_image metadata:metadata];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败！");
}
@end
