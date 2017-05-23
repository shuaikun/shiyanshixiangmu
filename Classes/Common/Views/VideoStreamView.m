//
//  VideoStreamView.m
//  CaptureImageFromCameraDemo
//
//  Created by zhou huajian on 11-7-19.
//  Copyright 2011年 itotemstudio. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "VideoStreamView.h"

@interface VideoStreamView()<UIGestureRecognizerDelegate>
{
    CGFloat                    _beginGestureScale;
    CGFloat                    _effectiveScale;
    AVCaptureDevicePosition    _devicePosition;                //current device position, default value is AVCaptureDevicePositionBack
    NSString                   *_captureSessionType;
    AVCaptureSession           *_captureSession;
    AVCaptureDeviceInput       *_deviceInput;
    AVCaptureStillImageOutput  *_stillImageOutput;
    AVCaptureVideoPreviewLayer *__weak _previewLayer;    
}

- (void)setupPinchGestaure;
- (void)setupAVCapture;
- (void)deviceOrientationDidChange;
- (void)configureDevice:(AVCaptureDevice*) device;
- (AVCaptureDevice*) getDeviceWithPosition:(AVCaptureDevicePosition)position;

@end

@implementation VideoStreamView


#pragma mark - lifecycle methods
- (void)dealloc
{
    ITTDINFO(@"videoStreamView is released");    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    if ([_captureSession isRunning]) {
        [_captureSession stopRunning];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
            [self setupPinchGestaure];
            [self setupAVCapture];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        }
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
        [self setupPinchGestaure];
        [self setupAVCapture];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

#pragma mark - private methods
- (AVCaptureDevice*) getDeviceWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];;
    AVCaptureDevice *device  = nil;
    for (device in devices) {
        if (([device hasMediaType:AVMediaTypeVideo]) && 
            ([device position] == position) && 
            [device supportsAVCaptureSessionPreset:_captureSessionType]) {
            break;
        }
    }
    if (7.0 <= [[[UIDevice currentDevice] systemVersion] floatValue]) {
        AVCaptureDeviceFormat *bestFormat = nil;
        AVFrameRateRange *bestFrameRateRange = nil;
        for ( AVCaptureDeviceFormat *format in [device formats] ) {
            for ( AVFrameRateRange *range in format.videoSupportedFrameRateRanges ) {
                if ( range.maxFrameRate > bestFrameRateRange.maxFrameRate ) {
                    bestFormat = format;
                    bestFrameRateRange = range;
                }
            }
        }
        if (bestFormat) {
            if ([device lockForConfiguration:NULL] == YES ) {
                device.activeFormat = bestFormat;
                device.activeVideoMinFrameDuration = bestFrameRateRange.minFrameDuration;
                device.activeVideoMaxFrameDuration = bestFrameRateRange.minFrameDuration;
                [device unlockForConfiguration];
            }
        }
    }
    return device;
}

- (void)configureDevice:(AVCaptureDevice*) device
{
    [device lockForConfiguration:nil];
    if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
         device.focusMode = AVCaptureFocusModeContinuousAutoFocus;   
    }
    if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
         device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;   
    }
    if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
         device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;   
    }
    if ([device isFlashModeSupported:AVCaptureFlashModeOff]) {
         device.flashMode = AVCaptureFlashModeOff;   
    }
    if ([device isTorchModeSupported:AVCaptureTorchModeAuto]) {
         device.torchMode = AVCaptureTorchModeAuto;   
    }
    [device unlockForConfiguration];
}

- (void)setupPinchGestaure
{
    UIPinchGestureRecognizer *gestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    gestureRecognizer.delegate = self;
    [self addGestureRecognizer:gestureRecognizer];
}

- (void)setupAVCapture
{
    _effectiveScale = 1.0;
    //init capture session
    _captureSession = [[AVCaptureSession alloc] init];
    _captureSessionType = AVCaptureSessionPresetPhoto;
    if ([_captureSession canSetSessionPreset:_captureSessionType]) {
        [_captureSession setSessionPreset:_captureSessionType];
    }
    else{
        ITTDERROR(@"can not set capture sesstion!");
    }
        
    //get device default device position according to device position
    _devicePosition = AVCaptureDevicePositionBack;
    AVCaptureDevice *captureDevice = [self getDeviceWithPosition:_devicePosition];
    [self configureDevice:captureDevice];
    
    //add device input to session
    [_captureSession beginConfiguration];
    NSError *error = nil;
    _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];    
    if (_deviceInput) {
        [_captureSession addInput:_deviceInput];
    }    
    
    //add output to session
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];

    [_captureSession addOutput:_stillImageOutput];
    
    // Set Preview Layer.
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    _previewLayer.position = self.center;
    _previewLayer.frame = self.bounds;
    _previewLayer.orientation = UIDeviceOrientationPortrait;
    _previewLayer.automaticallyAdjustsMirroring = TRUE;
    _previewLayer.videoGravity = AVLayerVideoGravityResize;
    [self.layer addSublayer:_previewLayer];
    [_captureSession commitConfiguration];
}

