//
//  CameraDemoViewController.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 5/8/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "CameraDemoViewController.h"
#import "AppDelegate.h"
#import "HomeTabBarController.h"

@interface CameraDemoViewController ()

@property (strong, nonatomic) IBOutlet UIButton *takePictureButton;
@property (strong, nonatomic) IBOutlet VideoStreamView *videoStreamView;

@end

@implementation CameraDemoViewController

#pragma mark - private methods
- (IBAction)onTakePictureBtnTouched:(id)sender
{
    [self.videoStreamView takePicture:^(UIImage *image){
        if (image) {
              ITTDINFO(@"take image successfully image info %@", image);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            });
        }
    }];
}

#pragma mark - lifecycle methods
- (id)init
{
    self = [super initWithNibName:@"CameraDemoViewController" bundle:nil];
    if (self) {
        self.navTitle = @"特效摄像头";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navTitle = @"特效摄像头";
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AppDelegate GetAppDelegate].tabBarController.tabBarHidden = TRUE;
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
    {
        // setup video stream view
        [_videoStreamView startCapture];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.takePictureButton];
}


- (void)viewDidUnload
{
    [self setTakePictureButton:nil];
    [super viewDidUnload];
}

#pragma mark - public methods
@end
