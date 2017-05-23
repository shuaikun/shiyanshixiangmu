//
//  SZNearByProductPhotoViewController.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-24.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByProductPhotoViewController.h"
#import "ITTImageView.h"
@interface SZNearByProductPhotoViewController ()<ITTImageViewDelegate>
{
    BOOL _statusBarIsHidden;
    UILabel *_titleLabel;
    ITTImageView *_imgView;
}
@end

@implementation SZNearByProductPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadView
{
    _statusBarIsHidden = [UIApplication sharedApplication].statusBarHidden;
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *bgView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bgView];
    self.pic.pic_url = [self.pic.pic_url stringFormatterWithStr:@"b"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 20, 44, 44);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"SZ_NEARBY_BACK.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(handleBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
   
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(266, 20, 44, 44);
    saveBtn.tag = 111;
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"SZ_NEARBY_SAVE.png"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(handleSaveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    [self loadBottomView];
    
    [self loadContentView];
}

- (void)loadBottomView
{
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-44, 320, 44)];
    grayView.backgroundColor = RGBCOLOR(60, 60, 60);
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _titleLabel.text = self.pic.title;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.center = CGPointMake(160, 22);
    _titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [grayView addSubview:_titleLabel];
    [self.view addSubview:grayView];
}

- (void)loadContentView
{
    _imgView = [[ITTImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.clipsToBounds = YES;
    _imgView.center = CGPointMake(160, self.view.centerY+10);
    _imgView.delegate = self;
    [_imgView loadImage:self.pic.pic_url placeHolder:[UIImage imageNamed:@"SZ_NEARBY_TOP_DEFAULT.png"]];
    [self.view addSubview:_imgView];
}

- (void)imageViewDidLoaded:(ITTImageView *)imageView image:(UIImage *)image
{
    CGSize size = image.size;
    float defaultRate = (self.view.bounds.size.height - 64 - 44 -60)/320;
    float rate = size.height/size.width;
    if (rate<defaultRate) {
        size = CGSizeMake(320, size.height*320/size.width);
        
    }else{
        size = CGSizeMake(320, self.view.bounds.size.height - 64 - 44 -60);
    }
    if (image!=nil) {
        _imgView.size = size;
       _imgView.image = image;
    }
    _imgView.center = CGPointMake(160, self.view.centerY+10);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleBackClick:(id)sender
{
    [[UIApplication sharedApplication]setStatusBarHidden:_statusBarIsHidden];
    [self popMasterViewController];
}

- (void)handleSaveClick:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(_imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [[ITTPromptView sharedPromptView]showMessage:@"保存失败"];
    } else {
        UIButton *savebtn = (UIButton *)[self.view viewWithTag:111];
        savebtn.enabled = NO;
        [[ITTPromptView sharedPromptView]showMessage:@"保存成功"];
    }
}



@end
