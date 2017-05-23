//
//  VideoStreamView.h
//  CaptureImageFromCameraDemo
//
//  Created by zhou huajian on 11-7-19.
//  Copyright 2011年 itotemstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

@interface VideoStreamView : UIView
{
}

@property (weak, nonatomic, readonly) AVCaptureVideoPreviewLayer *previewLayer;

- (void)switchDevice;           //switch device between back and front
- (void)startCapture;
- (void)stopCapture;
- (void)takePicture:(void(^)(UIImage *image))didFinishCapture;

- (void)changeOrientation:(UIInterfaceOrientation)orientation;

@end