- (void)layoutSubviews
{
    _previewLayer.frame = self.bounds;
}

#pragma mark - methods for caller

//switching between devices
- (void)switchDevice
{
    if (_devicePosition == AVCaptureDevicePositionBack) {
        _devicePosition = AVCaptureDevicePositionFront;
    }
    else {
        _devicePosition = AVCaptureDevicePositionBack;        
    }
    AVCaptureDevice *device = [self getDeviceWithPosition:_devicePosition];
    //device is null if running on simulator, just in case of crash on sinulator
    if (device) {
        [self configureDevice:device];    
        NSError *error = nil;
        
        [_captureSession beginConfiguration];    
        [_captureSession removeInput:_deviceInput];        
        _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (_deviceInput) {
            [_captureSession addInput:_deviceInput];
        }
        else {
            ITTDERROR(@"can not create specified device input!");
        }
        [_captureSession commitConfiguration];        
    }
}

- (void)startCapture
{
    if (![_captureSession isRunning]) {
        [_captureSession startRunning];   
    }
}

- (void)stopCapture
{
    if ([_captureSession isRunning]) {
        [_captureSession stopRunning];   
    }
}

- (void)takePicture:(void(^)(UIImage *image))didFinishCapture
{
	AVCaptureConnection *stillImageConnection = [_stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                   completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         if (imageSampleBuffer) {
             // trivial simple JPEG case
             NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
//        //save to photo library
//         CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
//                                                                     imageSampleBuffer,
//                                                                     kCMAttachmentMode_ShouldPropagate);
//         ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//         [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
//             if (error) {
//             }
//         }];
//         if (attachments) {
//             CFRelease(attachments);
//         }
//         [library release];
             UIImage *photoImg = [[UIImage alloc] initWithData:jpegData];
             didFinishCapture(photoImg);
         }
     }];
}

- (void)deviceOrientationDidChange
{
    ITTDINFO(@"deviceOrientationDidChange");
}

- (void)changeOrientation:(UIInterfaceOrientation)orientation
{
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            _previewLayer.orientation =  AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIInterfaceOrientationLandscapeRight:
            _previewLayer.orientation =  AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIInterfaceOrientationPortrait:
            _previewLayer.orientation =  AVCaptureVideoOrientationPortrait;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            _previewLayer.orientation =  AVCaptureVideoOrientationPortraitUpsideDown;
            break;            
        default:
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
		_beginGestureScale = _effectiveScale;
	}
	return YES;
}

// scale image depending on users pinch gesture
- (IBAction)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    ITTDINFO(@"- (IBAction)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer");
	BOOL allTouchesAreOnThePreviewLayer = YES;
	NSUInteger numTouches = [recognizer numberOfTouches];
    NSInteger i;
	for ( i = 0; i < numTouches; ++i ) {
		CGPoint location = [recognizer locationOfTouch:i inView:self];
		CGPoint convertedLocation = [_previewLayer convertPoint:location fromLayer:_previewLayer.superlayer];
		if ( ! [_previewLayer containsPoint:convertedLocation] ) {
			allTouchesAreOnThePreviewLayer = NO;
			break;
		}
	}	
	if (allTouchesAreOnThePreviewLayer) {
		_effectiveScale = _beginGestureScale * recognizer.scale;
		if (_effectiveScale < 1.0) {
			_effectiveScale = 1.0;
        }
		CGFloat maxScaleAndCropFactor = [[_stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        ITTDINFO(@"_effectiveScale %f", _effectiveScale);        
        ITTDINFO(@"maxScaleAndCropFactor %f", maxScaleAndCropFactor);                
		if (_effectiveScale > maxScaleAndCropFactor) {
			_effectiveScale = maxScaleAndCropFactor;
        }
		[CATransaction begin];
		[CATransaction setAnimationDuration:.025];
		[_previewLayer setAffineTransform:CGAffineTransformMakeScale(_effectiveScale, _effectiveScale)];
		[CATransaction commit];
        ITTDINFO(@"_previewLayer %@", _previewLayer);
	}
}

@end
