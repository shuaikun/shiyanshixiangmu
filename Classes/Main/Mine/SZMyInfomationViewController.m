//
//  SZMyInfomationViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMyInfomationViewController.h"
#import "SZNameChangeViewController.h"
#import "SZUserInfoRequest.h"
#import "SZUserInfoModel.h"
#import "SZUserEditInfoRequest.h"
#import "ITTImageView.h"
#import "SZChangeImageView.h"

@interface SZMyInfomationViewController ()<ITTImageViewDelegate,SZChangeImageViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
@property (weak, nonatomic) IBOutlet UIButton *secretButton;
@property (weak, nonatomic) IBOutlet ITTImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) NSString *gender;

- (IBAction)onModifyNameButtonClicked:(id)sender;
- (IBAction)onChangeSexButtonClicked:(id)sender;
- (IBAction)onChangeImageButtonClicked:(id)sender;
- (IBAction)onRightButtonClicked:(id)sender;

@end

@implementation SZMyInfomationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _nameLabel.text = [[UserManager sharedUserManager] realName];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"个人信息"];
    _imageView.delegate = self;
    _imageView.enableTapEvent = YES;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 2;
    [_imageView loadImage:[[UserManager sharedUserManager] portraitUrl] placeHolder:[UIImage imageNamed:@"SZ_Mine_Default_Head.png"]];
    [self.view bringSubviewToFront:_rightButton];
    [self changeSexViewWithGender:[[UserManager sharedUserManager] gender]];
    [self beginUserInfoRequest];
}

- (void)changeSexViewWithGender:(NSString *)gend
{
    int gender = [gend intValue];
    if(gender == USER_GENDER_MALE){
        _manButton.enabled = NO;
        _womanButton.enabled = YES;
        _secretButton.enabled = YES;
        _gender = @"1";
    }
    else if(gender == USER_GENDER_FEMALE){
        _manButton.enabled = YES;
        _womanButton.enabled = NO;
        _secretButton.enabled = YES;
        _gender = @"2";
    }
    else{
        _manButton.enabled = YES;
        _womanButton.enabled = YES;
        _secretButton.enabled = NO;
        _gender = @"0";
    }
}

- (void)imageViewDidClicked:(ITTImageView *)imageView
{
    SZChangeImageView *changeImageView = [SZChangeImageView loadFromXib];
    changeImageView.center = self.view.center;
    changeImageView.delegate = self;
    [changeImageView showInView:self.view];
}

- (void)changeImageViewChoosePictureButtonClicked
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}

- (void)changeImageViewTakePictureButtonClicked
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
    else{
        [PROMPT_VIEW showMessage:@"当前设备不支持照相功能"];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *originImg = [info objectForKey:UIImagePickerControllerEditedImage];
        _imageView.image = originImg;
        NSData *imgData = UIImageJPEGRepresentation(originImg, 1);
        [self beginUserEditInfoRequestWithImageData:imgData];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)beginUserInfoRequest
{
    __weak typeof(self) weakSelf = self;
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken){
        typeof(weakSelf) strongSelf = weakSelf;
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:SZINDEX_USER_INFO_METHOD forKey:PARAMS_METHOD_KEY];
        [paramDict setObject:userId forKey:PARAMS_USER_ID];
        NSLog(@"paramDict is %@",paramDict);
        [SZUserInfoRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                SZUserInfoModel *model = [request.handleredResult objectForKey:@"model"];
                if(model){
                    NSLog(@"model is %@",model);
                    [strongSelf updateViewDataWithModel:model];
                    [[UserManager sharedUserManager] storeUserInfoWithPortraitUrl:model.portrait];
                }
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
        }];
    }];
}

- (void)updateViewDataWithModel:(SZUserInfoModel *)model
{
    if(IS_STRING_NOT_EMPTY(model.portrait)){
        [_imageView loadImage:model.portrait placeHolder:[UIImage imageNamed:@"SZ_Mine_Info_Placeholder.png"]];
    }
    _nameLabel.text = model.real_name;
    [self changeSexViewWithGender:model.gender];
}

- (void)beginUserEditInfoRequestWithImageData:(NSData *)imgData
{
    __weak typeof(self) weakSelf = self;
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken){
        typeof(weakSelf) strongSelf = weakSelf;
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:SZINDEX_USER_EDITINFO_METHOD forKey:PARAMS_METHOD_KEY];
        [paramDict setObject:userId forKey:PARAMS_USER_ID];
        [paramDict setObject:strongSelf.gender forKey:@"gender"];
        if(imgData){
            NSLog(@"imgData is %@",imgData);
            [paramDict setObject:imgData forKey:@"portrait"];
        }
        NSLog(@"paramDict is %@",paramDict);
        [SZUserEditInfoRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                //refresh
                [[UserManager sharedUserManager] storeUserInfoWithGender:_gender];
                [[ITTPromptView sharedPromptView] showMessage:@"修改成功"];
                NSString *portrait = [request.handleredResult objectForKey:@"portrait"];
                [[UserManager sharedUserManager] storeUserInfoWithPortraitUrl:portrait];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onModifyNameButtonClicked:(id)sender
{
    SZNameChangeViewController *nameChangeViewController = [[SZNameChangeViewController alloc] initWithNibName:@"SZNameChangeViewController" bundle:nil];
    [self pushMasterViewController:nameChangeViewController];
}

- (IBAction)onChangeSexButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int tag = button.tag;
    switch (tag) {
        case kTagCurrentUserSexMan:
        {
            _manButton.enabled = NO;
            _womanButton.enabled = YES;
            _secretButton.enabled = YES;
            _gender = @"1";
            [self saveNewSex];
        }
            break;
        case kTagCurrentUserSexWoman:
        {
            _manButton.enabled = YES;
            _womanButton.enabled = NO;
            _secretButton.enabled = YES;
            _gender = @"2";
            [self saveNewSex];
        }
            break;
        case kTagCurrentUserSexSecret:
        {
            _manButton.enabled = YES;
            _womanButton.enabled = YES;
            _secretButton.enabled = NO;
            _gender = @"0";
            [self saveNewSex];
        }
            break;
        default:
        {
            
        }
            break;
    }
}

- (IBAction)onChangeImageButtonClicked:(id)sender
{
    SZChangeImageView *changeImageView = [SZChangeImageView loadFromXib];
    changeImageView.center = self.view.center;
    [changeImageView showInView:self.view];
}

- (void)saveNewSex
{
    NSLog(@"[[UserManager sharedUserManager] gender] is %@",[[UserManager sharedUserManager] gender]);
    NSLog(@"_gender is %@",_gender);
    if(![[[UserManager sharedUserManager] gender] isEqualToString:_gender]){
        [self beginUserEditInfoRequestWithImageData:nil];
    }
}

- (IBAction)onRightButtonClicked:(id)sender
{
    if(![[[UserManager sharedUserManager] gender] isEqualToString:_gender]){
        [self beginUserEditInfoRequestWithImageData:nil];
    }
}

@end








